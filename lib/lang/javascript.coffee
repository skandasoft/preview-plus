loophole = require './eval'
js2c = loophole.allowUnsafe -> require 'js2coffee'
jQuery = require 'jquery'

javascript =
  cs : (text,options={})->
    loophole.allowUnsafe -> js2c.build text,options

jQuery.extend javascript, require('./jshtml')(false)
module.exports = javascript
