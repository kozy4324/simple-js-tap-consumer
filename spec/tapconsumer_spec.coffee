jasmine = require 'jasmine-node'
{TAPReporter, diag} = require 'jasmine-tapreporter'
TAPConsumer = require '../src/tapconsumer.coffee'

describe 'TAPConsumer', ->

  it 'should be defined', ->

    expect(TAPConsumer).toBeDefined()

jasmine.getEnv().addReporter new TAPReporter console.log
jasmine.getEnv().execute()
