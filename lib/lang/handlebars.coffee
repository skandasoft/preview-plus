loophole = require 'loophole'
hb = loophole.allowUnsafe -> require 'handlebars'
module.exports =

  html: (text,options,data={})->
    tmpl = loophole.allowUnsafe -> hb.compile text
    loophole.allowUnsafe -> tmpl(data)

  htmlp: (text,options,data)->
    @html(text,options,data)
