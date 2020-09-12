import 'dart:math';

import 'package:cuber/src/algorithm.dart';
import 'package:cuber/src/color.dart';
import 'package:equatable/equatable.dart';

/// Represents a move necessary to solve the cube
/// using Herbert Kociemba's two-phase algorithm.
class Move extends Equatable {
  /// The color of the cube face.
  final Color color;

  /// The direction of the move.
  final bool inverted;

  /// The double turn.
  final bool double;

  /// Creates a [Move] instance of a cube face [color],
  /// and if the turn is [inverted] or [double].
  const Move(
    this.color, {
    this.inverted = false,
    this.double = false,
  })  : assert(color != null),
        assert(!inverted || !double);

  /// Front clockwise move.
  static const front = Move(Color.front);

  /// Up clockwise move.
  static const up = Move(Color.up);

  /// Right clockwise move.
  static const right = Move(Color.right);

  /// Left clockwise move.
  static const left = Move(Color.left);

  /// Bottom clockwise move.
  static const bottom = Move(Color.bottom);

  /// Down clockwise move.
  static const down = Move(Color.down);

  /// Front counterclockwise move.
  static const frontInv = Move(Color.front, inverted: true);

  /// Up counterclockwise move.
  static const upInv = Move(Color.up, inverted: true);

  /// Right counterclockwise move.
  static const rightInv = Move(Color.right, inverted: true);

  /// Left counterclockwise move.
  static const leftInv = Move(Color.left, inverted: true);

  /// Bottom counterclockwise move.
  static const bottomInv = Move(Color.bottom, inverted: true);

  /// Down counterclockwise move.
  static const downInv = Move(Color.down, inverted: true);

  /// Front double turn move.
  static const frontDouble = Move(Color.front, double: true);

  /// Up double turn move.
  static const upDouble = Move(Color.up, double: true);

  /// Right double turn move.
  static const rightDouble = Move(Color.right, double: true);

  /// Left double turn move.
  static const leftDouble = Move(Color.left, double: true);

  /// Bottom double turn move.
  static const bottomDouble = Move(Color.bottom, double: true);

  /// Double double turn move.
  static const downDouble = Move(Color.down, double: true);

  /// The available moves.
  static const values = [
    up,
    right,
    front,
    down,
    left,
    bottom,
    upInv,
    rightInv,
    frontInv,
    downInv,
    leftInv,
    bottomInv,
    upDouble,
    rightDouble,
    frontDouble,
    downDouble,
    leftDouble,
    bottomDouble,
  ];

  /// Parses a [move] from [String].
  factory Move.parse(String move) {
    if (move == null || move.isEmpty || move.length > 2) {
      throw ArgumentError('Invalid move: $move');
    }

    final letter = move[0].toUpperCase();
    final inverted = move.length > 1 && move[1] == "'";
    final double = move.length > 1 && move[1] == '2';

    final color = colorFromString(letter);

    if (color != null) {
      return Move(color, inverted: inverted, double: double);
    } else {
      throw ArgumentError('Invalid move: $move');
    }
  }

  static final _random = Random();

  /// Generates a random [Move].
  factory Move.random() {
    final n = _random.nextInt(18);
    final color = n ~/ 3;
    final inverted = n % 3 == 2;
    final double = n % 3 == 1;

    return Move(
      Color.values[color],
      inverted: inverted,
      double: double,
    );
  }

  /// Inverts the [Move].
  Move inverse() {
    return double ? this : Move(color, double: false, inverted: !inverted);
  }

  @override
  String toString() {
    final a = stringFromColor(color);
    final b = inverted ? "'" : double ? '2' : '';
    return '$a$b';
  }

  @override
  List<Object> get props => [color, inverted, double];
}
