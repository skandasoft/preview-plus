command = require './command'
module.exports =
  html: (text,options=['-s'])->
      command.compile text,'haml',options

  htmlp: (text)->
    console.log text
    @html(text)
