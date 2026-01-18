##[
This testcase checks that nested bracket operators can be borrowed on distinct
seq/array types.
]##

type
  NestedArray {.borrow: `[]`.} = distinct array[2, float]
  NestedSeq {.borrow: `[]`.} = distinct seq[NestedArray]

block:
  var testObj = NestedSeq(@[NestedArray([0.0, 0.0])])

  testObj[0][1] = 1.23
  let element = testObj[0][1]
  doAssert element == 1.23
  let firstElement = testObj[0][0]
  doAssert firstElement == 0.0

  testObj[0][0] = 2.34
  doAssert testObj[0][0] == 2.34
