{Disposable,Emitter,$, $$,$$$} = require 'atom'
{Model} = require 'theorist'
path = require 'path'
module.exports =
  class HTMLEditor extends Model
    @disposable = new Disposable()
    constructor: (@uri)->

    setText: (text)->
      view = atom.views.getView(@)
      webview = $(view.children[0])
      webview.css
        height :'100%'
        'background-color': '#fff'

      if atom.config.get('preview-plus.webview')
        unless @subscription
          @pane = atom.workspace.getActivePane()
          @subscription = @pane.onDidChangeActiveItem (item)=>
            if item isnt @
              @destroy()
              @subscription.dispose()
        webview.attr disablewebsecurity:true
        webview.attr src: "data:text/html,#{text}"
      else
        webview.attr srcdoc: text

    getViewClass: ->
      require './htmlview'

    getTitle: ->
      path.basename(@uri)

    getUri: ->
      @uri
