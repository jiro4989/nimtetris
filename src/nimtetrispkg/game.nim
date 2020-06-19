import times, times, sequtils
from strutils import join
from strformat import `&`

import illwill
import mino, blocks, board

type
  Game* = ref object
    tb: TerminalBuffer
    minoboard: MinoBoard
    startTime: DateTime
    endTime: DateTime
    score: int64
    isStopped: bool
    mino: Mino
    nextMino: Mino
  MinoBoard = object
    board: Board
    offset: int

const
  nextMinoArea: Board = @[
    @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1],
    @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1],
    @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1],
    @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1],
    @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1],
    @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1],
  ]

var
  sleepTime* = 1000

proc newMinoBoard(): MinoBoard =
  result = MinoBoard(board: initialBoard, offset: 2)

proc newGame*(): Game =
  result = Game(
    minoboard: newMinoBoard(),
    startTime: now(),
    endTime: now(),
    mino: newRandomMino(),
    nextMino: newRandomMino(),
  )

proc canMoveDown*(game: Game): bool
proc stop*(game: Game)

proc setRandomMino*(game: Game) =
  game.mino = game.nextMino
  game.nextMino = newRandomMino()
  if not game.canMoveDown():
    game.stop()

proc setMino*(b: var Board, m: Mino) =
  let blk = m.getBlock
  for y, row in blk:
    for x, cell in row:
      # 空のミノはセットしないようにする
      if cell != EMPTY_MINO:
        b[y+m.y][x+m.x] = cell

proc setCurrentMino*(game: Game) =
  game.minoboard.board.setMino(game.mino)

proc fetchRow(mb: MinoBoard, n: int): seq[int] =
  let row = mb.board[n]
  return row[mb.offset ..< row.len - mb.offset]

proc isDeletable(row: seq[int]): bool =
  for c in row:
    if c == EMPTY_MINO:
      return false
  return true

proc deleteRow(mb: var MinoBoard, y: int): bool =
  let row = mb.fetchRow(y)
  if not row.isDeletable:
    return

  let x = mb.offset
  for i in countdown(y, 1):
    let j = i - 1
    let row2 = mb.fetchRow(j)
    mb.board.setRow(row2, x, i)
  let emptyRow = repeat(EMPTY_MINO, mb.board[0].len - mb.offset * 2)
  mb.board.setRow(emptyRow, x, 0)
  return true

proc deleteFilledRows*(game: Game) =
  for i in 0 ..< game.minoboard.board.len - game.minoboard.offset:
    let deleted = game.minoboard.deleteRow(i)
    if deleted:
      game.score += 100

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
    game.deleteFilledRows()

proc moveDownToBottom*(game: Game) =
  for i in 1..20:
    if game.mino.canMoveDown(game.minoboard.board):
      game.mino.moveDown()
  game.setCurrentMino()
  game.deleteFilledRows()
  game.setRandomMino()

proc canRotate*(game: Game, mino: Mino): bool =
  let
    x = mino.x
    y = mino.y
    blk = mino.getBlock
    blk2 = game.minoboard.board.fetchBlock(x, y)
  return not blk.isOverlap(blk2)

proc canRotateRight*(game: Game): bool =
  var mino = game.mino
  mino.rotateRight()
  game.canRotate(mino)

proc canRotateLeft*(game: Game): bool =
  var mino = game.mino
  mino.rotateLeft()
  game.canRotate(mino)

proc rotateRight*(game: Game) =
  if game.canRotateRight():
    game.mino.rotateRight()

proc rotateLeft*(game: Game) =
  if game.canRotateLeft():
    game.mino.rotateLeft()

proc color(n: int): BackgroundColor =
  case n
  of EMPTY_MINO: bgBlack
  of FILLED_MINO1: bgWhite
  of FILLED_MINO2: bgRed
  of FILLED_MINO3: bgGreen
  of FILLED_MINO4: bgYellow
  of FILLED_MINO5: bgBlue
  of FILLED_MINO6: bgMagenta
  of FILLED_MINO7: bgCyan
  of FILLED_MINO8: bgCyan # FIXME
  else: bgBlack

proc labelText(t: string, width: int): string =
  let s = " " & t
  let rightPad = " ".repeat(width - s.len).join
  return &"{s}{rightPad}"

proc drawArea(tb: var TerminalBuffer, label: string, x, y, width: int, fgColor: ForegroundColor, bgColor: BackgroundColor) =
  tb.setForegroundColor(fgColor)
  tb.setBackgroundColor(bgColor)
  tb.write(x, y, labelText(label, width))
  tb.resetAttributes()

