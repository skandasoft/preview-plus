loophole = require './eval'
c2s = require 'css2stylus'
c2l = require 'css2less'
command = require './command'
module.exports =

  stylus: (fpath,text,options={})->
    converter = new c2s.Converter(text)
    converter.processCss(options).output

  less: (fpath,text,options={})->
    loophole.allowUnsafe -> c2l text,options

  sass: (fpath,text,options=['SASS'])->
      command.compile fpath,text,'css2sass',options

  scss: (fpath,text,options=['SCSS'])->
      command.compile fpath,text,'css2sass',options
