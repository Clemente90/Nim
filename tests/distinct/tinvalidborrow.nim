discard """
  cmd: "nim check --hints:off --warnings:off $file"
  action: "reject"
  nimout:'''
tinvalidborrow.nim(67, 3) Error: only a 'distinct' type can borrow `.`
tinvalidborrow.nim(68, 3) Error: only a 'distinct' type can borrow `.`
tinvalidborrow.nim(69, 1) Error: borrow proc without distinct type parameter is meaningless
tinvalidborrow.nim(78, 6) Error: type mismatch: got <HeapQueue[len.T]>
but expected one of:
func len(x: (type array) | array): int
  first type mismatch at position: 1
  required type for x: typedesc[array] or array
  but expression 'h' is of type: HeapQueue[len.T]
func len(x: string): int
  first type mismatch at position: 1
  required type for x: string
  but expression 'h' is of type: HeapQueue[len.T]
func len[TOpenArray: openArray | varargs](x: TOpenArray): int
  first type mismatch at position: 1
  required type for x: TOpenArray: openArray or varargs
  but expression 'h' is of type: HeapQueue[len.T]
func len[T](x: seq[T]): int
  first type mismatch at position: 1
  required type for x: seq[T]
  but expression 'h' is of type: HeapQueue[len.T]
func len[T](x: set[T]): int
  first type mismatch at position: 1
  required type for x: set[T]
  but expression 'h' is of type: HeapQueue[len.T]
proc len(w: WideCString): int
  first type mismatch at position: 1
  required type for w: WideCString
  but expression 'h' is of type: HeapQueue[len.T]
proc len(w: WideCStringObj): int
  first type mismatch at position: 1
  required type for w: WideCStringObj
  but expression 'h' is of type: HeapQueue[len.T]
proc len(x: cstring): int
  first type mismatch at position: 1
  required type for x: cstring
  but expression 'h' is of type: HeapQueue[len.T]
proc len[T](h: HeapQueue[T]): int
  first type mismatch at position: 1
  required type for h: HeapQueue[len.T]
  but expression 'h' is of type: HeapQueue[len.T]
proc len[U: Ordinal; V: Ordinal](x: HSlice[U, V]): int
  first type mismatch at position: 1
  required type for x: HSlice[len.U, len.V]
  but expression 'h' is of type: HeapQueue[len.T]

expression: len(h)
tinvalidborrow.nim(78, 1) Error: no symbol to borrow from found
'''
"""





# bug #516

type
  TAtom = culong
  Test {.borrow:`.`.} = distinct int
  Foo[T] = object
    a: int
  Bar[T] {.borrow:`.`.} = Foo[T]
  OtherFoo {.borrow:`.`.} = Foo[int]
proc `==`*(a, b: TAtom): bool {.borrow.}

var
  d, e: TAtom

discard( $(d == e) )

# issue #4121
type HeapQueue[T] = distinct seq[T]
proc len*[T](h: HeapQueue[T]): int {.borrow.}

# issue #3564
type vec4[T] = distinct array[4, float32]

proc `[]`(v: vec4, i: int): float32 {.borrow.}
proc `[]=`(v: vec4, i: int, va: float32) {.borrow.}
