/// The names of the corner positions of the cube.
enum Corner {
  /// Up-Right-Front corner.
  upRightFront,

  /// Up-Left-Front corner.
  upFrontLeft,

  /// Up-Lefy-Bottom corner.
  upLeftBottom,

  /// Up-Right-Bottom corner.
  upBottomRight,

  /// Down-Right-Front corner.
  downFrontRight,

  /// Down-Left-Front corner.
  downLeftFront,

  /// Down-Left-Bottom corner.
  downBottomLeft,

  /// Down-Right-Bottom corner.
  downRightBottom;

  /// Number of corners of the cube.
  static const count = 8;
}
