command = require './command'
module.exports =
  css: (text,options=['-s','--SCSS'])->
      # command.compileFile text,'sass',options
      command.compile text,'sass',options
