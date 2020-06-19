import unittest

include nimtetrispkg/game

when false:
  suite "proc setMino":
    test "test":
      var game = newGame()
      let mino = Mino()
      game.minoboard.board.setMino(mino)
      check want == game.minoboard.board

  suite "proc setCurrentMino":
    test "test":
      discard

suite "proc fetchRow":
  test "test":
    let board = @[
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, FILLED_MINO2, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
    ]
    let mb = MinoBoard(board: board, offset: 2)
    block:
      let got = mb.fetchRow(0)
      let want = @[EMPTY_MINO, EMPTY_MINO, EMPTY_MINO]
      check want == got
    block:
      let got = mb.fetchRow(1)
      let want = @[EMPTY_MINO, FILLED_MINO2, EMPTY_MINO]
      check want == got

suite "proc isDeletable":
  test "is not deletable":
    let row = @[EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, ]
    check not row.isDeletable
  test "is not deletable":
    let row = @[EMPTY_MINO, FILLED_MINO2, FILLED_MINO3]
    check not row.isDeletable
  test "is deletable":
    let row = @[FILLED_MINO1, FILLED_MINO2, FILLED_MINO3]
    check row.isDeletable
  test "is deletable":
    let row = @[FILLED_MINO2, FILLED_MINO2, FILLED_MINO2]
    check row.isDeletable

suite "proc deleteRow":
  test "test":
    let board = @[
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO3, EMPTY_MINO, FILLED_MINO4,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO2, FILLED_MINO3, FILLED_MINO4, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
    ]
    var mb = MinoBoard(board: board, offset: 2)
    check mb.deleteRow(1)

    let want = @[
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO3, EMPTY_MINO, FILLED_MINO4,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
    ]
    check want == mb.board

suite "proc deleteFilledRows":
  test "test":
    let board = @[
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO3, EMPTY_MINO, FILLED_MINO4,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO2, FILLED_MINO3, FILLED_MINO4, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, FILLED_MINO2,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO5, FILLED_MINO4, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
    ]
    var game = newGame()
    game.minoboard = MinoBoard(board: board, offset: 2)
    game.deleteFilledRows

    let want = @[
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO3, EMPTY_MINO, FILLED_MINO4,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, FILLED_MINO2,   FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
      @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1,],
    ]
    check want == game.minoboard.board
    check 200 == game.score

suite "proc canMoveRight":
  setup:
    var game = newGame()
  test "can move":
    var m = Mino(x: 3, y: 0)
    check m.canMoveRight(game.minoboard.board)
  test "can move":
    var m = Mino(x: 7, y: 0)
    check m.canMoveRight(game.minoboard.board)
  test "can not move":
    var m = Mino(x: 8, y: 0)
    check not m.canMoveRight(game.minoboard.board)

suite "proc canMoveLeft":
  setup:
    var game = newGame()
  test "can move":
    var m = Mino(x: 8, y: 0)
    check m.canMoveLeft(game.minoboard.board)
  test "can move":
    var m = Mino(x: 3, y: 0)
    check m.canMoveLeft(game.minoboard.board)
  test "can not move":
    var m = Mino(x: 2, y: 0)
    check not m.canMoveLeft(game.minoboard.board)

suite "proc canMoveDown":
  setup:
    var game = newGame()
  test "can move":
    var m = Mino(x: 4, y: 0)
    check m.canMoveDown(game.minoboard.board)
  test "can move":
    var m = Mino(x: 4, y: 13)
    check m.canMoveDown(game.minoboard.board)
  test "can not move":
    var m = Mino(x: 4, y: 14)
    check not m.canMoveDown(game.minoboard.board)

suite "proc moveRight":
  setup:
    var game = newGame()
  test "moved":
    game.mino = Mino(x: 3, y: 0)
    game.moveRight()
    check 4 == game.mino.x
  test "moved":
    game.mino = Mino(x: 7, y: 0)
    game.moveRight()
    check 8 == game.mino.x
  test "cannnot move":
    game.mino = Mino(x: 8, y: 0)
    game.moveRight()
    check 8 == game.mino.x

suite "proc moveLeft":
  setup:
    var game = newGame()
  test "moved":
    game.mino = Mino(x: 8, y: 0)
    game.moveLeft()
    check 7 == game.mino.x
  test "moved":
    game.mino = Mino(x: 3, y: 0)
    game.moveLeft()
    check 2 == game.mino.x
  test "cannot move":
    game.mino = Mino(x: 2, y: 0)
    game.moveLeft()
    check 2 == game.mino.x

suite "proc moveDown":
  setup:
    var game = newGame()
  test "moved":
    game.mino = Mino(x: 4, y: 0)
    game.moveDown()
    check 1 == game.mino.y
  test "moved":
    game.mino = Mino(x: 4, y: 13)
    game.moveDown()
    check 14 == game.mino.y
  test "cannot moved":
    game.mino = Mino(x: 4, y: 14)
    game.moveDown()
    check 14 == game.mino.y

suite "proc moveDownToBottom":
  setup:
    var game = newGame()
  test "moved":
    game.mino = Mino(x: 4, y: 0)
    game.moveDownToBottom()
    check 0 == game.mino.y
    check FILLED_MINO2 == game.minoboard.board[16][4]
    check FILLED_MINO2 == game.minoboard.board[16][5]
  test "moved":
    game.mino = Mino(x: 4, y: 1)
    game.moveDownToBottom()
    check 0 == game.mino.y
    check FILLED_MINO2 == game.minoboard.board[16][4]
    check FILLED_MINO2 == game.minoboard.board[16][5]

suite "proc canRotateRight":
  setup:
    var game = newGame()
  test "can rotate: x = 2":
    game.mino = Mino(x: 2, y: 0)
    check game.canRotateRight()
  test "can rotate: x = 8":
    game.mino = Mino(x: 8, y: 0)
    check game.canRotateRight()
  test "cannot rotate: x = 1":
    game.mino = Mino(x: 2, y: 0)
    game.mino.rotateRight()
    game.mino.x = 1
    check not game.canRotateRight()

suite "proc canRotateLeft":
  setup:
    var game = newGame()
  test "can rotate":
    game.mino = Mino(x: 2, y: 0)
    check game.canRotateLeft()
  test "cannot rotate":
    game.mino = Mino(x: 2, y: 0)
    game.mino.rotateLeft()
    game.mino.x = 1
    check not game.canRotateLeft()

suite "proc color":
  test "EMPTY_MINO": check bgBlack == color(EMPTY_MINO)
  test "FILLED_MINO1": check bgWhite == color(FILLED_MINO1)
  test "FILLED_MINO2": check bgRed == color(FILLED_MINO2)
  test "FILLED_MINO3": check bgGreen == color(FILLED_MINO3)
  test "FILLED_MINO4": check bgYellow == color(FILLED_MINO4)
  test "FILLED_MINO5": check bgBlue == color(FILLED_MINO5)
  test "FILLED_MINO6": check bgMagenta == color(FILLED_MINO6)
  test "FILLED_MINO7": check bgCyan == color(FILLED_MINO7)
  test "FILLED_MINO8": check bgCyan == color(FILLED_MINO8)

suite "proc stop / isStopped":
  test "test":
    var game = newGame()
    check not game.isStopped
    game.stop()
    check game.isStopped

suite "proc labelText":
  test "TIME":
    check " TIME     " == labelText("TIME", 10)
  test "sec":
    check " 20 sec   " == labelText("20 sec", 10)
