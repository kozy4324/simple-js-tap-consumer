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
        expect(ins.current).toEqual 1
        expect(ins.ok).toEqual 1

    describe 'a plan and 3 ok test', ->
      it 'should success', ->
        ins.consume '1..3'
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3
        expect(ins.current).toEqual 3
        expect(ins.ok).toEqual 3

    describe '3 ok test(no plan)', ->
      it 'should success', ->
        ins.consume 'ok'
        ins.consume 'ok'
        ins.consume 'ok'
        expect(ins.success()).toBeTruthy()
        expect(ins.total()).toEqual 3
        expect(ins.current).toEqual 3
        expect(ins.ok).toEqual 3

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
