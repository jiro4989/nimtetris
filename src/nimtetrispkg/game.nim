import times, times
import illwill
import mino, types

type
  Game* = ref object
    tb: TerminalBuffer
    minoboard: MinoBoard
    startTime: DateTime
    endTime: DateTime
    score: int64
    isStopped: bool
    mino: Mino
  MinoBoard = object
    board: Board
    offset: int

const
  initialBoard: Board = @[
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    @[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    @[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ]
  MINO_BLOCK_WIDTH = 4
  EMPTY_MINO = 0
  WALL_MINO = 1

proc newMinoBoard(): MinoBoard =
  result = MinoBoard(board: initialBoard, offset: 2)

proc newGame*(): Game =
  result = Game(
    minoboard: newMinoBoard(),
    startTime: now(),
    endTime: now(),
    mino: newRandomMino(),
  )

proc fetchRow(mb: MinoBoard, n: int): seq[int] =
  let row = mb.board[n]
  return row[mb.offset .. row.len - 1 - mb.offset]

iterator rows(mb: MinoBoard): (int, seq[int]) =
  for i in 0 ..< mb.board.len:
    let row = mb.fetchRow(i)
    yield (i, row)

proc isDeletable(row: seq[int]): bool =
  for c in row:
    if c <= 0:
      return false
  return true

proc deleteRow(mb: MinoBoard, i: int) =
  # TODO
  discard

proc deleteFilledRows*(game: Game) =
  for i, row in game.minoboard.rows:
    if row.isDeletable:
      game.minoboard.deleteRow(i)

proc canMoveRight(m: Mino, b: Board): bool = 
  if b[0].len < m.x + 1 + MINO_BLOCK_WIDTH:
    return false
  let blk = b.fetchBlock(x = m.x + 1, y = m.y)
  return not m.getBlock.isOverlap(blk)

proc canMoveLeft(m: Mino, b: Board): bool = 
  if m.x - 1 < 0:
    return false
  let blk = b.fetchBlock(x = m.x - 1, y = m.y)
  return not m.getBlock.isOverlap(blk)

proc canMoveDown(m: Mino, b: Board): bool = 
  if b.len < m.y + 1 + MINO_BLOCK_WIDTH:
    return false
  let blk = b.fetchBlock(x = m.x, y = m.y + 1)
  return not m.getBlock.isOverlap(blk)

proc canMoveDown*(game: Game): bool =
  game.mino.canMoveDown(game.minoboard.board)

proc moveLeft*(game: Game) =
  if game.mino.canMoveLeft(game.minoboard.board):
    game.mino.moveLeft()

proc moveRight*(game: Game) =
  if game.mino.canMoveRight(game.minoboard.board):
    game.mino.moveRight()

proc moveDown*(game: Game) =
  if game.mino.canMoveDown(game.minoboard.board):
    game.mino.moveDown()

proc rotateRight*(game: Game) =
  game.mino.rotateRight()

proc rotateLeft*(game: Game) =
  game.mino.rotateLeft()

proc setMino*(b: var Board, m: Mino) =
  let blk = m.getBlock
  for y, row in blk:
    for x, cell in row:
      # 空のミノはセットしないようにする
      if cell != EMPTY_MINO:
        b[y+m.y][x+m.x] = cell

proc setCurrentMino*(game: Game) =
  game.minoboard.board.setMino(game.mino)

proc redraw*(game: Game) =
  # 後から端末の幅が変わる場合があるため
  # 端末の幅情報はループの都度取得
  let tw = terminalWidth()
  let th = terminalHeight()
  game.tb = newTerminalBuffer(tw, th)

  let timeDiff = now() - game.startTime
  game.tb.write(0, 0, $timeDiff)

  # 画面描画用のボードを生成
  var board = game.minoboard.board
  board.setMino(game.mino)

  for y, row in board:
    # 行を描画
    for x, cell in row:
      if cell == 0:
        game.tb.setBackgroundColor(bgBlack)
      else:
        game.tb.setBackgroundColor(bgWhite)
      game.tb.write(x*2, y+1, "  ")
      game.tb.resetAttributes()
  game.tb.display()

proc stop*(game: Game) =
  game.isStopped = true

proc isStopped*(game: Game): bool =
  game.isStopped

proc setRandomMino*(game: Game) =
  game.mino = newRandomMino()

