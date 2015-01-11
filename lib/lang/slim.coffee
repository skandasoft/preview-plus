command = require './command'
module.exports =
  html: (text,options=['-s','-p'])->
    command.compile text,'slimrb',options

  erb: (text,options=['-s','-e'])->
    command.compile text,'slimrb',options

  htmlp: (text,options)->
    @html(text,options)
