coffee = require 'coffee-script'
jQuery = require 'jquery'

coffeescript =
  js : (text,options)->
    coffee.compile text, options
jQuery.extend coffeescript, require('./jshtml')(true)
module.exports = coffeescript
