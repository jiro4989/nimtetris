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
    mb.deleteRow(1)

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

