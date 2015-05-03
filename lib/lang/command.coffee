spawn = require('child_process').spawn
Stream = require 'stream'
jQuery = require 'jquery'
_ = require 'lodash'
tmp = require 'tmp'
fs = require 'fs'
path = require 'path'

module.exports =
  compile: (fpath,text,cmd,options=['-s'])->
      dfd = new jQuery.Deferred()
      if process.platform[0..2] is 'win'
        cmd = "#{cmd}.bat"
      stream = new Stream()
      stream.pipe = (dest)->
        console.log text
        dest.write text
        dest.end()

      ls = spawn cmd,options
      ls.stderr.on 'data',(err)->
        dfd.reject err.toString()

      ls.stdout.on 'data',(code)->
        dfd.resolve code.toString()
      stream.pipe ls.stdin
      dfd.promise()

  compileFile: (fpath,text,cmd,options={})->
      dfd = new jQuery.Deferred()
      tmp.file (err,fwpath,fw)->
        if err
          dfd.reject new Error err
          return
        fs.writeFile fwpath,text,(err)->
          if err
            dfd.reject new Error err
            return
          tmp.file (err,frpath,fr)->
            if err
              dfd.reject new Error err
              return
            if process.platform[0..2] is 'win'
              cmd = "#{cmd}.bat"
            option = [fwpath,frpath].concat options
            ls = spawn cmd,option
            ls.on 'close', (code)->
              fs.readFile frpath,(err,data)->
                if err
                  dfd.reject err.toString()
                else
                  dfd.resolve data.toString()
      dfd.promise()
