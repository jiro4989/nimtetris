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
