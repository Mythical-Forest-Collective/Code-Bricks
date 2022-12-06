import std/[
  sequtils,
  random,
  dom
]

import "."/[
  typedefs
]

const LowercaseLetters = "abcdefghijklmnopqrstuvwxyz"

var bricks: seq[Brick]
var walls: seq[Wall]

# Also tries to prevent duplicate IDs
proc new*(_: typedesc[TrackingId], length: int=5): TrackingId =
  var dupl = true
  var res: string

  while dupl:
    dupl = false
    res = ""

    randomize()
    for i in 1..5:
      res &= LowercaseLetters[rand(LowercaseLetters.len - 1)]

    for brick in bricks:
      if brick.trackingId.string == res or dupl:
        dupl = true
        break

    for wall in walls:
      if wall.trackingId.string == res or dupl:
        dupl = true
        break

  return res.TrackingId

proc getBrickFromId*(id: TrackingId): Brick =
  for brick in bricks:
    if brick.trackingId == id:
      result = brick
      break

  raise newException(IndexDefect, "The brick you're trying to access does not exist!")

proc getWallFromId*(id: TrackingId): Wall =
  for wall in walls:
    if wall.trackingId == id:
      result = wall
      break

  raise newException(IndexDefect, "The brick you're trying to access does not exist!")

proc create*(_: typedesc[Brick], tag: Tag, arguments: openArray[Argument],
  genTmpl: string, displayAs: string, head, foot, maxNestedWallCount: int=0) =

  var wall = Wall(version: 1, trackingId: TrackingId.new())
  var brick = Brick(version: 1, trackingId: TrackingId.new(), arguments: arguments.toSeq(),
  genTmpl: genTmpl, displayed: displayAs)

  wall.children.add(brick.trackingId)
  brick.parent = wall.trackingId

  walls.add(wall)
  bricks.add(brick)

  document.getElementById("bricklayer").appendChild(wall.elem)

  wall.elem.appendChild(brick.elem)


proc load*() {.cdecl, exportc.} =
  document.body.addEventListener($DragStart, proc(e: Event) =
    echo "Drag Start!"
  )

  document.body.addEventListener($DragEnd, proc(e: Event) =
    echo "Drag End!"
  )

  document.body.addEventListener($KeyDown, proc(e: Event) =
    let event = e.KeyboardEvent
    if event.key == "q":
      echo "Created block!"
      Brick.create("python::builtins::print".t, @[Argument(name: "message", typ: "string")],
      "print(<message>)", "print <message>")
  )