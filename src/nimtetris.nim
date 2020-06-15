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
  MinoBoard = ref object
    board: Board
    offset: int
  Board = seq[seq[int]]
  Block = array[4, array[4, int]]
  Mino = ref object
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
  thr: Thread[Game]
  L: Lock

proc newMinoBoard(): MinoBoard =
  result = MinoBoard(board: initialBoard)

proc newGame(): Game =
  result = Game(
    minoboard: newMinoBoard(),
    startTime: now(),
    endTime: now())

proc redraw(game: Game) =
  let timeDiff = now() - game.startTime
  game.tb.write(0, 0, $timeDiff)
  for y, row in game.minoboard.board:
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
  currentBoard {.exportc.} = initialBoard
  ## 表示上のボード
  ## currentBoardに移動中のミノをセットしたりする
  displayBoard {.exportc.} = initialBoard

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

proc startKeyInput(game: Game) {.thread.} =
  while true:
    acquire(L)
    {.gcsafe.}:
      var key = getKey()
    release(L)
    case key
    of Key.None: discard
    of Key.Escape, Key.Q:
      game.isStopped = true
      break
    of Key.J:
      discard
    of Key.K:
      discard
    of Key.H:
      discard
    of Key.L:
      discard
    of Key.Space:
      discard
    of Key.C:
      discard
    of Key.Enter:
      discard
    of Key.S:
      discard
    else: discard

proc main(): int =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()

  initLock(L)

  var game = newGame()
  createThread(thr, startKeyInput, game)
  while game.isStopped:
    # 後から端末の幅が変わる場合があるため
    # 端末の幅情報はループの都度取得
    let tw = terminalWidth()
    let th = terminalHeight()

    game.tb = newTerminalBuffer(tw, th)
    #tb.setForegroundColor(fgWhite, true)

    # 画面の再描画
    game.redraw()

    game.tb.display()
    sleep(1000)
  joinThread(thr)
  sync()
  exitProc()

when isMainModule and not defined modeTest:
  quit main()
