gulp = require "gulp"
rename = require "gulp-rename"
gutil = require "gulp-util"
log = gutil.log
clean = require "gulp-rimraf"
gulpif = require "gulp-if"
coffeelint = require "gulp-coffeelint"
open = require "gulp-open"
ignore = require 'gulp-ignore'
es = require 'event-stream'
debug = require 'gulp-debug'
ourUtils = require '../util/utils'
replace = require 'gulp-replace'
gzip = require 'gulp-gzip'
tar = require 'gulp-tar'
insert = require 'gulp-insert'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'

ourPackage = require '../../package.json'


coffeeOptions =
  bare: true
date = new Date()
header =
"""
/**
 *  #{ourPackage.name}
 *
 * @version: #{ourPackage.version}
 * @author: #{ourPackage.author}
 * @date: #{date.toString()}
 * @license: #{ourPackage.license}

    #{require '../resources/art'}
 */\n
"""
###
Compile main source
###
gulp.task "build", ->
  gulp.src (require '../resources/src_pipeline.json'), {base: "src"}
  .pipe gulpif(/[.]coffee$/,coffeelint())
  .pipe gulpif(/[.]coffee$/,coffeelint.reporter())
  .pipe gulpif(/[.]coffee$/,coffee(coffeeOptions).on('error', log))
  .pipe(ourUtils.onlyDirs(es))
  .pipe(gulp.dest("dist/src"))
  .pipe(concat("index.js"))
  .pipe(insert.prepend(header))
  .pipe(gulp.dest("dist"))

gulp.task "scripts", ["build"]
