class TAPConsumer

  @is_diag: (line) -> line?.indexOf?("#") is 0
  @is_plan: (line) -> line?.match? /^\d+\.\.\d+/
  @is_ok: (line) -> line?.match? /^ok/
  @is_not_ok: (line) -> line?.match? /^not ok/
  @is_test: (line) -> TAPConsumer.is_ok(line) or TAPConsumer.is_not_ok(line)
  @has_todo: (line) -> TAPConsumer.is_test(line) and line?.match? /# todo/i
  @has_skip: (line) -> TAPConsumer.is_test(line) and line?.match? /# skip/i
  @is_bail_out: (line) -> line?.match? /^Bail out!/

  @parse_plan: (line) -> +line.match(/^\d+\.\.(\d+)/)[1]
  @parse_test: (line) ->
    num = +line.match(/^(?:not )?ok (\d+)/i)?[1] or -1
    msg = line.replace /^(not )?ok\s*\d*\s*-?\s*/i, ''
    {num, msg}

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
  toString: ->
    total = @total()
    failed = @_failed_tests.length
    if @success()
      "All #{total} tests passed."
    else
      if failed > 0
        "Failed #{failed}/#{total} tests."
      else
        "Bad plan. You planned #{@_planed} tests but ran #{total}"

  consume: (line) ->
    {is_plan, is_ok, is_not_ok, is_test, parse_plan, parse_test} = TAPConsumer
    if is_plan line
      @_planed = parse_plan line
    else if is_test line
      {num, msg} = parse_test line
      if num is -1 or @_current+1 is num
        @_current++
      else if @_current+1 <= num
        for i in [(@_current+1)..(num-1)]
          @_not_ok++
          @_failed_tests.push "#{i} - (missing)"
        @_current = num
      else if num <= @_current
        if is_ok line
          @_not_ok++
          @_ok--
        @_failed_tests.push "#{num} - #{msg}(duplicate)"
      if is_ok line
        @_ok++
      else
        @_not_ok++
        @_failed_tests.push "#{@_current} - #{msg}"

if typeof module isnt 'undefined'
  module.exports = TAPConsumer
else
  @['TAPConsumer'] = TAPConsumer
