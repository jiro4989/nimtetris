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
