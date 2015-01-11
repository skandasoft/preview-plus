marked = require 'marked'
config = require '../config'
module.exports =
  html:(text,options={})->
    marked.setOptions options
      # renderer: new marked.Renderer(),
      # gfm: true,
      # tables: true,
      # breaks: false,
      # pedantic: false,
      # sanitize: true,
      # smartLists: true,
      # smartypants: false
    marked text

  htmlp:(text,options={})->
    if cssURL = config.markdown.cssURL
      css = "<link rel='stylesheet' type='text/css' href='#{cssURL}'>"
    else
      css = "<link rel='stylesheet' type='text/css' href='file:///#{atom.workspace.srcdir}/resources/markdown.css'>"
    html = @html(text,options)
    """
    <html>
      <head>
        #{css}
      </head>
      <body>
        #{html}
      </body>
    </html>
    """
