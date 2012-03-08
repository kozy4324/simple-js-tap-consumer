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

  describe '.has_todo', ->

    it 'should return true when given line is a test line and has TODO directive', ->

      expect(TAPConsumer.has_todo 'ok # TODO').toBeTruthy()
      expect(TAPConsumer.has_todo 'ok # todo').toBeTruthy()
      expect(TAPConsumer.has_todo 'not ok # TODO').toBeTruthy()
      expect(TAPConsumer.has_todo 'not ok # todo').toBeTruthy()

    it 'should return false when given line is not a test line even if it has TODO directive', ->

      expect(TAPConsumer.has_todo '# TODO').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.has_todo null).toBeFalsy()
      expect(TAPConsumer.has_todo {}).toBeFalsy()

  describe '.has_skip', ->

    it 'should return true when given line is a test line and has SKIP directive', ->

      expect(TAPConsumer.has_skip 'ok # SKIP').toBeTruthy()
      expect(TAPConsumer.has_skip 'ok # skip').toBeTruthy()
      expect(TAPConsumer.has_skip 'not ok # SKIP').toBeTruthy()
      expect(TAPConsumer.has_skip 'not ok # skip').toBeTruthy()

    it 'should return false when given line is not a test line even if it has SKIP directive', ->

      expect(TAPConsumer.has_skip '# SKIP').toBeFalsy()

    it 'should return false when given not string object', ->

      expect(TAPConsumer.has_skip null).toBeFalsy()
      expect(TAPConsumer.has_skip {}).toBeFalsy()

  describe '.is_bail_out', ->

    it 'should return true when given bail_out line', ->

      expect(TAPConsumer.is_bail_out 'Bail out!').toBeTruthy()

    it 'should return false when given no bail_out line', ->

      expect(TAPConsumer.is_bail_out 'ok').toBeFalsy()
      expect(TAPConsumer.is_bail_out 'not ok').toBeFalsy()
      expect(TAPConsumer.is_bail_out '# diag').toBeFalsy()
      expect(TAPConsumer.is_bail_out '1..1').toBeFalsy()

    it 'should return false when given not string line', ->

      expect(TAPConsumer.is_bail_out null).toBeFalsy()
      expect(TAPConsumer.is_bail_out {}).toBeFalsy()

  describe '.parse_plan', ->

    it 'should return total plan number', ->

      expect(TAPConsumer.parse_plan '1..1').toEqual 1
      expect(TAPConsumer.parse_plan '1..5').toEqual 5
      expect(TAPConsumer.parse_plan '1..18').toEqual 18

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
