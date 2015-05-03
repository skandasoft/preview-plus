command = require './command'
module.exports =
  html: (fpath,text,options=['-s'])->
      command.compile fpath,text,'haml',options

  htmlp: (fpath,text)->
    console.log text
    @html(fpath,text)
