loophole = require './eval'
ECT =  loophole.allowUnsafe -> require 'ect'
path = require 'path'
module.exports =

  html: (filePath,text,options={},data={})->
    loophole.allowUnsafe ->
      fileName = path.basename filePath
      root = path.dirname filePath
      options.root = root
      renderer = ECT options
      renderer.render fileName,data

  htmlp: (filename,text,options={},data={})->
        compiled = @html(filename,text,options,data)
        console.log compiled
        return compiled
