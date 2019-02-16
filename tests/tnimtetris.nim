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

const board1 = @[
  @[1, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 1],
  @[1, 0, 0, 0, 0, 0, 1],
  @[1, 1, 1, 1, 1, 1, 1],
]

suite "canMoveRight":
  test "移動可能":
    check(Mino(minoIndex: 0, x: 0, y: 0).canMoveRight(board1) == true)
  test "移動可能。移動後は壁に接する":
    check(Mino(minoIndex: 0, x: 2, y: 0).canMoveRight(board1) == true)
  test "移動不可。壁と重なる":
    check(Mino(minoIndex: 0, x: 3, y: 0).canMoveRight(board1) == false)
  test "移動不可":
    check(Mino(minoIndex: 0, x: 4, y: 0).canMoveRight(board1) == false)

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