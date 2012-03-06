jasmine = require 'jasmine-node'
{TAPReporter, diag} = require 'jasmine-tapreporter'
TAPConsumer = require '../src/tapconsumer.coffee'

describe 'TAPConsumer', ->

  it 'should be defined', ->

    expect(TAPConsumer).toBeDefined()

  describe '.is_diag', ->

    it 'should return true when given diagnostic line', ->

      expect(TAPConsumer.is_diag '# this is a diagnostic line').toBeTruthy()

    it 'should return false when given no diagnostic line', ->

      expect(TAPConsumer.is_diag '1..1').toBeFalsy()
      expect(TAPConsumer.is_diag 'ok 1 - test line').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.is_diag null).toBeFalsy()
      expect(TAPConsumer.is_diag {}).toBeFalsy()

  describe '.is_plan', ->

    it 'should return true when given plan line', ->

      expect(TAPConsumer.is_plan '1..1').toBeTruthy()

    it 'should return false when given no plan line', ->

      expect(TAPConsumer.is_plan 'ok 1').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.is_plan null).toBeFalsy()
      expect(TAPConsumer.is_plan {}).toBeFalsy()

  describe '.is_ok', ->

    it 'should return true when given ok line', ->

      expect(TAPConsumer.is_ok 'ok').toBeTruthy()

    it 'should return false when given no ok line', ->

      expect(TAPConsumer.is_ok 'not ok').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.is_ok null).toBeFalsy()
      expect(TAPConsumer.is_ok {}).toBeFalsy()

  describe '.is_not_ok', ->

    it 'should return true when given not_ok line', ->

      expect(TAPConsumer.is_not_ok 'not ok').toBeTruthy()

    it 'should return false when given no not_ok line', ->

      expect(TAPConsumer.is_not_ok 'ok').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.is_not_ok null).toBeFalsy()
      expect(TAPConsumer.is_not_ok {}).toBeFalsy()

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
