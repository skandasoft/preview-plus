# md = require 'html-md'
html2jade = require 'html2jade'
spawn = require('child_process').spawn
tmp = require 'tmp'
fs = require 'fs'
path = require 'path'
# HTMLtoJSX = require 'htmltojsx'
Stream = require 'stream'
jQuery = require 'jquery'
command = require './command'

module.exports =
    slim: (text,options=[])->
      command.compileFile(text,'html2slim',options)
    jade: (text,options={})->
      text = text.replace /\n/g, ''
      text = text.replace /\s/g, ''
      dfd = new jQuery.Deferred()
      tmp.file (err,fwpath,fw)->
        if err
          dfd.reject new Error err
          return
        fs.writeFile fwpath,text,(err)->
          if err
            dfd.reject new Error err
            return
          cmd = 'html2jade'
          if process.platform[0..2] is 'win'
            cmd = "html2jade.cmd"
          ls = spawn cmd,[fwpath]
          ls.on 'close', (code)->
            fs.readFile fwpath.replace('.tmp','.jade'),(err,data)->
              if err
                dfd.reject err.toString()
              else
                dfd.resolve data.toString()
      dfd.promise()
      # dfd = new jQuery.Deferred()
      # command.compileFile(text,'html2jade',options)
      # @compile = html2jade.convertHtml text, options, (e,jade)->
      #   if e
      #     error += '\n'+e.toString().split('\n')[1..-1].join('\n')+'\n'+e.message
      #     dfd.resolve error
      #   else
      #     dfd.resolve jade
      # dfd.promise()

    # md: (text)->
    #   md text

    htmlp: (text)->
      text
      
    # jsx: (text,options={})->
    #     window.IN_BROWSER = true
    #     converter = new HTMLtoJSX options
    #     converter.convert text

    haml: (text,options=['-s'])->
      command.compile(text,'html2haml',options)
