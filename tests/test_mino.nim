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

suite "proc rotateRight":
  test "from 0 to 1":
    var m = Mino(minoIndex: 2)
    m.rotateRight
    check m.rotateIndex == 1
    m.rotateRight
    check m.rotateIndex == 2
  test "from 3 to 0":
    var m = Mino(minoIndex: 2, rotateIndex: 3)
    m.rotateRight
    check m.rotateIndex == 0

suite "proc rotateLeft":
  test "from 2 to 1":
    var m = Mino(minoIndex: 2, rotateIndex: 2)
    m.rotateLeft
    check m.rotateIndex == 1
  test "from 0 to 3":
    var m = Mino(minoIndex: 2)
    m.rotateLeft
    check m.rotateIndex == 3
    m.rotateLeft
    check m.rotateIndex == 2
