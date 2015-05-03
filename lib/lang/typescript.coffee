tsc = require 'typescript-compiler'
module.exports =
  js : (fpath,text,options={})->
    tscArgs = atom.config.get('preview-plus.tscArgs') or {}
    tsc.compileString text,tscArgs, options,(err)->
      console.log err
