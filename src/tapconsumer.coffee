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
    @planed = 0
    @current = 0
    @ok = 0
    @not_ok = 0
    @todo = 0
    @skip = 0
    @bailed_out = false

  success: -> true
  total: -> @ok + @not_ok + @todo + @skip

  consume: (line) ->
    if TAPConsumer.is_plan line
      @planed = TAPConsumer.parse_plan line
    else if TAPConsumer.is_ok line
      @ok++
      num = TAPConsumer.parse_test line
      @current++ if num is -1

module.exports = TAPConsumer
