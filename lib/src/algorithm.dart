import 'dart:collection';

import 'package:cuber/src/color.dart';
import 'package:cuber/src/cube.dart';
import 'package:cuber/src/move.dart';
import 'package:equatable/equatable.dart';

/// A [List] of [Move]s.
class Algorithm extends Equatable with ListMixin<Move> implements List<Move> {
  final List<Move> _moves;

  /// Creates an instance of [Algorithm] class.
  const Algorithm({
    List<Move> moves = const [],
  }) : _moves = moves;

  /// Creates an empty instance of [Algorithm] class.
  static const empty = Algorithm();

  /// Parses an [Algorithm] from [String].
  factory Algorithm.parse(String text) {
    const ignoreChars = ' ()[]';
    final moves = <Move>[];

    for (var i = 0; i < text.length; i++) {
      final c = text[i];

      if (ignoreChars.contains(c)) continue;

      if (i + 1 < text.length && (text[i + 1] == "'" || text[i + 1] == '2')) {
        moves.add(Move.parse(c + text[++i]));
      } else {
        moves.add(Move.parse(c));
      }
    }

    return Algorithm(moves: moves);
  }

  /// Generates an [Algorithm] with [n] random moves.
  factory Algorithm.scramble({
    int n = 20,
  }) {
    final moves = <Move>[];
    const colors = Color.values;

    var move = Move.random();
    moves.add(move);

    for (var i = 1; i < n; i++) {
      final a = move;

      do {
        move = Move.random();
      } while (move.color == a.color || move.color == colors[a.color.index]);

      moves.add(move);
    }

    return Algorithm(moves: moves);
  }

  /// Number of [Move]s.
  @override
  int get length => _moves.length;

  /// Returns the [Move] at the given [index].
  @override
  Move operator [](int index) => _moves[index];

  /// Aplies [n] times the [Algorithm] to [cube].
  Cube apply(
    Cube cube, {
    int n = 1,
    void Function(Cube cube, Move move, int step, int total)? onProgress,
  }) {
    for (var i = 0, c = 1; i < n; i++) {
      for (var k = 0; k < length; k++, c++) {
        final move = this[k];
        cube = cube.move(move);
        onProgress?.call(cube, move, c, length * n);
      }
    }

    return cube;
  }

  @override
  String toString() => _moves.join(' ');

  @override
  void operator []=(int index, Move value) {
    throw UnimplementedError('The algorithm is read-only');
  }

  @override
  set length(int newLength) =>
      throw UnimplementedError('The algorithm is read-only');

  /// The [Algorithm]'s moves.
  List<Move> get moves => List.unmodifiable(_moves);

  @override
  List<Object> get props => [_moves];
}
