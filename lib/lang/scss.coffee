command = require './command'
module.exports =
  css: (fpath,text,options=['-s','--SCSS'])->
      # command.compileFile text,'sass',options
      command.compile fpath,text,'sass',options
