tsc = require 'typescript-compiler'
module.exports =
  js : (text,options={})->
    tscArgs = atom.config.get('preview-plus.tscArgs') or {}
    tsc.compileString text,tscArgs, options,(err)->
      console.log err
