command = require './command'

module.exports =
  haml: (text,options=['-s','-e'])->
      command.compile text,'html2haml',options
