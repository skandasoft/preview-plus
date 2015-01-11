command = require './command'
module.exports =
  css: (text,options=['-s'])->
    command.compile text,'sass',options
