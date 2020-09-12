import 'package:cuber/cuber.dart';
import 'package:test/test.dart';

void main() {
  test('parse', () {
    final moves = [for (var i = 0; i < 30; i++) Move.random()];
    expect(Algorithm.parse(moves.join(' ')).moves, moves);
    expect(Algorithm.parse(moves.join('')).moves, moves);
  });

  test('random', () {
    expect(Algorithm.scramble().apply(Cube.solved).isSolved, false);
  });

  test('apply', () {
    const algo = Algorithm(moves: [
      Move.front, Move.right, Move.up, //
      Move.rightInv, Move.upInv, Move.frontInv,
    ]);

    expect(algo.apply(Cube.solved, n: 6), Cube.solved);
  });
}
