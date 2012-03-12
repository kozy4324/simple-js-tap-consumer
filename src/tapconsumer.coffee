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
    @total = 0
    @current = 0
    @ok = 0
    @not_ok = 0
    @todo = 0
    @skip = 0
    @bailed_out = false

  success: -> true

module.exports = TAPConsumer
