##[
This testcase checks that bracket operators can be borrowed on distinct arrays.
]##

type
  Vec4 {.borrow: `[]`.} = distinct array[4, float32]

block:
  var v: Vec4
  v[0] = 1.5'f32
  doAssert v[0] == 1.5'f32
