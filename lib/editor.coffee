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
        unless @replaceText('base',text,false)
          debugger
          unless text = @replaceText('head',text) or text
            text ?= @replaceText('html',text)
        webview.attr disablewebsecurity:true
        webview.attr src: "data:text/html,#{text}"
      else
        webview.attr srcdoc: text

    replaceText: (tag,text,replace=true)->
            regex = new RegExp("<#{tag}>([\\s\\S]*?)</#{tag}>")
            match = text.match(regex)
            if match? and match[1].trim()
                return true unless replace
                base = "#{atom.project.path}/"
                base = if @uri?.indexOf('public') then "#{base}public/"
                baseTag = "<base href='#{base}'></base>"
                baseTag = "<head>#{baseTag}</head>" if tag is 'html'
                content = "<#{tag}>#{baseTag} #{match[1]}</#{tag}>"
                text.replace regex,content

    getViewClass: ->
      require './htmlview'

    getTitle: ->
      path.basename(@uri)

    getUri: ->
      @uri
