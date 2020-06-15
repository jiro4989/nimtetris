# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "Terminal tetris"
license       = "MIT"
srcDir        = "src"
bin           = @["nimtetris"]
binDir        = "bin"

import strformat

# Dependencies

requires "nim >= 1.2.0"
requires "illwill >= 0.1.0"

task buildjs, "JSをビルドする":
  let packageName = bin[0]
  exec &"nimble js -o:static/js/{packageName}.js src/{packageName}.nim"
