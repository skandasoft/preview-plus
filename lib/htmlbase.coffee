{$, $$,$$$, View}  = require 'atom'
module.exports =

class HTMLBase extends View

  @content: ->
    project = atom.project.get 'preview-plus.cproject'
    @div class:'preview-plus-base', =>
      @div class:'base',outlet:'base', =>
        @span "HTML Base"
        @input type:'text',id:'href',value:"#{project.base}"
      @div class:'url',outlet:'url', =>
        @span "HTML URL"
        @input type:'text',id:'url',value:"#{project.url}"
      @div =>
        @span "Use Default - URL/Local Server For HTML Preview  "
        if project.htmlu
          @input type:'checkbox',id:'htmlu', checked:'checked'
        else
          @input type:'checkbox',id:'htmlu'
      @div =>
        @input type:'button',value:'confirm',click:'onConfirm'

  setURL: (evt,ele)->
    @url.toggle()
    @base.toggle()

  initialize: (@model)->
    atom.commands.add @element,
      'core:confirm': => @onConfirm()
      'core:cancel': => @cancel()
    @element.onBlur =  => @close()

  close: ->
    atom.workspace.getActivePane().activate()
    @remove()

  cancel: ->
    @close()

  onConfirm: ->
    project = atom.project.get('preview-plus.cproject')
    project.htmlu = @find('#htmlu').prop('checked')
    project.url = @find('#url').val()
    project.base = @find('#href').val()
    atom.project.set('preview-plus.cproject',project)
    @model.previewStatus?.setCompilesTo atom.workspace.getActivePaneItem()
    @model.toggle()
    @close()