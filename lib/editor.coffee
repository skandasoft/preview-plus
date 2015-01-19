{Disposable,Emitter,$, $$,$$$} = require 'atom'
{Model} = require 'theorist'
path = require 'path'
module.exports =
  class HTMLEditor extends Model
    @disposable = new Disposable()
    constructor: (@uri)->

    setText: (text)->
      @setTextorUrl text:text

    setUrl: (filePath)->
      url = "#{atom.project.get('preview-plus.cproject').url}/#{path.filename filePath}"
      setTextorUrl(url)

    setTextorUrl: (obj)->
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
        if obj.url
          webview.attr src:obj.url
        else
          unless @replaceText('base',obj,false)
            unless @replaceText('head',obj)
              unless @replaceText('html',obj)
                base = "#{atom.project.get('preview-plus.cproject').base}/"
                baseTag = "<base href='#{base}'></base>"
                obj.text = "#{baseTag} #{obj.text}"
          webview.attr src: "data:text/html,#{obj.text}"
      else
        if obj.url
          webview.attr src:obj.url
        else
          webview.attr srcdoc: obj.text

    replaceText: (tag,obj,replace=true)->
            text = obj.text
            regex = new RegExp("<#{tag}>([\\s\\S]*?)</#{tag}>")
            match = text.match(regex)
            if match? and match[1].trim()
                return true unless replace
                base = "#{atom.project.get('preview-plus.cproject').base}/"
                baseTag = "<base href='#{base}'></base>"
                baseTag = "<head>#{baseTag}</head>" if tag is 'html'
                content = "<#{tag}>#{baseTag} #{match[1]}</#{tag}>"
                obj.text = text.replace regex,content

    getViewClass: ->
      require './htmlview'

    getTitle: ->
      path.basename(@uri)

    getUri: ->
      @uri
