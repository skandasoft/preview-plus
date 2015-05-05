{TextEditor}  = require 'atom'
{$, ScrollView} = require 'atom-space-pen-views'

module.exports =
class PanelView extends ScrollView
  constructor: (@title,@src,@grammar)->
    @editor = new TextEditor mini:false
    @attach()
    super

  @content: ()->
    @div class: 'atom-text-panel', =>
      @div class:'resizer-drag', mousedown: 'dragStart'
      @tag 'atom-text-editor'

  initialize:  ->
    @editor = @view().find('atom-text-editor')[0].getModel()
    @editor.setText(@src)
    view = @view()
    @editor.setGrammar(@grammar)
    view.find('atom-text-editor').css 'overflow','scroll'

  showPanel: (src,grammar)->
    @show()
    view = @view()
    view.css 'max-height', '200px'
    @editor.setText(src)
    @editor.setGrammar(grammar)
    @editor.setCursorScreenPosition([1,1])

  getTitle: ->
    @title

  getModel: ->
    @editor

  dragStart: (evt,ele)->
      view = @view()
      editorHeight = view.find('atom-text-editor').height()
      top = view.parent().position().top
      ht = view.height()
      width = view.width()
      view.css position :'fixed'
      view.css top: evt.pageY
      view.css width: width
      view.css 'max-height', ''
      view.css height: ht
      $(document).mousemove (evt,ele)=>
        view = @view()
        view.css top: evt.pageY
        height = ht +  top - evt.pageY
        height = height * -1 if height < 0
        textEditorHeight = editorHeight +  top - evt.pageY
        textEditorHeight = textEditorHeight * -1 if textEditorHeight < 0
        view.find('atom-text-editor').css height: textEditorHeight
        view.css height: height
      $(document).mouseup (evt,ele)=>
        view = @view().view()
        view.css position :'static'
        $(document).unbind('mousemove')

  attach: ->
    $(document).keyup (e)=>
      if e.keyCode == 27 # Escape Key
        @detach()

  detach: (hide=true)->
    # super
    # @unsubscribe()
    @hide() if hide
