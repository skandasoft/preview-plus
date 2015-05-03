stylus =require 'stylus'
module.exports =
  css: (fpath,text,options={})->

    stylus(text)
      .set options
      .render()
