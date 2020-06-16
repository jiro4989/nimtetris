import random
import types

type
  Mino* = object
    rotateIndex: int
    minoIndex: int
    x*: int
    y*: int

const
  minos* = @[
    @[
      [
        [0, 0, 0, 0],
        [0, 2, 2, 0],
        [2, 2, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 2, 0, 0],
        [0, 2, 2, 0],
        [0, 0, 2, 0],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [
        [0, 0, 0, 0],
        [0, 4, 4, 0],
        [0, 0, 4, 4],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 4],
        [0, 0, 4, 4],
        [0, 0, 4, 0],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [
        [0, 0, 0, 0],
        [0, 8, 0, 0],
        [8, 8, 8, 0],
        [0, 0, 0, 0],
      ],
      [
        [8, 0, 0, 0],
        [8, 8, 0, 0],
        [8, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [8, 8, 8, 0],
        [0, 8, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 8, 0],
        [0, 8, 8, 0],
        [0, 0, 8, 0],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [
        [0, 0, 0, 0],
        [0, 16, 0, 0],
        [0, 16, 16, 16],
        [0, 0, 0, 0],
      ],
      [
        [0, 16, 16, 0],
        [0, 16, 0, 0],
        [0, 16, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 16, 16, 16],
        [0, 0, 0, 16],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 16],
        [0, 0, 0, 16],
        [0, 0, 16, 16],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [
        [0, 0, 0, 0],
        [0, 0, 32, 0],
        [32, 32, 32, 0],
        [0, 0, 0, 0],
      ],
      [
        [32, 0, 0, 0],
        [32, 0, 0, 0],
        [32, 32, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [32, 32, 32, 0],
        [32, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 32, 32, 0],
        [0, 0, 32, 0],
        [0, 0, 32, 0],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [ [0, 0, 0, 0],
        [0, 64, 64, 0],
        [0, 64, 64, 0],
        [0, 0, 0, 0],
      ],
    ],
    @[
      [
        [0, 128, 0, 0],
        [0, 128, 0, 0],
        [0, 128, 0, 0],
        [0, 128, 0, 0],
      ],
      [
        [0, 0, 0, 0],
        [128, 128, 128, 128],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 128, 0],
        [0, 0, 128, 0],
        [0, 0, 128, 0],
        [0, 0, 128, 0],
      ],
      [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [128, 128, 128, 128],
        [0, 0, 0, 0],
      ],
    ],
  ]
  MINO_BLOCK_WIDTH* = 4
  EMPTY_MINO* = 0
  FILLED_MINO1* = 1
  FILLED_MINO2* = 2
  FILLED_MINO3* = 4
  FILLED_MINO4* = 8
  FILLED_MINO5* = 16
  FILLED_MINO6* = 32
  FILLED_MINO7* = 64
  FILLED_MINO8* = 128

randomize()

proc newRandomMino*(): Mino =
  let r = rand(0 .. minos.high)
  return Mino(minoIndex: r, x: 4, y: 0)

proc getBlock*(m: Mino): Block =
  return minos[m.minoIndex][m.rotateIndex]

proc moveRight*(m: var Mino) =
  m.x.inc

proc moveLeft*(m: var Mino) =
  m.x.dec

proc moveDown*(m: var Mino) =
  m.y.inc

proc rotateRight*(m: var Mino) =
  let incedIndex = m.rotateIndex + 1
  m.rotateIndex = if minos[m.minoIndex].len <= incedIndex:
    0
  else:
    incedIndex

proc rotateLeft*(m: var Mino) =
  let decedIndex = m.rotateIndex - 1
  m.rotateIndex = if decedIndex < 0:
    minos[m.minoIndex].len - 1
  else:
    decedIndex

