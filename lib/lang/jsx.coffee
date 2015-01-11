reactTools = require 'react-tools'
beautify = require('js-beautify').js_beautify
jQuery = require 'jquery'

jsx =
  js : (text,options={})->
    compiled = reactTools.transform text,options
    beautify(compiled)


jQuery.extend jsx, require('./jshtml')(true,'jsx')
module.exports = jsx
