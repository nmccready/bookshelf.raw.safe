should = require 'should'
project = do require '../src/index'
Promise = require 'bluebird'
next = undefined
thisPackage = require '../package'

#deps be loaded by the browser or by node
describe 'sanity', ->
  it 'should.js exist', ->
    throw new Error() unless should

  it 'this project is loaded', ->
    throw new Error ('THIS MAIN PROJECT IS NOT LOADED!') if not project


describe 'bookshelf.raw.safe', ->
  after ->
    art = require '../gulp/resources/art'

    console.log art
    console.log "\nname:#{thisPackage.name}, version: #{thisPackage.version}"

  subject = null

  describe 'safeQuery', ->
    beforeEach ->
      subject = project.safeQuery

      next = ->

      @calledSql = ''
      @db =
        knex:
          raw: (sql) =>
            @calledSql = sql
            Promise.resolve(rows: {})

      @dbWError =
        knex:
          raw: (sql) =>
            Promise.reject "mock error"

    it 'exists', ->
      subject.should.be.ok


    it 'calls knex.raw without error', (done) ->
      testSql = 'testSql1'

      promise = subject @db, testSql, next, 'testFn'

      promise.then (result) =>
        result.should.be.eql {}
        @calledSql.should.be.eql testSql
        done()

    it 'calls knex.raw with error', (done)->
      testSql = 'testSql2'
      error = false
      subject @dbWError, testSql, next, 'testFn'
      .catch (e) =>
        error = true
        @calledSql.should.not.be.eql testSql
      .then ->
        error.should.be.ok
        done()

    describe 'invalid args still returns a promise!', ->
        it 'db undefined', (done) ->
          subject().catch (msg) ->
            done()
            msg.should.be.eql 'db is not defined'

        it 'sql undefined', (done) ->
          subject({}).catch (msg) ->
            msg.should.be.eql 'sql is not defined'
            done()

        it 'next undefined', (done) ->
          subject(@db,"crap").then (row) ->
            row.should.be.eql {}
            done()
