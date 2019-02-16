include nimtetris
import unittest

suite "fetchBlock":
  const board: Board = @[
    @[1, 0, 0, 0, 1],
    @[0, 0, 0, 0, 0],
    @[0, 0, 0, 0, 0],
    @[0, 0, 0, 0, 0],
    @[1, 0, 0, 0, 1],
  ]

  test "左上取得":
    check(board.fetchBlock(0, 0) == [
      [1, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ])

  test "右上取得":
    check(board.fetchBlock(1, 0) == [
      [0, 0, 0, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ])

  test "右下取得":
    check(board.fetchBlock(1, 1) == [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 1],
    ])

  test "左下取得":
    check(board.fetchBlock(0, 1) == [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [1, 0, 0, 0],
    ])

suite "isOverlap":
  const mino = [
    [0, 0, 0, 0],
    [1, 0, 0, 0],
    [1, 1, 1, 0],
    [0, 0, 0, 0],
  ]

  test "重複あり":
    check(mino.isOverlap([
      [0, 0, 0, 0],
      [0, 1, 1, 0],
      [0, 1, 1, 0],
      [0, 0, 0, 0],
    ]) == true)

  test "重複あり":
    check(mino.isOverlap([
      [0, 0, 0, 0],
      [1, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ]) == true)

  test "重複あり":
    check(mino.isOverlap([
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [1, 0, 0, 0],
      [0, 0, 0, 0],
    ]) == true)

  test "重複なし":
    check(mino.isOverlap([
      [1, 1, 1, 1],
      [0, 1, 1, 1],
      [0, 0, 0, 1],
      [1, 1, 1, 1],
    ]) == false)

  test "重複なし":
    check(mino.isOverlap([
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ]) == false)

suite "canMoveRight":
  const board1 = @[
    @[1, 0, 0, 0, 0, 1, 1],
    @[1, 0, 0, 0, 0, 1, 1],
    @[1, 0, 0, 0, 0, 1, 1],
    @[1, 0, 0, 0, 0, 1, 1],
    @[1, 0, 0, 0, 0, 1, 1],
    @[1, 1, 1, 1, 1, 1, 1],
  ]

  test "移動可能":
    check(Mino(minoIndex: 0, x: 0, y: 0).canMoveRight(board1) == true)
  test "移動可能。移動後は壁に接する":
    check(Mino(minoIndex: 0, x: 1, y: 0).canMoveRight(board1) == true)
  test "移動不可。壁と重なる":
    check(Mino(minoIndex: 0, x: 2, y: 0).canMoveRight(board1) == false)
  test "移動不可。配列範囲外":
    check(Mino(minoIndex: 0, x: 3, y: 0).canMoveRight(board1) == false)

suite "canMoveLeft":
  const board2 = @[
    @[1, 1, 0, 0, 0, 0, 1],
    @[1, 1, 0, 0, 0, 0, 1],
    @[1, 1, 0, 0, 0, 0, 1],
    @[1, 1, 0, 0, 0, 0, 1],
    @[1, 1, 0, 0, 0, 0, 1],
    @[1, 1, 1, 1, 1, 1, 1],
  ]

  test "移動可能。壁に接する":
    check(Mino(minoIndex: 0, x: 2, y: 0).canMoveLeft(board2) == true)
  test "移動不可。壁と重なる":
    check(Mino(minoIndex: 0, x: 1, y: 0).canMoveLeft(board2) == false)
  test "移動不可。配列範囲外":
    check(Mino(minoIndex: 0, x: 0, y: 0).canMoveLeft(board2) == false)

suite "canMoveDown":
  const board2 = @[
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 1, 1, 1, 1, 1, 1],
    @[1, 1, 1, 1, 1, 1, 1],
  ]

  test "移動可能。壁に接する":
    check(Mino(minoIndex: 0, x: 0, y: 0).canMoveDown(board2) == true)
  test "移動不可。壁と重なる":
    check(Mino(minoIndex: 0, x: 0, y: 1).canMoveDown(board2) == false)
  test "移動不可。配列範囲外":
    check(Mino(minoIndex: 0, x: 0, y: 2).canMoveDown(board2) == false)

suite "rotateRight":
  discard

suite "rotateLeft":
  discard

suite "isDeletable":
  test "削除可能。すべて1":
    check @[1, 1, 1, 1].isDeletable == true
  test "削除可能。すべて0でない":
    check @[1, 2, 3, 4].isDeletable == true
  test "削除不可。1つは0が存在する":
    check @[1, 1, 0, 1].isDeletable == false
  test "削除不可。すべて0":
    check @[0, 0, 0, 0].isDeletable == false

suite "fetchRow":
  const board = @[
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 0, 0, 0, 0, 1],
    @[1, 0, 1, 0, 0, 0, 1],
    @[1, 1, 1, 1, 1, 1, 1],
  ]

  let mb = MinoBoard(board: board, offset: 1)
  test "ミノの存在しない行を取得する":
    check mb.fetchRow(0) == @[0, 0, 0, 0, 0]
  test "ミノの存在する行を取得する":
    check mb.fetchRow(4) == @[0, 1, 0, 0, 0]

suite "setMino":
  test "壁際に値がセットされる":
    var board = @[
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 1, 1, 1, 1, 1, 1],
    ]
    let mino = Mino(minoIndex: 0, x: 0, y: 2)
    board.setMino mino
    check(board == @[
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 1, 1, 0, 0, 0, 1],
      @[1, 1, 1, 0, 0, 0, 1],
      @[1, 1, 1, 1, 1, 1, 1],
    ])

  test "トップにセットされる":
    var board = @[
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 1, 1, 1, 1, 1, 1],
    ]
    let mino = Mino(minoIndex: 0, x: 2, y: 0)
    board.setMino mino
    check(board == @[
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 1, 1, 0, 1],
      @[1, 0, 0, 1, 1, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 0, 0, 0, 0, 0, 1],
      @[1, 1, 1, 1, 1, 1, 1],
    ])
