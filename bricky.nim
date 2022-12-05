import std/[
  random,
  dom
]

import "."/[
  typedefs
]

proc elem(brick: Brick): Element =
  result = document.getElementById(brick.trackingId.cstring)

  if result == nil:
    result = document.createElement("div")
    result.id = brick.trackingId.cstring

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
  genTmpl: string, displayAs: string, head, foot, maxNestedWallCount: int) =

  let wallId = TrackingId.new()
  let brick = Brick(version: 1, trackingId: wallId)

  var wallElem = document.createElement("div")
  var brickElem = document.createElement("div")

  wallElem.id = $wallId