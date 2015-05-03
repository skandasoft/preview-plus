command = require './command'

module.exports =
  haml: (fpath,text,options=['-s','-e'])->
      command.compile fpath,text,'html2haml',options
