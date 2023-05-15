///  The names of the colors of the cube facelets.
enum Color {
  /// Up face color.
  up('U'),

  /// Right face color.
  right('R'),

  /// Front face color.
  front('F'),

  /// Down face color.
  down('D'),

  /// Left face color.
  left('L'),

  /// Bottom face color.
  bottom('B');

  /// The letter representing this color.
  final String letter;

  const Color(this.letter);

  /// Gets the [Color] from a representation [letter].
  static Color of(String letter) {
    switch (letter) {
      case 'U':
        return Color.up;
      case 'R':
        return Color.right;
      case 'F':
        return Color.front;
      case 'D':
        return Color.down;
      case 'L':
        return Color.left;
      case 'B':
        return Color.bottom;
    }

    throw ArgumentError('Invalid color letter: $letter');
  }
}
