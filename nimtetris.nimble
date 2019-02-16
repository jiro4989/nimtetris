# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["nimtetris"]

import strformat

# Dependencies

requires "nim >= 0.19.0"

task buildjs, "JSをビルドする":
  let packageName = bin[0]
  exec &"nimble js -o:static/js/{packageName}.js src/{packageName}.nim"
