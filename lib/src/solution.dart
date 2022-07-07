import 'package:cuber/src/algorithm.dart';
import 'package:cuber/src/cube.dart';
import 'package:cuber/src/move.dart';
import 'package:equatable/equatable.dart';

/// Represents a list of [Move]s to solve the [Cube].
class Solution extends Equatable {
  /// Creates a [Solution] instance.
  const Solution({
    this.algorithm = Algorithm.empty,
    this.elapsedTime = Duration.zero,
  });

  /// The moves of the [Solution].
  final Algorithm algorithm;

  /// Elapsed time to find the [Solution].
  final Duration elapsedTime;

  /// Empty solution.
  static const empty = Solution();

  /// The number of moves of the [Solution].
  int get length => algorithm.length;

  /// Returns true if there are no moves in the [Solution].
  bool get isEmpty => length == 0;

  /// Returns true if there is at least one move in the [Solution].
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => algorithm.toString();

  @override
  List<Object> get props => [algorithm];
}
