import 'dart:isolate';

import 'package:cuber/src/cube.dart';
import 'package:cuber/src/solution.dart';

/// Represents a [Cube] solver algorithm.
abstract class Solver {
  ///
  const Solver();

  /// Returns the [Solution] for the [cube] with a maximum of
  /// [maxDepth] moves
  /// or `null` if the [timeout] is exceeded or there is no [Solution].
  ///
  /// Returns [Solution.empty] if the [cube] is already solved.
  Solution solve(
    Cube cube, {
    int maxDepth = 25,
    Duration timeout = const Duration(seconds: 30),
  });

  /// Gets the [Solution]s as much as possible until the
  /// minimum number of moves is reached or the [timeout] is exceeded.
  Stream<Solution> solveDeeply(
    Cube cube, {
    Duration timeout = const Duration(seconds: 30),
  }) async* {
    final receiver = ReceivePort();

    await Isolate.spawn(_solveDeeply, [
      receiver.sendPort,
      cube,
      timeout.inMilliseconds,
      this,
    ]);

    await for (final data in receiver) {
      if (data is Solution) {
        yield data;
      } else {
        break;
      }
    }
  }
}

void _solveDeeply(List data) {
  final sender = data[0] as SendPort;
  final cube = data[1] as Cube;
  final timeout = data[2] as int;
  final solver = data[3] as Solver;

  var maxDepth = 25;
  final solutions = <Solution>{};
  final sw = Stopwatch()..start();

  while (sw.elapsedMilliseconds < timeout) {
    final s = solver.solve(
      cube,
      maxDepth: maxDepth,
      timeout: Duration(milliseconds: timeout - sw.elapsedMilliseconds),
    );

    if (maxDepth > 0 && s != null && s.isNotEmpty) {
      if (!solutions.contains(s)) {
        solutions.add(s);
        sender.send(s);
        maxDepth = s.length - 1;
        print('$s');
      } else {
        maxDepth--;
      }
    } else {
      break;
    }
  }

  sender.send(null);
}
