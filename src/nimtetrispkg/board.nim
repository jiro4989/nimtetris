import mino, blocks

type
  Board* = seq[seq[int]]

const
  initialBoard*: Board = @[
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1],
  ]

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

proc setRow*(self: var Board, row: seq[int], x, y: int) =
  for xx, cell in row:
    self[y][x + xx] = cell