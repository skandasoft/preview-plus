command = require './command'
module.exports =
  css: (fpath,text,options=['-s'])->
    command.compile fpath,text,'sass',options
