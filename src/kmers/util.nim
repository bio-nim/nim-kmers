# vim: sts=4:ts=4:sw=4:et:tw=0

type PbError* = object of Exception

proc raiseEx*(msg: string) {.discardable.} =
    raise newException(PbError, msg)

template withcd*(newdir: string, statements: untyped) =
    let olddir = os.getCurrentDir()
    os.setCurrentDir(newdir)
    defer: os.setCurrentDir(olddir)
    statements
