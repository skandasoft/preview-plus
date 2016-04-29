TextEditor = null
module.exports = (params) ->
  if atom.workspace.buildTextEditor?
    console.log 'building text editor'
    atom.workspace.buildTextEditor(params)
  else
    console.log 'newing up text editor'
    TextEditor ?= require("atom").TextEditor
    new TextEditor(params)
