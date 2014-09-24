gulp = require 'gulp'

gulp.task "default", ["clean"], ->
  gulp.start "scripts", "watch", "spec"

#command avail help (shows all tasks)
help = require 'gulp-task-listing'
gulp.task('help', help.withFilters(/:/))


clean = require "gulp-rimraf"
gulp.task "clean", ->
  gulp.src(['dist', 'build'], read: false)
  .pipe clean()
