less = require 'less'
jQuery = require 'jquery'

module.exports =
  css: (fpath,text,options={})->
    dfd = new jQuery.Deferred()
    less.render text,options, (e,output)->
      if e
        dfd.fail e
      else
        dfd.resolve output.css
    dfd.promise()
