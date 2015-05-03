loophole = require './eval'
jade = loophole.allowUnsafe -> require 'jade'

module.exports =

  html : (fpath,text,options={},data={})->
    loophole.allowUnsafe ->
      fn = jade.compile(text,options)
      fn(data)

  htmlp : (fpath,text,options={},data={})->
        compiled = @html(fpath,text,options,data)
        console.log compiled
        return compiled
