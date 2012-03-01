class TAPConsumer

  @is_diag: (line) -> line?.indexOf?("#") is 0

module.exports = TAPConsumer
