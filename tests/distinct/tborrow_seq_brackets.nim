##[
This testcase checks that bracket operators can be borrowed on distinct seqs,
while remaining opt-in per type.
]##

type SeqA = distinct seq[int]
type SeqB = distinct seq[int]

proc `[]`*(s: SeqA, i: int): int {.borrow.}
proc `[]`*(s: var SeqA, i: int): var int {.borrow.}
proc `[]=`*(s: var SeqA, i: int, val: int) {.borrow.}

doAssert compiles((block:
  var s = SeqA(@[1, 2, 3])
  s[0] == 1
))

doAssert compiles((block:
  var s = SeqA(@[1, 2, 3])
  s[0] = 4
))

doAssert not compiles((block:
  var s = SeqB(@[1, 2, 3])
  discard s[0]
))