proc drawBoard(game: Game, board: Board, x, y: int) =
  for y2, row in board:
    # 行を描画
    for x2, cell in row:
      let c = cell.color()
      game.tb.setBackgroundColor(c)
      game.tb.write(x+x2*2, y+y2, "  ")
      game.tb.resetAttributes()

proc drawNextMino(game: Game, x, y, width: int) =
  # frame
  var board = nextMinoArea
  var mino = game.nextMino
  mino.x = 1
  mino.y = 1
  board.setMino(mino)
  game.drawBoard(board, x, 1)

proc drawTimer(game: Game, x, y, width: int) =
  let
    dur = now() - game.startTime
    part = dur.toParts
    sec = part[Seconds]
  game.tb.drawArea("TIME", x, y, width, fgWhite, bgBlack)
  game.tb.drawArea(&"{sec} sec", x, y+1, width, fgBlack, bgWhite)

proc drawScore(game: Game, x, y, width: int) =
  game.tb.drawArea("SCORE", x, y, width, fgWhite, bgBlack)
  game.tb.drawArea($game.score, x, y+1, width, fgBlack, bgWhite)

proc drawKeyBindings(game: Game, x, y, width: int) =
  let w = width div 6
  var keys = @[
    ("H / A", "<-"),
    ("J / S", "DOWN"),
    ("L / D", "->"),
    ("<SPC>", "BOTTOM"),
    ("U / Q", "L-RORATE"),
    ("O / E", "R-ROTATE"),
  ]
  for i, t in keys:
    let x2 = x + i * w
    game.tb.drawArea(t[0], x2, y, w, fgWhite, bgBlack)
    game.tb.drawArea(t[1], x2, y+1, w, fgBlack, bgWhite)

  keys = @[
    ("<ESC>", "QUIT"),
  ]
  for i, t in keys:
    let x2 = x + i * w
    game.tb.drawArea(t[0], x2, y+3, w, fgWhite, bgBlack)
    game.tb.drawArea(t[1], x2, y+4, w, fgBlack, bgWhite)

proc drawBoard(game: Game) =
  # 画面描画用のボードを生成
  var board = game.minoboard.board
  board.setMino(game.mino)
  game.drawBoard(board, 2, 0)

proc redraw*(game: Game) =
  # 後から端末の幅が変わる場合があるため
  # 端末の幅情報はループの都度取得
  let tw = terminalWidth()
  let th = terminalHeight()
  game.tb = newTerminalBuffer(tw, th)

  let
    x = 30
    y = 0
    w = 20
  game.drawNextMino(x, y, w)
  game.drawTimer(x, y+8, w)
  game.drawScore(x, y+11, w)
  game.drawKeyBindings(2, 21, 60)
  game.drawBoard()
  game.tb.display()

proc stop*(game: Game) =
  game.isStopped = true

proc isStopped*(game: Game): bool =
  game.isStopped

proc score*(game: Game): int64 =
  game.score

proc drawSelectScreen(tb: var TerminalBuffer, selectedIndex: int) =
  const texts = ["EASY MODE", "NORMAL MODE", "HARD MODE"]
  tb.write(2, 2, "== SELECT MODE ==")
  tb.write(2, 3, "W : UP | S : DOWN | <SPC> : SELECT")
  for i, text in texts:
    var text =
      if i == selectedIndex:
        "> " & text
      else:
        "  " & text
    tb.write(2, 2*i + 5, text)
  tb.display()

proc selectMode*() = 
  let tw = terminalWidth()
  let th = terminalHeight()
  var tb = newTerminalBuffer(tw, th)
  var selectedIndex = 1
  tb.drawSelectScreen(selectedIndex)

  while true:
    var key = getKey()
    case key
    of Key.None: discard
    of Key.Escape:
      illwillDeinit()
      showCursor()
      quit 0
    of Key.Enter, Key.Space:
      break
    of Key.W, Key.K:
      dec(selectedIndex)
      if selectedIndex < 0:
        selectedIndex = 2
      tb.drawSelectScreen(selectedIndex)
    of Key.J, Key.S:
      inc(selectedIndex)
      if 2 < selectedIndex:
        selectedIndex = 0
      tb.drawSelectScreen(selectedIndex)
    else: discard

  let m =
    case selectedIndex
    of 0: mEasy
    of 1: mNormal
    of 2:
      sleepTime = 50
      mHard
    else: mNormal
  initMinos(m)

  tb.display()
