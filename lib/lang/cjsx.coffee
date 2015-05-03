transform = require 'coffee-react-transform'
coffee = require 'coffee-script'
beautify = require('js-beautify').js_beautify
jQuery = require 'jquery'

cjsx =
  cs: (fpath,text,options={},data={})->
    transform text

  js: (fpath,text,options={},data={})->
    transformed = @cs(fpath,text,options,data)
    compiled = coffee.compile transformed, options
    beautify(compiled)

jQuery.extend cjsx, require('./jshtml')(true,'cjsx')
module.exports = cjsx
