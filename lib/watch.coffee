chokidar = require 'chokidar'
{Emitter} = require 'event-kit'
module.exports =
  class Watch
    constructor: (w)->
      @emitter = new Emitter
      paths = w.split(',')
      paths = (path.trim() for path in paths)
      @chokidar = chokidar.watch paths
      @paths = paths
      @chokidar.on 'change', (path,stats)=>
        console.log 'CHOKIDAR',path,stats
        @emitter.emit 'did-change', path

    onDidChange: (cb)->
      @emitter.on 'did-change', cb
