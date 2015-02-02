loophole = require './eval'
jade = loophole.allowUnsafe -> require 'jade'

module.exports =
  html : (text,options={})->
    loophole.allowUnsafe ->
      fn = jade.compile(text,options)
      fn()
  htmlp : (text)->
        compiled = @html(text)
        console.log compiled
        return compiled
