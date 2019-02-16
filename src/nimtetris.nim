import random, strutils

type
  Board = seq[seq[int]]
  MinoBoard = ref object
    board: Board
    offset: int
  Block = array[4, array[4, int]]
  Mino = ref object
    rotateIndex: int
    minoIndex: int
    x: int
    y: int

const initialBoard: Board = @[
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  @[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
]

var
  ## 現在のボード
  currentBoard {.exportc.} = initialBoard
  ## 表示上のボード
  ## currentBoardに移動中のミノをセットしたりする
  displayBoard {.exportc.} = initialBoard

const minos = @[
  @[
    [ [0, 0, 0, 0],
      [0, 1, 1, 0],
      [0, 1, 1, 0],
      [0, 0, 0, 0],
    ],
  ],
  @[
    [
      [0, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 1, 0, 0],
    ],
    [
      [0, 0, 0, 0],
      [1, 1, 1, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ],
    [
      [0, 0, 1, 0],
      [0, 0, 1, 0],
      [0, 0, 1, 0],
      [0, 0, 1, 0],
    ],
    [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [1, 1, 1, 1],
      [0, 0, 0, 0],
    ],
  ],
]

const
  MINO_BLOCK_WIDTH = 4
  EMPTY_MINO = 0
  WALL_MINO = 1

proc fetchBlock(b: Board, x, y: int): Block {.exportc.} =
  ## x, y座標位置の4x4のミノブロックを取得する
  var i: int
  for y2 in y..<(y+4):
    var j: int
    for x2 in x..<(x+4):
      let cell = b[y2][x2]
      result[i][j] = cell
      inc j
    inc i

proc isOverlap(self: Block, target: Block): bool {.exportc.} =
  ## 対象のミノブロック同士に重なるものがあるかを判定する。
  ## 重なっていたらtrueを返す。
  for y, row in self:
    for x, cell in row:
      let targetCell = target[y][x]
      let overlap = cell + targetCell
      if 1 < overlap:
        return true
  return false

proc getBlock(m: Mino): Block {.exportc.} =
  return minos[m.minoIndex][m.rotateIndex]

proc canMoveRight(m: Mino, b: Board): bool {.exportc.} = 
  if b[0].len < m.x + 1 + MINO_BLOCK_WIDTH:
    return false
  let blk = b.fetchBlock(x = m.x + 1, y = m.y)
  return not m.getBlock.isOverlap(blk)

proc canMoveLeft(m: Mino, b: Board): bool {.exportc.} = 
  if m.x - 1 < 0:
    return false
  let blk = b.fetchBlock(x = m.x - 1, y = m.y)
  return not m.getBlock.isOverlap(blk)

proc canMoveDown(m: Mino, b: Board): bool {.exportc.} = 
  if b.len < m.y + 1 + MINO_BLOCK_WIDTH:
    return false
  let blk = b.fetchBlock(x = m.x, y = m.y + 1)
  return not m.getBlock.isOverlap(blk)

proc moveRight(m: Mino) {.exportc.} = m.x.inc
proc moveLeft(m: Mino) {.exportc.} = m.x.dec
proc moveDown(m: Mino) {.exportc.} = m.y.inc

proc rotateRight(m: var Mino) {.exportc.} =
  let incedIndex = m.rotateIndex + 1
  m.rotateIndex = if minos[m.minoIndex].len <= incedIndex:
    0
  else:
    incedIndex

proc rotateLeft(m: var Mino) {.exportc.} =
  let decedIndex = m.rotateIndex - 1
  m.rotateIndex = if decedIndex < 0:
    minos[m.minoIndex].len - 1
  else:
    decedIndex

proc isDeletable(row: seq[int]): bool {.exportc.} =
  for c in row:
    if c <= 0:
      return false
  return true

proc fetchRow(mb: MinoBoard, n: int): seq[int] {.exportc.} =
  let row = mb.board[n]
  return row[mb.offset .. row.len - 1 - mb.offset]

proc setMino(b: var Board, m: Mino) {.exportc.} =
  let blk = m.getBlock
  for y, row in blk:
    for x, cell in row:
      # 空のミノはセットしないようにする
      if cell != EMPTY_MINO:
        b[y+m.y][x+m.x] = cell

proc updateDisplayBoard(m: Mino) {.exportc.} =
  ## 表示用ボードに降下中のミノをセットする
  displayBoard = currentBoard
  displayBoard.setMino m

proc updateCurrentBoard(m: Mino) {.exportc.} =
  ## 現在のボードに降下不可能になったミノをセットする
  currentBoard.setMino m
  displayBoard = currentBoard

proc newRandomMino(): Mino {.exportc.} =
  let r = random(max = minos.len)
  return Mino(minoIndex: r, x: 4, y: 0)

proc show(b: Board) =
  ## for Debug
  echo "------------------------------------"
  for row in b:
    echo row.join
  echo "------------------------------------"

when isMainModule:
  randomize()