##[
This testcase checks that bracket operators can be borrowed for distinct seqs.
]##

type DistinctSeq[T] = distinct seq[T]

proc `[]`*[T](s: DistinctSeq[T], i: int): T {.borrow.}
proc `[]`*[T](s: var DistinctSeq[T], i: int): var T {.borrow.}
proc `[]=`*[T](s: var DistinctSeq[T], i: int, val: T) {.borrow.}

block:
  var values = DistinctSeq(@[1, 2, 3])
  doAssert values[1] == 2
  values[1] = 4
  doAssert values[1] == 4
