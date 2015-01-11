stylus =require 'stylus'
module.exports =
  css: (text,options={})->

    stylus(text)
      .set options
      .render()
