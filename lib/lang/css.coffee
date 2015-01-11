loophole = require 'loophole'
c2s = require 'css2stylus'
c2l = require 'css2less'
command = require './command'
module.exports =

  stylus: (text,options={})->
    converter = new c2s.Converter(text)
    converter.processCss(options).output

  less: (text,options={})->
    loophole.allowUnsafe -> c2l text,options

  sass: (text,options=['SASS'])->
      command.compile text,'css2sass',options

  scss: (text,options=['SCSS'])->
      command.compile text,'css2sass',options
