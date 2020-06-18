import unittest

include nimtetrispkg/board

let board = @[
  @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, ],
  @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
  @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
  @[FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
  @[FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, ],
]

suite "proc fetchBlock":
  test "x = 0, y = 0":
    let got = board.fetchBlock(x = 0, y = 0)
    let want = [
      [FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, ],
      [FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, ],
      [FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, ],
      [FILLED_MINO1, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, ],
    ]
    check want == got
  test "x = 1, y = 1":
    let got = board.fetchBlock(x = 1, y = 1)
    let want = [
      [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
      [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
      [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, FILLED_MINO1, ],
      [FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, FILLED_MINO1, ],
    ]
    check want == got

suite "proc setRow":
  test "test":
    var board = @[
      @[EMPTY_MINO, EMPTY_MINO, ],
      @[EMPTY_MINO, EMPTY_MINO, ],
    ]
    let row = @[FILLED_MINO1, FILLED_MINO2]
    board.setRow(row, 0, 0)
    let want = @[
      @[FILLED_MINO1, FILLED_MINO2],
      @[EMPTY_MINO, EMPTY_MINO, ],
    ]
    check want == board
