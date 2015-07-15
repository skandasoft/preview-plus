# md = require 'html-md'
html2jade = require 'html2jade'
spawn = require('child_process').spawn
tmp = require 'tmp'
fs = require 'fs'
path = require 'path'
# HTMLtoJSX = require 'htmltojsx'
Stream = require 'stream'
jQuery = require 'jquery'
command = require './command'

module.exports =
    getContent: (tag,text)->
        regex = new RegExp("<pp-#{tag}>([\\s\\S]*?)</pp-#{tag}>")
        match = text.match(regex)
        match[1].trim() if match? and match[1]?

    slim: (fpath,text,options=[])->
      command.compileFile(fpath,text,'html2slim',options)
    jade: (fpath,text,options={})->
      text = text.replace /\n/g, ''
      # text = text.replace /\s/g, ''
      dfd = new jQuery.Deferred()
      tmp.file (err,fwpath,fw)->
        if err
          dfd.reject new Error err
          return
        fs.writeFile fwpath,text,(err)->
          if err
            dfd.reject new Error err
            return
          cmd = 'html2jade'
          if process.platform[0..2] is 'win'
            cmd = "html2jade.cmd"
          ls = spawn cmd,[fwpath]
          ls.on 'close', (code)->
            fs.readFile fwpath.replace('.tmp','.jade'),(err,data)->
              if err
                dfd.reject err.toString()
              else
                dfd.resolve data.toString()
      dfd.promise()
      # dfd = new jQuery.Deferred()
      # command.compileFile(text,'html2jade',options)
      # @compile = html2jade.convertHtml text, options, (e,jade)->
      #   if e
      #     error += '\n'+e.toString().split('\n')[1..-1].join('\n')+'\n'+e.message
      #     dfd.resolve error
      #   else
      #     dfd.resolve jade
      # dfd.promise()

    # md: (text)->
    #   md text

    htmlp: (fpath,text)->
      if fpath then '' else text

    htmlu: (fpath,text)->
      fname = path.basename(fpath)
      # get the <pp-url> under the cursor or the first one.
      ed = atom.workspace.getActiveTextEditor()
      return text if text = @getContent 'url',ed.lineTextForBufferRow ed.getCursorScreenPosition().row
      return text if text = @getContent 'url',ed.getText()

      # cproject = atom.project.get('preview-plus.cproject')
      if @cproject?.base?
        fname = fpath.replace(@cproject.base,'')
        return "#{@cproject.url}#{fname}" if @cproject.url?

      "http://127.0.0.1/#{fname}"

    # jsx: (text,options={})->
    #     window.IN_BROWSER = true
    #     converter = new HTMLtoJSX options
    #     converter.convert text

    haml: (fpath,text,options=['-s'])->
      command.compile(fpath,text,'html2haml',options)
