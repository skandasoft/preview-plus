{$, $$,$$$, View}  = require 'atom'
module.exports =
class HTMLView extends View
  constructor: (@model)->
    super
  @content: ->
    if atom.config.get('preview-plus.webview')
      @div class:'preview-plus-htmlp', =>
        @tag 'webview',outlet: 'htmlv'
    else
      @div class:'preview-plus-htmlp', =>
        @tag 'iframe',outlet: 'htmlv'

  initialize: ->

    if atom.config.get('preview-plus.webview')
      @element.onkeydown = =>@showDevTool(arguments)
    else
      iframe = @find('iframe')[0]
      $(iframe).attr
            sandbox: "allow-forms allow-popups allow-pointer-lock allow-same-origin allow-scripts"
            seamless: ''
            style: "overflow:hidden;height:100%;width:100%"
            width: '100%'
            height: '100%'

  showDevTool: (evt)->
    @children()[0].openDevTools() if evt[0].keyIdentifier is "F12"

  getTitle: ->
    @model.getTitle()
  # Tear down any state and detach

  # destroy: ->
    # @element.remove()
