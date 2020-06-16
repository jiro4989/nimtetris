import os, random, strutils, times, threadpool, locks

import illwill

type
  Game = ref object
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
  Board = seq[seq[int]]
  Block = array[4, array[4, int]]
  Mino = object
    rotateIndex: int
    minoIndex: int
    x: int
    y: int

const
  initialBoard: Board = @[
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
  minos = @[
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

var
  thr: array[2, Thread[int]]
  L: Lock

proc newMinoBoard(): MinoBoard =
  result = MinoBoard(board: initialBoard)

proc newRandomMino(): Mino
proc newGame(): Game =
  result = Game(
    minoboard: newMinoBoard(),
    startTime: now(),
    endTime: now(),
    mino: newRandomMino(),
  )

proc setMino(b: var Board, m: Mino)
proc redraw(game: Game) =
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

var
  ## 現在のボード
  currentBoard = initialBoard
  ## 表示上のボード
  ## currentBoardに移動中のミノをセットしたりする
  displayBoard = initialBoard

const
  MINO_BLOCK_WIDTH = 4
  EMPTY_MINO = 0
  WALL_MINO = 1

proc fetchBlock(b: Board, x, y: int): Block =
  ## x, y座標位置の4x4のミノブロックを取得する
  var i: int
  for y2 in y..<(y+4):
    var j: int
    for x2 in x..<(x+4):
      let cell = b[y2][x2]
      result[i][j] = cell
      inc j
    inc i

proc isOverlap(self: Block, target: Block): bool =
  ## 対象のミノブロック同士に重なるものがあるかを判定する。
  ## 重なっていたらtrueを返す。
  for y, row in self:
    for x, cell in row:
      let targetCell = target[y][x]
      let overlap = cell + targetCell
      if 1 < overlap:
        return true
  return false

proc getBlock(m: Mino): Block =
  return minos[m.minoIndex][m.rotateIndex]

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

proc moveRight(m: var Mino) = m.x.inc
proc moveLeft(m: var Mino) = m.x.dec
proc moveDown(m: var Mino) = m.y.inc

proc moveLeft(game: Game) =
  if game.mino.canMoveLeft(game.minoboard.board):
    game.mino.moveLeft()

proc moveRight(game: Game) =
  if game.mino.canMoveRight(game.minoboard.board):
    game.mino.moveRight()

proc moveDown(game: Game) =
  if game.mino.canMoveDown(game.minoboard.board):
    game.mino.moveDown()

proc rotateRight(m: var Mino) =
  let incedIndex = m.rotateIndex + 1
  m.rotateIndex = if minos[m.minoIndex].len <= incedIndex:
    0
  else:
    incedIndex

proc rotateLeft(m: var Mino) =
  let decedIndex = m.rotateIndex - 1
  m.rotateIndex = if decedIndex < 0:
    minos[m.minoIndex].len - 1
  else:
    decedIndex

proc isDeletable(row: seq[int]): bool =
  for c in row:
    if c <= 0:
      return false
  return true

proc fetchRow(mb: MinoBoard, n: int): seq[int] =
  let row = mb.board[n]
  return row[mb.offset .. row.len - 1 - mb.offset]

proc setMino(b: var Board, m: Mino) =
  let blk = m.getBlock
  for y, row in blk:
    for x, cell in row:
      # 空のミノはセットしないようにする
      if cell != EMPTY_MINO:
        b[y+m.y][x+m.x] = cell

proc updateDisplayBoard(m: Mino) =
  ## 表示用ボードに降下中のミノをセットする
  displayBoard = currentBoard
  displayBoard.setMino m

proc updateCurrentBoard(m: Mino) =
  ## 現在のボードに降下不可能になったミノをセットする
  currentBoard.setMino m
  displayBoard = currentBoard

proc newRandomMino(): Mino =
  let r = 0
  #let r = random(max = minos.len)
  return Mino(minoIndex: r, x: 4, y: 0)

proc show(b: Board) =
  ## for Debug
  echo "------------------------------------"
  for row in b:
    echo row.join
  echo "------------------------------------"

proc exitProc() {.noconv.} =
  ## 終了処理
  illwillDeinit()
  showCursor()

var game = newGame()
proc waitKeyInput(n: int) {.thread.} =
  while true:
    acquire(L)
    {.gcsafe.}:
      var key = getKey()
      case key
      of Key.None: discard
      of Key.Escape, Key.Q:
        game.isStopped = true
        release(L)
        break
      of Key.J:
        game.moveDown()
      of Key.K:
        # 何もしない
        discard
      of Key.H:
        game.moveLeft()
      of Key.L:
        game.moveRight()
      of Key.Space:
        discard
      of Key.C:
        discard
      of Key.Enter:
        discard
      of Key.S:
        discard
      else: discard
    release(L)
    sleep 10

proc startMinoDownClock(n: int) {.thread.} =
  while true:
    acquire(L)
    {.gcsafe.}:
      if game.isStopped:
        release(L)
        break
      game.moveDown()
    release(L)
    sleep 1000

proc main(): int =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()

  initLock(L)

  createThread(thr[0], waitKeyInput, 0)
  createThread(thr[1], startMinoDownClock, 0)
  while not game.isStopped:
    # 後から端末の幅が変わる場合があるため
    # 端末の幅情報はループの都度取得
    let tw = terminalWidth()
    let th = terminalHeight()

    game.tb = newTerminalBuffer(tw, th)
    #tb.setForegroundColor(fgWhite, true)

    # 画面の再描画
    game.redraw()

    game.tb.display()
    sleep(100)
  joinThreads(thr)
  sync()
  exitProc()

when isMainModule and not defined modeTest:
  quit main()
