import os, threadpool, locks
import illwill
import nimtetrispkg/game

var
  thr: array[2, Thread[int]]
  L: Lock

proc exitProc() {.noconv.} =
  ## 終了処理
  illwillDeinit()
  showCursor()

var gameobj = newGame()

proc waitKeyInput(n: int) {.thread.} =
  while true:
    acquire(L)
    {.gcsafe.}:
      var key = getKey()
      case key
      of Key.None: discard
      of Key.Escape, Key.Q:
        gameobj.stop()
        release(L)
        break
      of Key.U:
        gameobj.rotateLeft()
      of Key.O:
        gameobj.rotateRight()
      of Key.J:
        gameobj.moveDown()
      of Key.K:
        # 何もしない
        discard
      of Key.H:
        gameobj.moveLeft()
      of Key.L:
        gameobj.moveRight()
      of Key.Space:
        gameobj.moveDownToBottom()
      of Key.C:
        discard
      of Key.Enter:
        discard
      of Key.S:
        discard
      else: discard
    release(L)
    sleep 10

proc startMinoDownClock(n: int) {.thread.} =
  while true:
    acquire(L)
    {.gcsafe.}:
      if gameobj.isStopped:
        release(L)
        break
      if gameobj.canMoveDown():
        gameobj.moveDown()
      else:
        gameobj.setCurrentMino()
        gameobj.setRandomMino()
    release(L)
    sleep 1000

proc main(): int =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()

  initLock(L)

  createThread(thr[0], waitKeyInput, 0)
  createThread(thr[1], startMinoDownClock, 0)
  while not gameobj.isStopped:
    gameobj.redraw()
    sleep(100)
  joinThreads(thr)
  sync()
  exitProc()

when isMainModule and not defined modeTest:
  quit main()
