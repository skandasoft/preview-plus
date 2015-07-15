{$, View} = require 'atom-space-pen-views'

Watch = require './watch'
module.exports =

class HTMLBase extends View

  @content: ->
    # project = atom.project.get 'preview-plus.cproject'
    project = @cproject
    project.watch ?= ''
    @div class:'preview-plus-base', =>
      @div class:'base',outlet:'base', =>
        @span "HTML Base"
        @input class:'native-key-bindings',type:'text',id:'href',value:"#{project.base}"
      @div class:'url',outlet:'url', =>
        @span "HTML URL"
        @input class:'native-key-bindings', type:'text',id:'url',value:"#{project.url}"
      @div class:'watch',outlet:'watch', =>
        @span "Watch Files/Dir"
        @input class:'native-key-bindings', type:'text',id:'watch',value:"#{project.watch}",placeholder:"#{project.base}/stylesheets/*.css"
        @span "(separate by ',' & '*/glob/!' are allowed)"
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
    @element.onblur =  => @close

  close: ->
    atom.workspace.getActivePane().activate()
    @parent().hide()

  cancel: ->
    @close()


  onConfirm: ->
    # cproject = atom.project.get('preview-plus.cproject')
    @cproject.htmlu = @find('#htmlu').prop('checked')
    @cproject.url = @find('#url').val()
    @cproject.base = @find('#href').val()
    @cproject.watch = @find('#watch').val()
    # atom.project.set('preview-plus.cproject',cproject)
    #project = atom.project.get('preview-plus.project')
    for key,val of @cproject
      @project[key] = val
    # atom.project.set('preview-plus.project',project)
    @model.previewStatus?.setCompilesTo atom.workspace.getActivePaneItem()
    @model.watcher.chokidar?.unwatch?(paths) if paths = @model.watcher?.paths
    @model.watcher?.chokidar?.close()
    @model.watcher = new Watch(w) if w = @cproject.watch
    @model.toggle()
    @close()
