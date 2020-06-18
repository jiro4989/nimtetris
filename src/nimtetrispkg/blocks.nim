type
  Block* = array[4, array[4, int]]

proc isOverlap*(self: Block, target: Block): bool =
  ## 対象のミノブロック同士に重なるものがあるかを判定する。
  ## 重なっていたらtrueを返す。
  for y, row in self:
    for x, cell in row:
      let targetCell = target[y][x]
      if 0 notin [cell, targetCell]:
        return true

