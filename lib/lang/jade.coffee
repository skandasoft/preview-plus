loophole = require './eval'
jade = loophole.allowUnsafe -> require 'jade'

module.exports =

  html : (text,options={},data={})->
    loophole.allowUnsafe ->
      fn = jade.compile(text,options)
      fn(data)

  htmlp : (text,options={},data={})->
        compiled = @html(text,options,data)
        console.log compiled
        return compiled
