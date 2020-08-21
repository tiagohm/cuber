/// The names of the facelet positions of the cube.
/// ```
///             |************|
///             |*U1**U2**U3*|
///             |************|
///             |*U4**U5**U6*|
///             |************|
///             |*U7**U8**U9*|
/// ************|************|************|************|
/// *L1**L2**L3*|*F1**F2**F3*|*R1**R2**F3*|*B1**B2**B3*|
/// ************|************|************|************|
/// *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*|
/// ************|************|************|************|
/// *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*|
/// ************|************|************|************|
///             |*D1**D2**D3*|
///             |************|
///             |*D4**D5**D6*|
///             |************|
///             |*D7**D8**D9*|
///             |************|
/// ```
enum Facelet {
  /// Up facelet at position 1.
  u1,

  /// Up facelet at position 2.
  u2,

  /// Up facelet at position 3.
  u3,

  /// Up facelet at position 4.
  u4,

  /// Up facelet at position 5.
  u5,

  /// Up facelet at position 6.
  u6,

  /// Up facelet at position 7.
  u7,

  /// Up facelet at position 8.
  u8,

  /// Up facelet at position 9.
  u9,

  /// Right facelet at position 1.
  r1,

  /// Right facelet at position 2.
  r2,

  /// Right facelet at position 3.
  r3,

  /// Right facelet at position 4.
  r4,

  /// Right facelet at position 5.
  r5,

  /// Right facelet at position 6.
  r6,

  /// Right facelet at position 7.
  r7,

  /// Right facelet at position 8.
  r8,

  /// Right facelet at position 9.
  r9,

  /// Front facelet at position 1.
  f1,

  /// Front facelet at position 2.
  f2,

  /// Front facelet at position 3.
  f3,

  /// Front facelet at position 4.
  f4,

  /// Front facelet at position 5.
  f5,

  /// Front facelet at position 6.
  f6,

  /// Front facelet at position 7.
  f7,

  /// Front facelet at position 8.
  f8,

  /// Front facelet at position 9.
  f9,

  /// Down facelet at position 1.
  d1,

  /// Down facelet at position 2.
  d2,

  /// Down facelet at position 3.
  d3,

  /// Down facelet at position 4.
  d4,

  /// Down facelet at position 5.
  d5,

  /// Down facelet at position 6.
  d6,

  /// Down facelet at position 7.
  d7,

  /// Down facelet at position 8.
  d8,

  /// Down facelet at position 9.
  d9,

  /// Left facelet at position 1.
  l1,

  /// Left facelet at position 2.
  l2,

  /// Left facelet at position 3.
  l3,

  /// Left facelet at position 4.
  l4,

  /// Left facelet at position 5.
  l5,

  /// Left facelet at position 6.
  l6,

  /// Left facelet at position 7.
  l7,

  /// Left facelet at position 8.
  l8,

  /// Left facelet at position 9.
  l9,

  /// Bottom facelet at position 1.
  b1,

  /// Bottom facelet at position 2.
  b2,

  /// Bottom facelet at position 3.
  b3,

  /// Bottom facelet at position 4.
  b4,

  /// Bottom facelet at position 5.
  b5,

  /// Bottom facelet at position 6.
  b6,

  /// Bottom facelet at position 7.
  b7,

  /// Bottom facelet at position 8.
  b8,

  /// Bottom facelet at position 9.
  b9,
}
