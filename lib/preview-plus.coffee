path = require 'path'
_ = require 'lodash'
{CompositeDisposable} = require 'atom'
jQuery = require 'jquery'
loophole = require 'loophole'
PPError = (@name,@message)->
PPError.prototype = new Error()
PanelView = require './panel-view'
Watch = require './watch'

module.exports =
  config: require './config'

  toggleLive: ->
    atom.config.set 'preview-plus.livePreview', !atom.config.get 'preview-plus.livePreview'
    @previewStatus.live.toggleClass 'on'

  toggleHTML: ->
      atom.config.set 'preview-plus.htmlp', !atom.config.get 'preview-plus.htmlp'
      if editor = atom.workspace.getActiveTextEditor()
        key = @getGrammar editor
        if atom.config.get('preview-plus.htmlp')
          @previewStatus.updateCompileTo('htmlp') if 'htmlp' in @config[key]["enum"]
        else
          @previewStatus.updateCompileTo atom.config.get "preview-plus.#{key}"

  showConfig: ->
    # srcdir = atom.project.get('preview-plus.srcdir')
    fileName = "#{__dirname}/config.coffee"
    atom.workspace.open fileName, searchAllPanes:true

  updateProject: ->
    @project = @state?.projectState or {}
    projectPath = atom.project.getPaths()[0]
    @cproject = @project[projectPath] ?= {}
    @cproject.base ?= projectPath
    @cproject.url ?= 'http://localhost'
    @srcdir = __dirname
    # atom.project.set 'preview-plus.project',project
    # atom.project.set 'preview-plus.cproject',cproject
    # atom.project.set 'preview-plus.srcdir', __dirname


  consumeStatusBar: (statusBar)->
    @statusBar = statusBar
    {StatusView} = require './status-view'
    @previewStatus = new StatusView(@)
    activePane = atom.workspace.getActivePaneItem()
    @previewStatus.setCompilesTo activePane

  activate: (@state) ->
    # atom.project.set 'preview-plus.srcdir', __dirname
    @updateProject()
    atom.project.onDidChangePaths @updateProject

    atom.workspace.onDidChangeActivePaneItem (activePane)=>
      return unless activePane
      @previewStatus?.setCompilesTo activePane
      subscribe?.dispose?()
      subscribe = activePane.onDidChangeGrammar?  (grammar)->
        # activePane.set('preview-plus.compileTo')
        # activePane['preview-plus.compileTo'] = grammar.scopeName
        _this.previewStatus?.setCompilesTo activePane

    atom.config.onDidChange 'preview-plus.livePreview', (obj)=>
      if obj.newValue
      else
        @subscriptions.dispose()
        @subscriptions = new CompositeDisposable()
        @liveEditors = []
      editors = atom.workspace.getTextEditors()
      for editor in editors
        # if editor.get('preview-plus.livePreview')?
        #   editor.set('preview-plus.livePreview',obj.newValue)

        if editor['preview-plus.livePreview']?
          editor['preview-plus.livePreview'] = obj.newValue
      if atom.workspace.getActiveTextEditor()
        if obj.newValue
          @previewStatus.live.removeClass 'off'
          @toggle()
        else
          @previewStatus.live.addClass 'off'

    atom.commands.add 'atom-workspace', 'preview-plus:base': => @base()
    atom.commands.add 'atom-workspace', 'preview-plus:preview': => @toggle()
    atom.commands.add 'atom-workspace', 'preview-plus:toggleLive': => @toggleLive()
    atom.commands.add 'atom-workspace', 'preview-plus:toggleHTML': => @toggleHTML()
    atom.commands.add 'atom-workspace', 'preview-plus:config': => @showConfig()

    @liveEditors = @views = []

    @subscriptions = new CompositeDisposable()
    idx = null
    itemSets = atom.contextMenu.itemSets
    contextMenu = _.find itemSets, (item,itemIdx)->
                    idx = itemIdx
                    item.items[0]?.command is 'preview-plus:preview'

    if contextMenu?
      itemSets.splice idx,1
      itemSets.unshift contextMenu

    atom.contextMenu.itemSets = itemSets

  base: ->
    if @htmlBaseView
      @htmlBaseView.parent().show()
    else
      HTMLBaseView = require './htmlbase'
      @htmlBaseView = new HTMLBaseView @
      atom.workspace.addModalPanel item: @htmlBaseView
      @htmlBaseView.base.focus()

  toggle: (opts={})->
    try
      editor = null
      if opts.filePath
        editors = atom.workspace.getEditors()
        editor = ed for ed in editors when ed.getUri() is filePath
      else
        editor = atom.workspace.getActiveTextEditor()
      return unless editor
      {text,fpath} = @getText editor
      cfgs = atom.config.get('preview-plus')

      # if editor.get('preview-plus.livePreview') and not (editor in @liveEditors)
      if editor['preview-plus.livePreview'] and not (editor in @liveEditors)
        @liveEditors.push editor
        editor.buffer.stoppedChangingDelay = cfgs['liveMilliseconds']
        liveSubscription = editor.onDidStopChanging @listen
        # editor.set('preview-plus.livePreview-subscription',liveSubscription)
        editor['preview-plus.livePreview-subscription'] = liveSubscription
        @subscriptions.add liveSubscription

      @key = @getGrammar editor

      @toKey = @getCompileTo editor,@key
      return unless typeof @toKey is 'string'
      to = @config[@key][@toKey]
      lang = require "./lang/#{@key}"
      data = @getContent('data',text)
      options = @getContent('options',text)

      if to.options instanceof  Array and options
        to.options = _.union to.options, options #Array
      else
        to.options = jQuery.extend to.options, options #object
      # pass it
      # filePath = editor.getPath()
      # if @config[@key]['filePath']
      #   compiled = lang[to.compile](filePath,to.options,data)
      # else
      # if fpath and @key is 'html' and @toKey is 'htmlp'
      #   return atom.workspace.open "file://#{fpath}", split: @getPosition(editor)
      compiled = lang[to.compile](fpath,text,to.options,data)
    #
      if typeof compiled is 'string'
        @preview(editor,fpath,compiled)
      else
        dfd = compiled
        dfd.done (text)=>
          @preview(editor,fpath,text) if @compiled = text
        dfd.fail (text)->
          e = new Error()
          e.name = 'console'
          e.message = text
          throw e
    #
    catch e
      console.log e.message
      if e.name is 'alert'
        alert e.message
      else
        if e.location
          {first_line} = e.location
          error = text.split('\n')[0...first_line].join('\n')
        error += '\n'+e.toString().split('\n')[1..-1].join('\n')+'\n'+e.message
        @preview editor,fpath,error,true

  getContent: (tag,text)->
      regex = new RegExp("<pp-#{tag}>([\\s\\S]*?)</pp-#{tag}>")
      match = text.match(regex)
      if match? and match[1].trim()
        data = loophole.allowUnsafeEval ->
            eval "(#{match[1]})"

  preview: (editor,fpath,text,err=false)->
    activePane = atom.workspace.paneForItem(editor)
    split = @getPosition editor
    to = @config[@key]?[@toKey]
    return atom.confirm 'Cannot Preview' unless to
    ext = if err then "#{to.ext}.err" else to.ext
    # title = "preview-plus://#{path.dirname(editor.getPath())}/preview~#{editor.getTitle()}.#{ext}"
    if @toKey is 'htmlp'
      if text
        title = "browser-plus:///#{(editor.getPath() or editor.getTitle()).replace(/\\/g,"/")}.htmlp"
      else
        fpath = fpath.replace(/\\/g,"/")
        title = "file:///#{fpath}"
    else if @toKey is 'htmlu'
      return unless text
      title = text
      text = null
    else
      title = "preview~#{editor.getTitle()}.#{ext}"
    grammar = if to and not err then to.ext  else syntax = editor.getGrammar()
    syntax ?= atom.grammars.selectGrammar(grammar)
    if not err and editor.getSelectedText() and @toKey isnt 'htmlp'
      if @panelItem
        @panelItem.showPanel(text,syntax)
      else
        @panelItem = new PanelView(title,text,syntax)
        atom.workspace.addBottomPanel item: @panelItem
    else
      atom.workspace.open title,
                        searchAllPanes:true
                        split: split
                        src: text
              .then (@view)=>
                    unless @view.pp?.orgURI
                      @view.save = ->
                      @view.pp = {}
                      @view.pp.orgURI = editor.getURI()
                      # cproject = atom.project.get('preview-plus.cproject')
                      @watcher = new Watch(@cproject.watch) if @cproject.watch and not @watcher
                      # @view.addSubscription editor.onDidDestroy =>
                      @view.disposables.add editor.onDidDestroy =>
                        @view.destroy()
                      if @watcher
                        # subscription = @view.addSubscription @watcher.onDidChange =>
                        subscription = @view.disposables.add @watcher.onDidChange =>
                          @toggle {filePath:@view.pp.orgURI}
                      @views.push @view
                    if @key is 'html' and not text
                      # @view.setTextorUrl url:editor.getPath()
                      # @view.view.liveReload()
                    else
                      @view.setText(text)
                    if ext is 'htmlp'
                      console.log text
                    else
                      @view.setGrammar syntax
                      @view.moveToTop()
                    compiledPane = atom.workspace.getActivePane()
                    uri = @view.getURI()
                    if path.extname(title) is '.err'
                      uri = uri.replace '.err',''
                      errView = compiledPane.itemForURI uri
                    else
                      errView = compiledPane.itemForURI "#{uri}.err"
                    errView.destroy() if errView
                    activePane.activate() if @view.get('preview-plus.cursorFocusBack') or atom.config.get('preview-plus.cursorFocusBack')
  getUrl: (editor)->
      #get text under cursor
      text = editor.lineForScreenRow(editor.getCursor().getScreenRow()).text
      url = @getTextTag('pp-url',text) or @getTextTag('pp-url',editor.getText()) or path.basename editor.getPath()
      # "#{atom.project.get('preview-plus.cproject').url}/#{url}"
      "#{@cproject.url}/#{url}"
  getTextTag: (tag,text)->
      regex = new RegExp("<#{tag}>([\\s\\S]*?)</#{tag}>")
      match = text.match(regex)
      match[1].trim() if match?

  deactivate: ->
    @previewStatus.destroy()

  serialize: ->
    viewState = []
    for view in @views
      viewState.push if view.serialize?()
    previewState: @previewStatus.serialize()
    viewState : viewState
    projectState: @project
    # projectState: atom.project.get('preview-plus.project')

  listen: ->
      # view = atom.workspaceView.getActiveView()
      textEditor = atom.workspace.getActiveTextEditor()
      if textEditor
        view = atom.views.getView(textEditor)
        atom.commands.dispatch(view,'preview-plus:preview') if view

  getGrammar: (editor)->
    grammar = editor.getGrammar?()
    return false unless grammar
    key = null
    cfg = _.find @config, (val,k)->
              key = k
              val.name? and val.name is grammar.name
    # if it is not available
    cfg ?= _.find @config, (val,k)->
              key = k
              val.alias? and grammar.name in val.alias
    unless cfg
      editorPath = editor.getPath()
      ext = path.extname(editorPath)[1...]
    cfg ?= _.find @config, (val,k)->
              key = k
              val.fileTypes? and ext in val.fileTypes

    cfg ?= _.find @config, (val,k)->
                  key = k
                  regx = new RegExp(grammar.name,"gi")
                  return true if val.name? and val.name.search(regx) >= 0

    if cfg then key else throw new PPError 'alert','Set the Grammar for the Editor'

  getPosition: (editor)->
    activePane = atom.workspace.paneForItem(editor)
    paneAxis = activePane.getParent()
    paneIndex = paneAxis.getPanes().indexOf(activePane)
    orientation = paneAxis.orientation ? 'horizontal'
    if orientation is 'horizontal'
      if  paneIndex is 0 then 'right' else 'left'
    else
      if  paneIndex is 0 then 'down' else 'top'


  getCompileTo: (editor,key)->
    # unless toKey = editor.get('preview-plus.compileTo')
    unless toKey = editor['preview-plus.compileTo']
      toKey = atom.config.get("preview-plus.#{key}")
      # editor.set 'preview-plus.compileTo',toKey
      editor['preview-plus.compileTo'] = toKey
    toKey or throw new PPError 'alert', 'Cannot Preview'

  getText: (editor)->
    selected = editor.getSelectedText()
    # fpath = editor.getPath() unless ( selected or editor.get('preview-plus.livePreview'))
    fpath = editor.getPath() unless ( selected or editor['preview-plus.livePreview'] )
    text = selected or editor.getText()
    if text.length is 0 or !text.trim() then throw new PPError 'alert','No Code to Compile' else { text, fpath}
