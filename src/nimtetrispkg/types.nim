type
  Board* = seq[seq[int]]
  Block* = array[4, array[4, int]]

proc fetchBlock*(b: Board, x, y: int): Block =
  ## x, y座標位置の4x4のミノブロックを取得する
  var i: int
  for y2 in y..<(y+4):
    var j: int
    for x2 in x..<(x+4):
      let cell = b[y2][x2]
      result[i][j] = cell
      inc j
    inc i

proc isOverlap*(self: Block, target: Block): bool =
  ## 対象のミノブロック同士に重なるものがあるかを判定する。
  ## 重なっていたらtrueを返す。
  for y, row in self:
    for x, cell in row:
      let targetCell = target[y][x]
      if 0 notin [cell, targetCell]:
        return true
  return false

