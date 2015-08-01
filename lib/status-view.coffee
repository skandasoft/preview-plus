{View,SelectListView} = require 'atom-space-pen-views'

exec = require('child_process').exec

$ = require 'jquery'
class CompilerView extends SelectListView
  initialize: (items,@statusView,item)->
    super
    @addClass 'overlay from-top'
    @setItems items
    atom.workspace.addModalPanel item:@
    @focusFilterEditor()
    if @statusView.compileTo.children()?.length > 0
      @selectItemView @list.find("li").has('span')
    else
      compileTo = @statusView.compileTo.text()
      @selectItemView @list.find("li:contains('#{compileTo}')")

  viewForItem: (item)->
    if typeof item is 'string'
      "<li>#{item}</li>"
    else
      $li = $('<li></li>').append item.element
      $li.data('selectList',@)
      # item
  confirmed: (item)->
    @statusView.updateCompileTo(item)
    if typeof item is 'string'
      @cancel()

  cancelled: ->
    @parent().remove()

class BrowserView extends View
  initialize: (@model)->
    @browser = @model.config.browser[process.platform]
  @content: ->
    # @li click:'openBrowser', =>
      @span class: 'icon-browser-plus', click:'openBrowser', =>
        @span class:"icon-chrome",click:'openChrome'
        @span class:"icon-ie",click:'openIE'
        @span class:"icon-firefox",click:'openFirefox'
        @span class:"icon-opera",click:'openOpera'

  openChrome: (evt)->
    @open(@browser?.CHROME?.cmd,evt)

  openIE: (evt)->
    @open(@browser?.IE?.cmd,evt)

  openFirefox: (evt)->
    @open(@browser?.FF?.cmd,evt)

  openOpera: (evt)->
    @open(@browser?.OPERA?.cmd,evt)

  openBrowser: (evt)->
    @open(@browser?.CHROME?.cmd,evt)

  openSafari: (evt)->
    @open(@browser?.SAFARI?.cmd,evt)

  open: (cmd,evt)->
    unless cmd
      alert 'Please maintain browser commands for your OS in config'
      return false
    editor = atom.workspace.getActiveTextEditor()
    fpath = editor.getPath()
    ls = exec "#{cmd} #{fpath}"
    li = $(evt.target).closest('li')
    if li.length > 0 and li.data('selectList')?
      # li.data('selectList').cancel()
      li.data('selectList').parent().remove()
    return false

