config = require '../config'

module.exports = (js=true,src)->

  html: (text,options={},data={})->
    text = @js(text,options) if js
    SCRIPT = CSS = ''
    if src
      if scripts = config[src].scripts
        for script in scripts
          SCRIPT += "<script src='#{script}'></script>\\n"
      if resource = config[src].resources
        for css in resource.csss
          CSS += "<link rel='stylesheet' type='text/css' href='file:///#{atom.workspace['preview-plus']}/resources/#{css}'>\\n"
        for script in resource.scripts
          SCRIPT += "<script src='file:///#{atom.workspace.srcdir}/resources/#{script}'></script>\\n"
    html = """
      <html>
        <head>
          #{CSS}
          #{SCRIPT}
          <script type='text/javascript'>
            window.onload = function(){
              #{text}
            }
          </script>
        </head>
        <body>
        </body>
      </html>
    """
  htmlp: (text,options={},data={})->
    @html(text,options,data)
