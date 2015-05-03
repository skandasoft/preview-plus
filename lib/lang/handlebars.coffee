loophole = require './eval'
hb = loophole.allowUnsafe -> require 'handlebars'
module.exports =

  html: (fpath,text,options,data={})->
    tmpl = loophole.allowUnsafe -> hb.compile text
    loophole.allowUnsafe -> tmpl(data)

  htmlp: (fpath,text,options,data)->
    @html(fpath,text,options,data)
