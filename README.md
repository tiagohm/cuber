# Cuber

This is a Dart implementation of Herbert Kociemba's two-phase algorithm for solving Rubik's Cube. This was inspired by C implementation of [muodov/kociemba](https://github.com/muodov/kociemba) and [tremwil/TwoPhaseSolver](https://github.com/tremwil/TwoPhaseSolver) projects.

## Installing

Add this to your package's pubspec.yaml file:

1. Depend on it

```yaml
dependencies:
  cuber: ^0.1.1
```

## Usage

```dart
import 'package:cuber/cuber.dart';

/// Create an instance of Cube class.
final cube0 = Cube.solved;
final cube1 = Cube.from('UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB');
final cube2 = Cube.of([Color.up, ...]);
// Scrambled.
final cube3 = Cube.scrambled();
// Predefined patterns.
final cube4 = Cube.checkerboard;
final cube5 = Cube.wire;
final cube6 = Cube.spiral;
final cube7 = Cube.stripes;
final cube8 = Cube.crossOne;
final cube9 = Cube.crossTwo;
final cube10 = Cube.fourSpots;
final cube11 = Cube.sixSpots;
final cube12 = Cube.sixTs;

// The cube is mounted correctly.
final isOk = cube0.verify() == CubeStatus.ok;
// The cube is solved.
final isSolved = cube1 == Cube.solved;

// Apply basic moves.
final cube13 = cube0.move(Move.front).move(Move.rightDouble).move(Move.upInv);

// Find solutions.
final solution0 = cube11.solve(maxDepth: 25, duration: Duration(minutes: 1));
print(solution0.moves);
// Stream<Solution>.
final solutions = cube11.solveDeeply(duration: Duration(minutes: 1));

// Solve patterns.
final cube14 = Cube.from('UUFLUFBULDLRURUUFBUBBFFLDBRFDBLDRDRRFDLBLDFBRURLFBRDDL');
final cube15 = Cube.from('RRRUUFRLBLDFRRDULLUBDBFUULLRUFFDFLLDBFBRLUURFDDDBBBFDB');
final cube16 = cube14.patternize(cube15); // From cube14 to cube15.
final solution1 = cube16.solve(maxDepth: 25, duration: Duration(minutes: 1));
```

## Cube string notation

```
             |************|
             |*U1**U2**U3*|
             |************|
             |*U4**U5**U6*|
             |************|
             |*U7**U8**U9*|
 ************|************|************|************
 *L1**L2**L3*|*F1**F2**F3*|*R1**R2**R3*|*B1**B2**B3*
 ************|************|************|************
 *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*
 ************|************|************|************
 *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*
 ************|************|************|************
             |*D1**D2**D3*|
             |************|
             |*D4**D5**D6*|
             |************|
             |*D7**D8**D9*|
             |************|
```

A cube definition string "UBL..." means that in position U1 we have the U-color, in position U2 we have the B-color, in position U3 we have the L color etc. according to the order `U1`, `U2`, `U3`, `U4`, `U5`, `U6`, `U7`, `U8`, `U9`, `R1`, `R2`, `R3`, `R4`, `R5`, `R6`, `R7`, `R8`, `R9`, `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `D1`, `D2`, `D3`, `D4`, `D5`, `D6`, `D7`, `D8`, `D9`, `L1`, `L2`, `L3`, `L4`, `L5`, `L6`, `L7`, `L8`, `L9`, `B1`, `B2`, `B3`, `B4`, `B5`, `B6`, `B7`, `B8`, `B9`.

So, for example, a definition of a solved cube would be `UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB`.

The solution consists of list of moves.
