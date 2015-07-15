config = require '../config'

module.exports = (js=true,src)->
  html: (fpath,text,options={},data={})->
    text = @js(fpath,text,options) if js
    SCRIPT = CSS = ''
    # srcdir = atom.project.get('preview-plus.srcdir')
    if src
      if scripts = config[src].scripts
        for script in scripts
          SCRIPT += "<script src='#{script}'></script>\\n"
      if resource = config[src].resources
        for css in resource.csss
          CSS += "<link rel='stylesheet' type='text/css' href='file:///#{__dirname}/resources/#{css}'>\\n"
        for script in resource.scripts
          SCRIPT += "<script src='file:///#{__dirname}/resources/#{script}'></script>\\n"
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
  htmlp: (fpath,text,options={},data={})->
    @html(fpath,text,options,data)
