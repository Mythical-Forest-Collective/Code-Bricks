import std/[
  strutils,
  dom
]

type
  TrackingId* = distinct string

  Tag* = object
    language*, module*, function*: string

  Argument* = object
    name*, typ*: string

  Brick* = object
    version*: int
    parent*: TrackingId
    tag*: Tag
    arguments*: seq[Argument]
    genTmpl*: string
    displayed*: string
    head*, foot*: int
    maxNestedWallCount*: int
    nestedWalls*: seq[TrackingId]
    trackingId*: TrackingId

  Wall* = object
    version*: int
    children*: seq[TrackingId]
    trackingId*: TrackingId

proc `$`*(tag: Tag): string = tag.language & "::" & tag.module & "::" & tag.function
proc `$`*(id: TrackingId): string = id.string

proc `==`*(a, b: TrackingId): bool = $a == $b

proc t*(tagStr: string): Tag =
  let splitTag = tagStr.split("::")

  if splitTag.len != 3:
    raise newException(IndexDefect, "Can only accept 2 instances of `::`!")

  result.language = splitTag[0]
  result.module = splitTag[1]
  result.function = splitTag[2]

proc elem*(brick: Brick): Element =
  result = document.getElementById(brick.trackingId.cstring)

  if result == nil:
    result = document.createElement("div")
    result.id = brick.trackingId.cstring

    result.classList.add("brick")
    result.classList.add("laidbrick")

    for str in brick.displayed.split(" "):
      if str.startsWith("<") and str.endsWith(">"):
        var displayed = document.createElement("div")
        displayed.classList.add("variable")
        result.appendChild(displayed)

      else:
        result.appendChild(document.createTextNode(str.cstring))


proc elem*(wall: Wall): Element =
  result = document.getElementById(wall.trackingId.cstring)

  if result == nil:
    result = document.createElement("div")
    result.id = wall.trackingId.cstring
    result.setAttr("draggable", "true")

    document.getElementById("bricklayer").appendChild(result)

    result.classList.add("wall")