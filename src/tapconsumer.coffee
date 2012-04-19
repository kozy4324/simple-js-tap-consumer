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

  success: ->
    (@_not_ok is 0) and (@_planed is 0 or @_planed is @_current)
  total: -> @_ok + @_not_ok + @_todo + @_skip
  failed_tests: ->
    failed_tests = @_failed_tests.concat()
    if @_current < @_planed
      failed_tests.push "#{i} - (missing)" for i in [(@_current+1)..@_planed]
    if @_planed isnt @_current
      failed_tests.push "(bad plan)"
    failed_tests

  consume: (line) ->
    is_ok = TAPConsumer.is_ok line
    is_not_ok = TAPConsumer.is_not_ok line
    if TAPConsumer.is_plan line
      @_planed = TAPConsumer.parse_plan line
    else if is_ok or is_not_ok
      @_ok++ if is_ok
      @_not_ok++if is_not_ok
      num = TAPConsumer.parse_test line
      msg = line.replace /^(not )?ok\s*\d*\s*-?\s*/i, ''
      if num is -1
        @_current++
      else
        if @_current+1 < num
          for i in [(@_current+1)..(num-1)]
            @_not_ok++
            @_failed_tests.push "#{i} - (missing)"
        else if num <= @_current
          if is_ok
            @_not_ok++
            @_ok--
          @_failed_tests.push "#{num} - #{msg}(duplicate)"
        @_current = num
      if is_not_ok
        @_failed_tests.push "#{@_current} - #{msg}"

module.exports = TAPConsumer
