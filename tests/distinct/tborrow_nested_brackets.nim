import std/tables

##[
This testcase checks that nested bracket operators can be borrowed on distinct
seq/table/array types.
]##

type
  NestedArray {.borrow: `[]`.} = distinct array[2, float]
  NestedTable = distinct Table[int, NestedArray]
  NestedSeq {.borrow: `[]`.} = distinct seq[NestedTable]

proc `[]`*(t: NestedTable, key: int): lent NestedArray {.borrow.}
proc `[]`*(t: var NestedTable, key: int): var NestedArray {.borrow.}

block:
  var baseTable: Table[int, NestedArray]
  baseTable[123] = NestedArray([0.0, 0.0])
  var table = NestedTable(baseTable)

  var testObj = NestedSeq(@[table])

  testObj[0][123][1] = 1.23
  let element = testObj[0][123][1]
  doAssert element == 1.23
  let firstElement = testObj[0][123][0]
  doAssert firstElement == 0.0

  testObj[0][123][0] = 2.34
  doAssert testObj[0][123][0] == 2.34
