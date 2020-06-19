# Package

version       = "0.2.1"
author        = "jiro4989"
description   = "A simple terminal tetris in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["nimtetris"]
binDir        = "bin"

# Dependencies

requires "nim >= 1.2.2"
requires "illwill >= 0.1.0"

import os, strformat

task archive, "Create archived assets":
  let app = "nimtetris"
  let assets = &"{app}_{buildOS}"
  let dir = "dist"/assets
  mkDir dir
  cpDir "bin", dir/"bin"
  cpFile "LICENSE", dir/"LICENSE"
  cpFile "README.rst", dir/"README.rst"
  withDir "dist":
    when buildOS == "windows":
      exec &"7z a {assets}.zip {assets}"
    else:
      exec &"tar czf {assets}.tar.gz {assets}"
