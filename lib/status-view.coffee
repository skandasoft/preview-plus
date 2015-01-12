{View,SelectListView} = require("atom")

class CompilerView extends SelectListView
  initialize: (items,@statusView,item)->
    super
    @addClass 'overlay from-top'
    @setItems items
    atom.workspaceView.append(@)
    @focusFilterEditor()
    compileTo = @statusView.compileTo.text()
    @selectItemView @list.find("li:contains('#{compileTo}')")

  viewForItem: (item)->
    "<li>#{item}</li>"

  confirmed: (item)->
    @statusView.updateCompileTo(item)
    @cancel()

class StatusView extends View
  @content: ->
    @div class:'preview-plus-status inline-block', =>
      @span "Live",class:"live ",outlet:"live", click:'toggleLive'
      @span class:"compileTo",outlet:"compileTo", click:'compile'
      @span "▼", class:"enums",outlet:"enums", click:'compilesTo'

  initialize: (@model)->
    atom.workspaceView.statusBar?.appendRight @
    @clicks = 0

  compilesTo: ->
    key = @model.getGrammar(@editor)
    to =  @editor.get('preview-plus.compileTo')
    new CompilerView @model.config[key].enums,@,to

  compile: ->
    @clicks++
    if @clicks is 1
      timer = setTimeout =>
        @clicks = 0
        @model.toggle()
      ,300
    else
      if @editor.get('preview-plus.htmlp')?
        clearTimeout timer
        @updateCompileTo('htmlp')
        @clicks = 0

  updateCompileTo: (compileTo)->
    if compileTo is 'htmlp'
      @editor.set('preview-plus.htmlp',true)
    else
      @editor.set('preview-plus.htmlp',false) if @editor.get('preview-plus.htmlp')?
    @editor.set('preview-plus.compileTo',compileTo)
    @compileTo.text compileTo
    @compileTo.toggleClass 'htmlp', compileTo is 'htmlp'
    @model.toggle()

  show: ->
    super
  toggleLive: ->
    live = @editor.get 'preview-plus.livePreview'
    @live.toggleClass 'on'
    @editor.set 'preview-plus.livePreview', !live
    if live
      liveSubscription = @editor.get 'preview-plus.livePreview-subscription'
      if liveSubscription
        idx = @model.liveEditors.indexOf @editor
        @model.liveEditors.splice(idx,1) if idx > -1
        liveSubscription.dispose()
    else
      @model.toggle()
  setLive: ->
    live = @editor.get('preview-plus.livePreview') ?  atom.config.get('preview-plus.livePreview')
    @editor.set('preview-plus.livePreview', live)
    @live.toggleClass('on',live)

  setCompilesTo: (@editor)->
    try
      @show()
      unless @editor.get('preview-plus.compileTo')
        key = @model.getGrammar(@editor)
        toKey = @model.getCompileTo(@editor,key)
        @editor.set('preview-plus.compileTo',toKey)
        if @model.config[key].cursorFocusBack
          @editor.set('preview-plus.cursorFocusBack',@model.config[key].cursorFocusBack)
        if @model.config[key][toKey].cursorFocusBack
          @editor.set('preview-plus.cursorFocusBack',@model.config[key][toKey].cursorFocusBack)
        @editor.set('preview-plus.enums',true) if @model.config[key].enums?.length > 1
        # if @editor.set('preview-plus.htmlp',htmlp) and 'htmlp' in @model.config[key].enums
        if (not @editor.get('preview-plus.htmlp')? ) and 'htmlp' in @model.config[key].enums
        #   @updateCompileTo('htmlp') if htmlp = atom.config.get('preview-plus.htmlp') and not @editor.get('preview-plus.htmlp')?
          @editor.set 'preview-plus.htmlp',atom.config.get('preview-plus.htmlp')


      @compileTo.text if @editor.get('preview-plus.htmlp') then 'htmlp' else @editor.get('preview-plus.compileTo')
      @compileTo.toggleClass 'htmlp',atom.config.get('preview-plus.htmlp') and @compileTo.text() is 'htmlp'
      @enums.show() if @editor.get('preview-plus.enums')
      @setLive()
    catch e
      @hide()
      console.log 'Not a Preview-Plus Editor'
  hide: ->
    super
  destroy: ->
module.exports = StatusView
