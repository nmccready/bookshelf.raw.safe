gulp = require "gulp"
mocha = require 'gulp-mocha'

gulp.task 'spec', ->
  gulp.src('spec/*', read: false)
  .pipe mocha(reporter: 'spec')
