import 'package:cuber/cuber.dart';

void main() async {
  const d = 'BLRRULDLRFDDBRFLFRFFUBFULRDBBFUDRFRBLDRULDUFUBBDDBLUUL';
  final cube = Cube.from(d);

  await for (final s in cube.solveDeeply()) {
    print('[${s.elapsedTime}]: (${s.length} moves) $s');
  }
}
