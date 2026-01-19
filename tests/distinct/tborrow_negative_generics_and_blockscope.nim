##[
This testcase checks several things:

1. It checks the negative case that a distinct type that does not borrow the
  `[]` operator does not have access to it.
2. It checks that multiple distinct types can be declared from the same parent
   type and can borrow the same function from the parent.
3. It checks that you can borrow from a generic parent type and borrow generic
   functions from that parent type.
4. It checks that bracket operators can be borrowed when in block scope.
5. It checks that bracket operators can be borrowed for distinct seqs.
]##


# See 1. and 2.
type A0 = distinct array[3, int]
type A1 = distinct array[3, int]
type A2 = distinct array[3, int]

proc `[]`*(a: A0, i: int): int {.borrow.}
proc `[]`*(a: var A0, i: int): var int {.borrow.}
proc `[]=`*(a: var A0, i: int, val: int) {.borrow.}
proc `[]`*(a: A1, i: int): int {.borrow.}
proc `[]`*(a: var A1, i: int): var int {.borrow.}
proc `[]=`*(a: var A1, i: int, val: int) {.borrow.}

var a0: A0
doAssert compiles(a0[0] == 0)

var a1: A1
doAssert compiles(a1[0] == 0)

var a2: A2
doAssert not compiles(a2[0] == 0)

# See 2. and 3.
type A3[T] = distinct array[3, T]
type A4[T] = distinct array[3, T]
type A5[T] = distinct array[3, T]

proc `[]`*[T](a: A3[T], i: int): T {.borrow.}
proc `[]`*[T](a: var A3[T], i: int): var T {.borrow.}
proc `[]=`*[T](a: var A3[T], i: int, val: T) {.borrow.}
proc `[]`*[T](a: A4[T], i: int): T {.borrow.}
proc `[]`*[T](a: var A4[T], i: int): var T {.borrow.}
proc `[]=`*[T](a: var A4[T], i: int, val: T) {.borrow.}

var a3: A3[int]
doAssert compiles(a3[0] == 0)

var a4: A4[int]
doAssert compiles(a4[0] == 0)

var a5: A5[int]
doAssert not compiles(a5[0] == 0)

# See 4.
block BLOCK_TEST:
  type A6[T] = distinct array[3, T]
  type A7[T] = distinct array[3, T]
  type A8[T] = distinct array[3, T]

  proc `[]`[T](a: A6[T], i: int): T {.borrow.}
  proc `[]`[T](a: var A6[T], i: int): var T {.borrow.}
  proc `[]=`[T](a: var A6[T], i: int, val: T) {.borrow.}
  proc `[]`[T](a: A7[T], i: int): T {.borrow.}
  proc `[]`[T](a: var A7[T], i: int): var T {.borrow.}
  proc `[]=`[T](a: var A7[T], i: int, val: T) {.borrow.}

  var a6: A6[float]
  doAssert compiles(a6[0] == 0)

  var a7: A7[float]
  doAssert compiles(a7[0] == 0)

  var a8: A8[float]
  doAssert not compiles(a8[0] == 0)

# See 5.
type Seq0 = distinct seq[int]
type Seq1 = distinct seq[int]

proc `[]`*(s: Seq0, i: int): int {.borrow.}
proc `[]`*(s: var Seq0, i: int): var int {.borrow.}
proc `[]=`*(s: var Seq0, i: int, val: int) {.borrow.}

var seq0 = Seq0(@[1, 2, 3])
doAssert compiles(seq0[1] == 2)

var seq1 = Seq1(@[1, 2, 3])
doAssert not compiles(seq1[1] == 2)
