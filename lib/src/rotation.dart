import 'package:cuber/src/axis.dart';
import 'package:cuber/src/color.dart';
import 'package:cuber/src/cube.dart';
import 'package:equatable/equatable.dart';

const _orientation = [
  [
    null,
    Rotation.z(3),
    Rotation.x(),
    Rotation.x(2),
    Rotation.z(),
    Rotation.x(3),
  ],
  [
    Rotation.z(),
    null,
    Rotation.y(3),
    Rotation.z(3),
    Rotation.z(2),
    Rotation.y(1),
  ],
];

/// The rotation move to rotate the entire cube [n] times on [axis].
class Rotation extends Equatable {
  /// The axis.
  final Axis axis;

  /// The number of times to rotate.
  final int n;

  /// Creates an instance of [Rotation] class.
  const Rotation({
    required this.axis,
    int n = 1,
  })  : n = (n >= 0 ? n : n >= -4 ? n + 4 : -n - 4) % 4;

  /// An instance of [Rotate] class that do not apply the rotation.
  static const none = Rotation(axis: Axis.x, n: 0);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.x].
  const Rotation.x([int n = 1]) : this(axis: Axis.x, n: n);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.y].
  const Rotation.y([int n = 1]) : this(axis: Axis.y, n: n);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.z].
  const Rotation.z([int n = 1]) : this(axis: Axis.x, n: n);

  /// Invert the [Rotation].
  Rotation inverse() => Rotation(axis: axis, n: -n);

  /// Corrects the [Cube] orientation from
  /// the your [definition] colors U..R..F..D..L..B.
  static List<Color> correctOrientation(List<Color> definition) {
    return _findRotation(definition).fold(definition, rotate);
  }

  /// Applies the [rotation] to a [Cube] [definition] colors.
  static List<Color> rotate(
    List<Color> definition,
    Rotation rotation,
  ) {
    final axis = rotation.axis;
    final n = rotation.n;

    for (var i = 1; i <= n; i++) {
      if (axis == Axis.x) {
        definition = _rotateX(definition);
      } else if (axis == Axis.y) {
        definition = _rotateY(definition);
      } else {
        definition = _rotateZ(definition);
      }
    }

    return definition;
  }

  static List<Rotation> _findRotation(List<Color> input) {
    return [
      for (var i = 4, k = 0; i < 54; i += 9, k++)
        if (input[i] == Color.up && _orientation[0][k] != null)
          _orientation[0][k]!
        else if (input[i] == Color.right && _orientation[1][k] != null)
          _orientation[1][k]!
    ];
  }

  static void _rotateCW(List<Color> input) {
    final a = input[0];
    final b = input[1];
    input[0] = input[6];
    input[1] = input[3];
    input[6] = input[8];
    input[3] = input[7];
    input[8] = input[2];
    input[7] = input[5];
    input[2] = a;
    input[5] = b;
  }

  static void _rotateCCW(List<Color> input) {
    final a = input[0];
    final b = input[1];
    input[0] = input[2];
    input[1] = input[5];
    input[2] = input[8];
    input[5] = input[7];
    input[8] = input[6];
    input[7] = input[3];
    input[6] = a;
    input[3] = b;
  }

  static List<Color> _rotateX(List<Color> input) {
    final up = input.sublist(0, 9).reversed;
    final right = input.sublist(9, 18);
    final front = input.sublist(18, 27);
    final down = input.sublist(27, 36);
    final left = input.sublist(36, 45);
    final bottom = input.sublist(45, 54).reversed;

    _rotateCW(right);
    _rotateCCW(left);

    return [
      ...front,
      ...right,
      ...down,
      ...bottom,
      ...left,
      ...up,
    ];
  }

  static List<Color> _rotateY(List<Color> input) {
    final up = input.sublist(0, 9);
    final right = input.sublist(9, 18);
    final front = input.sublist(18, 27);
    final down = input.sublist(27, 36);
    final left = input.sublist(36, 45);
    final bottom = input.sublist(45, 54);

    _rotateCW(up);
    _rotateCCW(down);

    return [
      ...up,
      ...bottom,
      ...right,
      ...down,
      ...front,
      ...left,
    ];
  }

  static List<Color> _rotateZ(List<Color> input) {
    final up = input.sublist(0, 9);
    final right = input.sublist(9, 18);
    final front = input.sublist(18, 27);
    final down = input.sublist(27, 36);
    final left = input.sublist(36, 45);
    final bottom = input.sublist(45, 54);

    _rotateCW(front);
    _rotateCCW(bottom);
    _rotateCW(up);
    _rotateCW(right);
    _rotateCW(down);
    _rotateCW(left);

    return [
      ...left,
      ...up,
      ...front,
      ...right,
      ...down,
      ...bottom,
    ];
  }

  @override
  String toString() {
    final name = axis == Axis.z ? 'Z' : axis == Axis.y ? 'Y' : 'X';
    return '$name$n';
  }

  @override
  List<Object> get props => [axis, n];
}
