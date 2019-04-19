# Package

version       = "0.1.0"
author        = "Zev Kronenberg, Christopher Dunn"
description   = "Bioinformatics libraries"
license       = "BSD-3-Clause"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.4"

task integ, "Runs integration tests":
  let cmd = "nim c -r test/kmer_test1"
  echo cmd
  exec cmd
