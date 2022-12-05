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
    bricks*: seq[TrackingId]
    trackingId*: TrackingId

proc `$`*(tag: Tag): string = tag.language & "::" & tag.module & "::" & tag.function
proc `$`*(id: TrackingId): string = id.string

proc `==`*(a, b: TrackingId): bool = $a == $b