import 'package:cuber/src/cube.dart';
import 'package:cuber/src/move.dart';
import 'package:equatable/equatable.dart';

/// Represents a list of [Move]s to solve the [Cube].
class Solution extends Equatable {
  /// The moves of the [Solution].
  final List<Move> moves;

  /// Elapsed time to find the [Solution].
  final Duration elapsedTime;

  /// Creates a [Solution] instance.
  const Solution({
    this.moves = const [],
    this.elapsedTime = const Duration(),
  });

  /// Empty solution.
  static const empty = Solution();

  /// The number of moves of the [Solution].
  int get length => moves?.length ?? 0;

  /// Returns true if there are no moves in the [Solution].
  bool get isEmpty => length == 0;

  /// Returns true if there is at least one move in the [Solution].
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return moves?.join(' ') ?? '';
  }

  @override
  List<Object> get props => [moves];
}
