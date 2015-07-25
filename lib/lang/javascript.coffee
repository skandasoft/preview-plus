js2c = require 'js2coffee'
jQuery = require 'jquery'
javascript =
  cs : (fpath,text,options={})->
    compiled = js2c.build text,options
    compiled.code

jQuery.extend javascript, require('./jshtml')(false)
module.exports = javascript
