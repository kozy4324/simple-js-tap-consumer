class TAPConsumer

  @is_diag: (line) -> line?.indexOf?("#") is 0
  @is_plan: (line) -> line?.match? /^\d+\.\.\d+/
  @is_ok: (line) -> line?.match? /^ok/
  @is_not_ok: (line) -> line?.match? /^not ok/
  @has_todo: (line) -> (@is_ok(line) or @is_not_ok(line)) and line?.match? /# todo/i
  @has_skip: (line) -> (@is_ok(line) or @is_not_ok(line)) and line?.match? /# skip/i
  @is_bail_out: (line) -> line?.match? /^Bail out!/

  @parse_plan: (line) -> +line.match(/^\d+\.\.(\d+)/)[1]
  @parse_test: (line) -> +line.match(/^(?:not )?ok (\d+)/)?[1] or -1

  constructor: ->
    @_planed = 0
    @_current = 0
    @_ok = 0
    @_not_ok = 0
    @_todo = 0
    @_skip = 0
    @_bailed_out = false
    @_failed_tests = []

  success: -> @_not_ok is 0
  total: -> @_ok + @_not_ok + @_todo + @_skip
  failed_tests: -> @_failed_tests

  consume: (line) ->
    if TAPConsumer.is_plan line
      @_planed = TAPConsumer.parse_plan line
    else if TAPConsumer.is_ok line
      @_ok++
      num = TAPConsumer.parse_test line
      @_current++ if num is -1
    else if TAPConsumer.is_not_ok line
      @_not_ok++
      num = TAPConsumer.parse_test line
      @_current++ if num is -1
      @_failed_tests.push "#{@_current} - #{line.replace /^not ok\s*\d*\s*-?\s*/i, ''}"

module.exports = TAPConsumer
