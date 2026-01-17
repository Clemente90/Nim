type
  RawVec = array[3, int]
  DistinctVec = distinct RawVec

proc `[]`(v: DistinctVec; i: int): int {.barrow.}
proc `[]=`(v: var DistinctVec; i: int; value: int) {.barrow.}

var v = DistinctVec([1, 2, 3])

doAssert v[0] == 1
v[1] = 42
doAssert v[1] == 42
