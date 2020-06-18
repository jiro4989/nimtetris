import unittest

include nimtetrispkg/mino

suite "proc newRandomMino":
  test "test":
    let m = newRandomMino()
    check m.x == 4
    check m.y == 0

suite "proc getBlock":
  test "rotateIndex = 0, minoIndex = 0":
    let m = Mino(rotateIndex: 0, minoIndex: 0)
    let got = m.getBlock
    let want = [
        [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO],
        [EMPTY_MINO, FILLED_MINO2, FILLED_MINO2, EMPTY_MINO],
        [FILLED_MINO2, FILLED_MINO2, EMPTY_MINO, EMPTY_MINO],
        [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO],
      ]
    check want == got
  test "rotateIndex = 1, minoIndex = 0":
    let m = Mino(rotateIndex: 1, minoIndex: 0)
    let got = m.getBlock
    let want = [
        [EMPTY_MINO, FILLED_MINO2, EMPTY_MINO, EMPTY_MINO],
        [EMPTY_MINO, FILLED_MINO2, FILLED_MINO2, EMPTY_MINO],
        [EMPTY_MINO, EMPTY_MINO, FILLED_MINO2, EMPTY_MINO],
        [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO],
      ]
    check want == got
  test "rotateIndex = 0, minoIndex = 1":
    let m = Mino(rotateIndex: 0, minoIndex: 1)
    let got = m.getBlock
    let want = [
        [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO],
        [EMPTY_MINO, FILLED_MINO3, FILLED_MINO3, EMPTY_MINO],
        [EMPTY_MINO, EMPTY_MINO, FILLED_MINO3, FILLED_MINO3],
        [EMPTY_MINO, EMPTY_MINO, EMPTY_MINO, EMPTY_MINO],
      ]
    check want == got

suite "proc moveRight":
  test "test":
    var m = Mino()
    m.moveRight
    check m.x == 1
    check m.y == 0

suite "proc moveLeft":
  test "test":
    var m = Mino()
    m.moveLeft
    check m.x == -1
    check m.y == 0

suite "proc moveDown":
  test "test":
    var m = Mino()
    m.moveDown
    check m.x == 0
    check m.y == 1
