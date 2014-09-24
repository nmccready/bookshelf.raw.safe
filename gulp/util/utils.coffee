log = require("gulp-util").log

jsToMin = (fileName) ->
  fileName.replace('.', '.min.')

#handle globals
String.prototype.toMin = ->
  jsToMin this

String.prototype.js = ->
  this + ".js"

String.prototype.css = ->
  this + ".css"

module.exports =

  jsToMin: jsToMin

  # Only include files to prevent empty directories
  # http://stackoverflow.com/questions/23719731/gulp-copying-empty-directories
  onlyDirs: (es) ->
    es.map (file, cb) ->
      if file?.stat?.isFile()
        cb(null, file)
      else
        cb()

  logEs : (es, toLog) ->
    es.map (file, cb) ->
      log toLog
      cb()

  logFile : (es) ->
    es.map (file, cb) ->
      log file.path
      cb()
  bang: "!!!!"
