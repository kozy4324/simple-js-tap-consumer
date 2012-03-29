jasmine = require 'jasmine-node'
{TAPReporter, diag} = require 'jasmine-tapreporter'
TAPConsumer = require '../src/tapconsumer.coffee'

describe 'TAPConsumer', ->

  describe '#consume', ->

    ins = null
    beforeEach ->
      ins = new TAPConsumer

    describe 'a plan and 1 ok test', ->
      it 'should success', ->
        ins.consume '1..1'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 1

    describe 'a plan and 3 ok test', ->
      it 'should success', ->
        ins.consume '1..3'
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3

    describe '3 ok test(no plan)', ->
      it 'should success', ->
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3

    describe '1 not ok test', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'not ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 1

    describe 'some test including not ok', ->
      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'ok'
        ins.consume 'not ok description'
        ins.consume 'ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 3
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '2 - description'

      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'not ok description'
        ins.consume 'ok'
        ins.consume 'not ok other description'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 3
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '1 - description'
        expect(ins.failed_tests()[1]).toEqual '3 - other description'

    describe 'planed 3 tests but run 2', ->
      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '3 - (missing)'
        expect(ins.failed_tests()[1]).toEqual '(bad plan)'

    describe 'planed 1 tests but run 2', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '(bad plan)'

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
