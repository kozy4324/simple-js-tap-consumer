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
        expect(ins.toString()).toEqual "All 1 tests passed."

    describe 'a plan and 3 ok test', ->
      it 'should success', ->
        ins.consume '1..3'
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3
        expect(ins.toString()).toEqual "All 3 tests passed."

    describe '3 ok test(no plan)', ->
      it 'should success', ->
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3
        expect(ins.toString()).toEqual "All 3 tests passed."

    describe '1 not ok test', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'not ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 1
        expect(ins.toString()).toEqual "Failed 1/1 tests."

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
        expect(ins.toString()).toEqual "Failed 1/3 tests."

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
        expect(ins.toString()).toEqual "Failed 2/3 tests."

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
        expect(ins.toString()).toEqual "Bad plan. You planned 3 tests but ran 2"

    describe 'planed 1 tests but run 2', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '(bad plan)'
        expect(ins.toString()).toEqual "Bad plan. You planned 1 tests but ran 2"

    describe 'planed 1 tests but run 0', ->
      it 'should fail', ->
        ins.consume '1..1'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 0
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '1 - (missing)'
        expect(ins.failed_tests()[1]).toEqual '(bad plan)'
        expect(ins.toString()).toEqual "Bad plan. You planned 1 tests but ran 0"

    describe 'planed 1 tests and run 1(with test number)', ->
      it 'should success', ->
        ins.consume '1..1'
        ins.consume 'ok 1'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 1
        expect(ins.toString()).toEqual "All 1 tests passed."

    describe 'planed 1 tests and run 1(with test number and not ok)', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'not ok 1'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 1
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '1 - '
        expect(ins.toString()).toEqual "Failed 1/1 tests."

    describe 'planed 3 tests and run 2(missing number 3)', ->
      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'ok 1'
        ins.consume 'ok 2'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '3 - (missing)'
        expect(ins.failed_tests()[1]).toEqual '(bad plan)'
        expect(ins.toString()).toEqual "Bad plan. You planned 3 tests but ran 2"

    describe 'planed 2 tests but run 3', ->
      it 'should fail', ->
        ins.consume '1..2'
        ins.consume 'ok 1'
        ins.consume 'ok 2'
        ins.consume 'ok 3'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 3
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '(bad plan)'
        expect(ins.toString()).toEqual "Bad plan. You planned 2 tests but ran 3"

    describe 'planed 3 tests and run 2(missing number 2)', ->
      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'ok 1'
        ins.consume 'ok 3'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 3
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '2 - (missing)'
        expect(ins.toString()).toEqual "Failed 1/3 tests."

      it 'should fail', ->
        ins.consume '1..3'
        ins.consume 'ok 1'
        ins.consume 'not ok 3'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 3
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '2 - (missing)'
        expect(ins.failed_tests()[1]).toEqual '3 - '
        expect(ins.toString()).toEqual "Failed 2/3 tests."

    describe 'planed 1 tests and run 1 but test number is 2', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'ok 2'
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '1 - (missing)'
        expect(ins.failed_tests()[1]).toEqual '(bad plan)'
        expect(ins.toString()).toEqual "Failed 1/2 tests."

    describe 'planed 1 tests but run 2 and test number is duplicate', ->
      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'ok 1'
        ins.consume 'ok 1 - this test is '
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 1
        expect(ins.failed_tests()[0]).toEqual '1 - this test is (duplicate)'
        expect(ins.toString()).toEqual "Failed 1/2 tests."

      it 'should fail', ->
        ins.consume '1..1'
        ins.consume 'ok 1'
        ins.consume 'not ok 1 - this test is '
        expect(ins.success()).toBeFalsy()
        expect(ins.total()).toEqual 2
        expect(ins.failed_tests().length).toEqual 2
        expect(ins.failed_tests()[0]).toEqual '1 - this test is (duplicate)'
        expect(ins.failed_tests()[1]).toEqual '1 - this test is '
        expect(ins.toString()).toEqual "Failed 2/2 tests."

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
