md = require 'html-md'
html2jade = require 'html2jade'
spawn = require('child_process').spawn
tmp = require 'tmp'
fs = require 'fs'
path = require 'path'
HTMLtoJSX = require 'htmltojsx'
Stream = require 'stream'
jQuery = require 'jquery'
command = require './command'

module.exports =
    slim: (text,options=[])->
      command.compileFile(text,'html2slim',options)
    jade: (text,options={})->
      dfd = new jQuery.Deferred()
      text = text.replace /\n/g, ''
      text = text.replace /\s/g, ''
      @compile = html2jade.convertHtml text, options, (e,jade)->
        if e
          error += '\n'+e.toString().split('\n')[1..-1].join('\n')+'\n'+e.message
          dfd.resolve error
        else
          dfd.resolve jade
      dfd.promise()

    md: (text)->
      md text

    htmlp: (text)->
      text

    jsx: (text,options={})->
        window.IN_BROWSER = true
        converter = new HTMLtoJSX options
        converter.convert text

    haml: (text,options=['-s'])->
      command.compile(text,'html2haml',options)
