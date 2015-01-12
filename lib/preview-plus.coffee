path = require 'path'
_ = require 'lodash'
{CompositeDisposable} = require 'atom'
jQuery = require 'jquery'
loophole = require 'loophole'
PPError = (@name,@message)->
PPError.prototype = new Error()
PreviewEditor = require './editor'
PanelView = require './panel-view'

module.exports =
  config: require './config'

  toggleLive: ->
    atom.config.set 'preview-plus.livePreview', !atom.config.get 'preview-plus.livePreview'

  toggleHTML: ->
      atom.config.set 'preview-plus.htmlp', !atom.config.get 'preview-plus.htmlp'
      if editor = atom.workspace.getActiveEditor()
        key = @getGrammar editor
        if atom.config.get('preview-plus.htmlp')
          @previewStatus.updateCompileTo('htmlp') if 'htmlp' in @config[key].enums
        else
          @previewStatus.updateCompileTo atom.config.get "preview-plus.#{key}"

  showConfig: ->
    fileName = "#{@srcdir}/config.coffee"
    atom.workspace.open fileName, searchAllPanes:true

  activate: (state) ->
    atom.workspace['preview-plus'] = @srcdir = __dirname
    atom.packages.onDidActivateAll =>
      {statusBar} = atom.workspaceView
      if statusBar?
          PreviewStatusView = require './status-view'
          @previewStatus = new PreviewStatusView(@)
          activePane = atom.workspace.getActivePaneItem()
          @previewStatus.setCompilesTo activePane

    atom.workspace.addOpener (uri)->
      return new PreviewEditor(uri) if path.extname(uri) is '.htmlp'

    atom.workspace.onDidChangeActivePaneItem (activePane)=>
      return unless activePane
      @previewStatus?.setCompilesTo activePane
      subscribe?.dispose?()
      subscribe = activePane.onDidChangeGrammar?  ->
        activePane.set('preview-plus.compileTo')
        _this.previewStatus.setCompilesTo activePane

    atom.config.onDidChange 'preview-plus.livePreview', (obj)=>
      if obj.newValue
      else
        @subscriptions.dispose()
        @subscriptions = new CompositeDisposable()
        @liveEditors = []
      editors = atom.workspace.getEditors()
      for editor in editors
        if editor.get('preview-plus.livePreview')?
          editor.set('preview-plus.livePreview',obj.newValue)
          @previewStatus.live.toggleClass 'on'

    atom.commands.add 'atom-workspace', 'preview-plus:preview': => @toggle()
    atom.commands.add 'atom-workspace', 'preview-plus:toggleLive': => @toggleLive()
    atom.commands.add 'atom-workspace', 'preview-plus:toggleHTML': => @toggleHTML()
    atom.commands.add 'atom-workspace', 'preview-plus:config': => @showConfig()

    @liveEditors = []
    @subscriptions = new CompositeDisposable()
    idx = null
    itemSets = atom.contextMenu.itemSets
    contextMenu = _.find itemSets, (item,itemIdx)->
                    idx = itemIdx
                    item.items[0].command is 'preview-plus:preview'

    if contextMenu?
      itemSets.splice idx,1
      itemSets.unshift contextMenu

    atom.contextMenu.itemSets = itemSets

  toggle: ->

    try
      return unless editor = atom.workspace.getActiveEditor()
      text = @getText editor
      cfgs = atom.config.get('preview-plus')

      if editor.get('preview-plus.livePreview') and not (editor in @liveEditors)
        @liveEditors.push editor
        editor.buffer.stoppedChangingDelay = cfgs['liveMilliseconds']
        liveSubscription = editor.onDidStopChanging @listen
        editor.set('preview-plus.livePreview-subscription',liveSubscription)
        @subscriptions.add liveSubscription

      @key = @getGrammar editor

      if editor.get('preview-plus.htmlp')
        @toKey = 'htmlp'
      else
        @toKey = @getCompileTo editor,@key
      to = @config[@key][@toKey]
      console.log @key
      lang = require "./lang/#{@key}"
      data = @getContent('data',text)
      options = @getContent('options',text)

      if to.options instanceof  Array and options
        to.options = _.union to.options, options #Array
      else
        to.options = jQuery.extend to.options, options #object
      # pass it
      compiled = lang[to.compile](text,to.options,data)
    #
      if typeof compiled is 'string'
        @preview(editor,compiled)
      else
        dfd = compiled
        dfd.done (text)=>
          @preview(editor,text) if @compiled = text
        dfd.fail (text)=>
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
        @preview editor,error,true

  getContent: (tag,text)->
      regex = new RegExp("<pp-#{tag}>([\\s\\S]*?)</pp-#{tag}>")
      match = text.match(regex)
      if match? and match[1].trim()
        data = loophole.allowUnsafeEval ->
            eval "(#{match[1]})"

  preview: (editor,text,err=false)->
    # otherwise check the individual
    activePane = atom.workspace.paneForItem(editor)
    split = @getPosition activePane
    to = @config[@key]?[@toKey]
    alert 'Cannot Preview' unless to
    ext = if err then "#{to.ext}.err" else to.ext
    title = "preview~#{editor.getTitle()}.#{ext}"
    grammar = if to and not err then to.ext  else syntax = editor.getGrammar()
    syntax ?= atom.syntax.selectGrammar(grammar)
    if not err and editor.getSelectedText() and @toKey isnt 'htmlp'
      if @panelItem
        @panelItem.showPanel(text,syntax)
      else
        @panelItem = new PanelView(title,text,syntax)
        atom.workspace.addBottomPanel item: @panelItem
    else
      view = atom.workspace.open title,
                        searchAllPanes:true
                        split: split
              .then (view)->
                    view.setText(text)
                    if ext is 'htmlp'
                      console.log text
                    else
                      view.setGrammar syntax
                      view.moveCursorToTop()
                    compiledPane = atom.workspace.getActivePane()
                    uri = view.getUri()
                    if path.extname(title) is '.err'
                      uri = uri.replace '.err',''
                      errView = compiledPane.itemForUri uri
                    else
                      errView = compiledPane.itemForUri "#{uri}.err"
                    errView.destroy() if errView
                    activePane.activate() if view.get('preview-plus.cursorFocusBack') or atom.config.get('preview-plus.cursorFocusBack')
  deactivate: ->
    @view.destroy()

  serialize: ->
    viewState: @view.serialize()

  listen: ->
      view = atom.workspaceView.getActiveView()
      atom.commands.dispatch(view[0],'preview-plus:preview')

  getGrammar: (editor)->
    grammar = editor.getGrammar()
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

  getPosition: (activePane)->
    paneAxis = activePane.getParent()
    paneIndex = paneAxis.getPanes().indexOf(activePane)
    orientation = paneAxis.orientation ? 'horizontal'
    if orientation is 'horizontal'
      if  paneIndex is 0 then 'right' else 'left'
    else
      if  paneIndex is 0 then 'down' else 'top'


  getCompileTo: (editor,key)->
    unless toKey = editor.get('preview-plus.compileTo')
      toKey = atom.config.get("preview-plus.#{key}")
      editor.set 'preview-plus.compileTo',toKey
    toKey or throw new PPError 'alert', 'Cannot Preview'

  getText: (editor)->
    selected = editor.getSelectedText()
    text = selected or editor.getText()
    if text.length is 0 or !text.trim() then throw new PPError 'alert','No Code to Compile' else text