class StatusView extends View
  @content: ->
    @div class:'preview-plus-status inline-block', =>
      @span "Live",class:"live off ",outlet:"live", click:'toggleLive'
      @span class:"compileTo",outlet:"compileTo", click:'compile'
      @span "▼", class:"enums",outlet:"enums", click:'compilesTo'

  initialize: (@model)->
    @statusBarTile = @model.statusBar.addRightTile {item:@, priority:9999}
    @clicks = 0

  compilesTo: ->
    key = @model.getGrammar(@editor)
    # to =  @editor.get('preview-plus.compileTo')
    to =  @editor['preview-plus.compileTo']
    items = for item in @model.config[key]["enum"]
               if view = @model.config[key][item].view
                 new view(@model)
               else
                 item
    new CompilerView items,@,to

  compile: (evt)->
    @clicks++
    if @clicks is 1
      timer = setTimeout =>
        evt.originalEvent.target.getClass
        @clicks = 0
        @model.toggle()
      ,300
    else
      # if @editor.get('preview-plus.htmlp')?
      if @editor['preview-plus.htmlp']?
        clearTimeout timer
        # cproject = atom.project.get('preview-plus.cproject')
        @updateCompileTo if @cproject?.htmlu then 'htmlu' else 'htmlp'
        @clicks = 0
  getCompileTo: (compileTo)->
    compileToKey = compileTo
    compileToView = undefined
    key = @model.getGrammar(@editor)
    @model.config[key]["enum"]
    if @model.config[key][compileTo]
      compileToView = @model.config[key][compileTo].view if @model.config[key][compileTo].view
    else
      for item in @model.config[key]["enum"]
        if @model.config[key][item].view?
          compileToKey = item if @model.config[key][item].view is compileTo
          compileToView = new @model.config[key][item].view(@model)
    { compileToKey, compileToView }

  updateCompileTo: (compileTo)->
    {compileToKey,compileToView} = @getCompileTo(compileTo)
    if compileToKey is 'htmlp'
      # @editor.set('preview-plus.htmlp',true)
      @editor['preview-plus.htmlp'] = true
    else
      # @editor.set('preview-plus.htmlp',false) if @editor.get('preview-plus.htmlp')?
      @editor['preview-plus.htmlp'] = false  if @editor['preview-plus.htmlp']?
    @editor['preview-plus.compileTo'] = compileToKey
    # @editor.set('preview-plus.compileTo',compileToKey)
    if compileToView
      @compileTo.empty().append compileToView
    else
      @compileTo.empty().text compileToKey
      @model.toggle()

  show: ->
    super

  toggleLive: ->
    # live = @editor.get 'preview-plus.livePreview'
    live = @editor['preview-plus.livePreview']
    @live.toggleClass 'off'
    # @editor.set 'preview-plus.livePreview', !live
    @editor['preview-plus.livePreview'] = !live
    if live
      # liveSubscription = @editor.get 'preview-plus.livePreview-subscription'
      liveSubscription = @editor['preview-plus.livePreview-subscription']
      if liveSubscription
        idx = @model.liveEditors.indexOf @editor
        @model.liveEditors.splice(idx,1) if idx > -1
        liveSubscription.dispose()
    else
      @model.toggle()
  setLive: ->
    # live = @editor.get('preview-plus.livePreview') ?  atom.config.get('preview-plus.livePreview')
    live = @editor['preview-plus.livePreview'] ?  atom.config.get('preview-plus.livePreview')
    # @editor.set('preview-plus.livePreview', live)
    @editor['preview-plus.livePreview'] = live
    @live.toggleClass 'off',!live
    @live.toggleClass 'on',atom.config.get('preview-plus.livePreview')

  setCompilesTo: (@editor)->
    try
      @show()
      key = @model.getGrammar(@editor)
      # unless @editor.get('preview-plus.compileTo')
      unless @editor['preview-plus.compileTo']
        toKey = @model.getCompileTo(@editor,key)
        # @editor.set('preview-plus.compileTo',toKey)
        @editor['preview-plus.compileTo'] = toKey
        if @model.config[key].cursorFocusBack
          @editor['preview-plus.cursorFocusBack'] = @model.config[key].cursorFocusBack
          # @editor.set('preview-plus.cursorFocusBack',@model.config[key].cursorFocusBack)
        if @model.config[key][toKey].cursorFocusBack
          # @editor.set('preview-plus.cursorFocusBack',@model.config[key][toKey].cursorFocusBack)
          @editor['preview-plus.cursorFocusBack'] =  @model.config[key][toKey].cursorFocusBack
        # @editor.set('preview-plus.enum',true) if @model.config[key]["enum"]?.length > 1
        @editor['preview-plus.enum']  = true if @model.config[key]["enum"]?.length > 1
        # if @editor.set('preview-plus.htmlp',htmlp) and 'htmlp' in @model.config[key].enums
        # if (not @editor.get('preview-plus.htmlp')? ) and
        if (not @editor['preview-plus.htmlp']? ) and
           ('htmlp' in @model.config[key]["enum"] or 'htmlu' in @model.config[key]["enum"])
          # @editor.set 'preview-plus.htmlp',atom.config.get('preview-plus.htmlp')
          @editor['preview-plus.htmlp'] = atom.config.get('preview-plus.htmlp')

      # compileToView = compileTo = @editor.get('preview-plus.compileTo')
      compileToView = compileTo = @editor['preview-plus.compileTo']
      # if  @editor.get('preview-plus.htmlp')
      if  @editor['preview-plus.htmlp']
        #  compileToKey = compileTo = if 'htmlu' in @model.config[key]["enum"] and atom.project.get('preview-plus.cproject')?.htmlu
         compileToKey = compileTo = if 'htmlu' in @model.config[key]["enum"] and @cproject?.htmlu
                       'htmlu'
                     else
                       'htmlp'
      else
        {compileToKey,compileToView} = @getCompileTo compileTo
      # @editor.set 'preview-plus.compileTo', compileToKey
      @editor['preview-plus.compileTo'] = compileToKey
      if compileToView
        @compileTo.empty().append compileToView
      else
        @compileTo.empty().text compileToKey

      @compileTo.toggleClass 'htmlp',atom.config.get('preview-plus.htmlp') #and @compileTo.text() is 'htmlp'
      # @enums.show() if @editor.get('preview-plus.enum')
      @enums.show() if @editor['preview-plus.enum']
      @setLive()
    catch e
      @hide()
      console.log 'Not a Preview-Plus Editor',e
  hide: ->
    super
  destroy: ->
module.exports = { StatusView, BrowserView }
