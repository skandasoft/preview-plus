command = require './command'
module.exports =
  html: (fpath,text,options=['-s','-p'])->
    command.compile fpath,text,'slimrb',options

  erb: (fpath,text,options=['-s','-e'])->
    command.compile fpath,text,'slimrb',options

  htmlp: (fpath,text,options)->
    @html(fpath,text,options)
