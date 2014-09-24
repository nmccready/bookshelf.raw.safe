gulp = require "gulp"

thingsToWatch = ->
  gulp.watch "src/**/*", ["default"]
  gulp.watch "spec/**/*", ["spec_build", "spec"]

gulp.task "watch", ["scripts"], ->
  thingsToWatch()

gulp.task "watch_fast", ->
  thingsToWatch()
