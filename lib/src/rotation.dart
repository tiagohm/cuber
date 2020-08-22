import 'package:cuber/src/axis.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// The rotation move to rotate the entire cube [n] times on [axis].
class Rotation extends Equatable {
  /// The axis.
  final Axis axis;

  /// The number of times to rotate.
  final int n;

  /// Creates an instance of [Rotation] class.
  const Rotation({
    @required this.axis,
    int n = 1,
  })  : assert(axis != null),
        assert(n != null),
        n = (n >= 0 ? n : n >= -4 ? n + 4 : -n - 4) % 4;

  /// An instance of [Rotate] class that do not apply the rotation.
  static const none = Rotation(axis: Axis.x, n: 0);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.x].
  const Rotation.x([int n = 1]) : this(axis: Axis.x, n: n);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.y].
  const Rotation.y([int n = 1]) : this(axis: Axis.y, n: n);

  /// Creates an instance of [Rotation] class to rotate [n] times on [Axis.z].
  const Rotation.z([int n = 1]) : this(axis: Axis.x, n: n);

  @override
  String toString() {
    final name = axis == Axis.z ? 'Z' : axis == Axis.y ? 'Y' : 'X';
    return '$name$n';
  }

  @override
  List<Object> get props => [axis, n];
}
