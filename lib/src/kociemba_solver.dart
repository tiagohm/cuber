import 'dart:math';

import 'package:cuber/src/algorithm.dart';
import 'package:cuber/src/move.dart';
import 'package:cuber/src/prune_tables/flipMoveTable.dart';
import 'package:cuber/src/prune_tables/frontRightToBottomRightMoveTable.dart';
import 'package:cuber/src/prune_tables/mergeUpRightToUpLeftAndUpBottomToDownFrontTable.dart';
import 'package:cuber/src/prune_tables/parityTable.dart';
import 'package:cuber/src/prune_tables/sliceFlipPrunTable.dart';
import 'package:cuber/src/prune_tables/sliceTwistPrunTable.dart';
import 'package:cuber/src/prune_tables/sliceUpRightFrontToDownLeftFrontParityPrunTable.dart';
import 'package:cuber/src/prune_tables/sliceUpRightToDownFrontParityPrunTable.dart';
import 'package:cuber/src/prune_tables/twistMoveTable.dart';
import 'package:cuber/src/prune_tables/upBottomToDownFrontMoveTable.dart';
import 'package:cuber/src/prune_tables/upRightFrontToDownLeftFrontMoveTable.dart';
import 'package:cuber/src/prune_tables/upRightToDownFrontMoveTable.dart';
import 'package:cuber/src/prune_tables/upRightToUpLeftMoveTable.dart';
import 'package:cuber/src/solution.dart';
import 'package:cuber/src/cube.dart';
import 'package:cuber/src/solver.dart';

class _Search {
  final ax = List.filled(31, 0);
  final po = List.filled(31, 0);
  final flip = List.filled(31, 0);
  final twist = List.filled(31, 0);
  final slice = List.filled(31, 0);
  final parity = List.filled(31, 0);
  final upRightFrontToDownLeftFront = List.filled(31, 0);
  final frontRightToBottomRight = List.filled(31, 0);
  final upRightToUpLeft = List.filled(31, 0);
  final upBottomToDownFront = List.filled(31, 0);
  final upRightToDownFront = List.filled(31, 0);
  final minDistPhaseOne = List.filled(31, 0);
  final minDistPhaseTwo = List.filled(31, 0);
}

/// Default implementation of [KociembaSolver] class.
const kociemba = KociembaSolver();

/// Herbert Kociemba's two-phase algorithm implementation.
class KociembaSolver extends Solver {
  /// Creates an instance of [KociembaSolver] class.
  const KociembaSolver();

  @override
  Solution? solve(
    Cube cube, {
    int maxDepth = Solver.defaultMaxDepth,
    Duration timeout = Solver.defaultTimeout,
  }) {
    if (cube.isNotOk) {
      return null;
    }

    if (cube.isSolved) {
      return Solution.empty;
    }

    final twist = cube.computeTwist();
    final flip = cube.computeFlip();
    final parity = cube.computeCornerParity();
    final frontRightToBottomRight = cube.computeFrontRightToBottomRight();
    final upRightFrontToDownLeftFront =
        cube.computeUpRightFrontToDownLeftFront();
    final upRightToUpLeft = cube.computeUpRightToUpLeft();
    final upBottomToDownFront = cube.computeUpBottomToDownFront();
    // final upRightToDownFront = cube.computeUpRightToDownFront();

    final search = _Search();
    search.po[0] = 0;
    search.ax[0] = 0;
    search.flip[0] = flip;
    search.twist[0] = twist;
    search.parity[0] = parity;
    search.slice[0] = frontRightToBottomRight ~/ 24;
    search.upRightFrontToDownLeftFront[0] = upRightFrontToDownLeftFront;
    search.frontRightToBottomRight[0] = frontRightToBottomRight;
    search.upRightToUpLeft[0] = upRightToUpLeft;
    search.upBottomToDownFront[0] = upBottomToDownFront;
    search.minDistPhaseOne[1] = 1; // else failure for depth=1, n=0

    var n = 0;
    var busy = false;
    var depthPhaseOne = 1;
    final sw = Stopwatch()..start();

    while (true) {
      do {
        if ((depthPhaseOne - n > search.minDistPhaseOne[n + 1]) && !busy) {
          // Initialize next move
          if (search.ax[n] == 0 || search.ax[n] == 3) {
            search.ax[++n] = 1;
          } else {
            search.ax[++n] = 0;
          }

          search.po[n] = 1;
        } else if (++search.po[n] > 3) {
          do {
            // increment axis
            if (++search.ax[n] > 5) {
              if (n == 0) {
                if (sw.elapsed > timeout) {
                  return null;
                }

                if (depthPhaseOne >= maxDepth) {
                  return null;
                } else {
                  depthPhaseOne++;
                  search.ax[n] = 0;
                  search.po[n] = 1;
                  busy = false;
                  break;
                }
              } else {
                n--;
                busy = true;
                break;
              }
            } else {
              search.po[n] = 1;
              busy = false;
            }
          } while (n != 0 &&
              (search.ax[n - 1] == search.ax[n] ||
                  search.ax[n - 1] - 3 == search.ax[n]));
        } else {
          busy = false;
        }
      } while (busy);

      // compute new coordinates and new minDistPhaseOne
      // if minDistPhaseOne = 0, the H subgroup is reached
      final mv = 3 * search.ax[n] + search.po[n] - 1;
      search.flip[n + 1] = flipMoveTable[search.flip[n]][mv];
      search.twist[n + 1] = twistMoveTable[search.twist[n]][mv];
      search.slice[n + 1] =
          frontRightToBottomRightMoveTable[search.slice[n] * 24][mv] ~/ 24;
      search.minDistPhaseOne[n + 1] = max(
        _prunning(
          sliceFlipPrunTable,
          495 * search.flip[n + 1] + search.slice[n + 1],
        ),
        _prunning(
          sliceTwistPrunTable,
          495 * search.twist[n + 1] + search.slice[n + 1],
        ),
      );

      // MODIFIED (Gera soluções iniciais diferentes):
      // if (search.minDistPhaseOne[n + 1] == 0 && n >= depthPhaseOne - 1) {
      // ORIGINAL:
      if (search.minDistPhaseOne[n + 1] == 0 && n >= depthPhaseOne - 5) {
        // instead of 10 any value > 5 is possible
        search.minDistPhaseOne[n + 1] = 10;
        int s;

        if (n == depthPhaseOne - 1 &&
            (s = _phaseTwo(search, depthPhaseOne, maxDepth)) >= 0) {
          if (s == depthPhaseOne ||
              (search.ax[depthPhaseOne - 1] != search.ax[depthPhaseOne] &&
                  search.ax[depthPhaseOne - 1] !=
                      search.ax[depthPhaseOne] + 3)) {
            final algorithm = _algorithm(search, s);
            return Solution(algorithm: algorithm, elapsedTime: sw.elapsed);
          }
        }
      }
    }
  }

  static int _phaseTwo(
    _Search search,
    int depthPhaseOne,
    int maxDepth,
  ) {
    // ORIGINAL:
    final maxDepthPhaseTwo = min(10, maxDepth - depthPhaseOne);
    // MODIFIED (Gera soluções iniciais diferentes):
    // final maxDepthPhaseTwo = min(12, maxDepth - depthPhaseOne);

    for (var i = 0; i < depthPhaseOne; i++) {
      final mv = 3 * search.ax[i] + search.po[i] - 1;
      search.upRightFrontToDownLeftFront[i + 1] =
          upRightFrontToDownLeftFrontMoveTable[
              search.upRightFrontToDownLeftFront[i]][mv];
      search.frontRightToBottomRight[i + 1] =
          frontRightToBottomRightMoveTable[search.frontRightToBottomRight[i]]
              [mv];
      search.parity[i + 1] = parityTable[search.parity[i]][mv];
    }

    final d1 = _prunning(
      sliceUpRightFrontToDownLeftFrontParityPrunTable,
      (24 * search.upRightFrontToDownLeftFront[depthPhaseOne] +
                  search.frontRightToBottomRight[depthPhaseOne]) *
              2 +
          search.parity[depthPhaseOne],
    );

    if (d1 > maxDepthPhaseTwo) return -1;

    for (var i = 0; i < depthPhaseOne; i++) {
      final mv = 3 * search.ax[i] + search.po[i] - 1;
      search.upRightToUpLeft[i + 1] =
          upRightToUpLeftMoveTable[search.upRightToUpLeft[i]][mv];
      search.upBottomToDownFront[i + 1] =
          upBottomToDownFrontMoveTable[search.upBottomToDownFront[i]][mv];
    }

    search.upRightToDownFront[depthPhaseOne] =
        mergeUpRightToUpLeftAndUpBottomToDownFrontTable[
                search.upRightToUpLeft[depthPhaseOne]]
            [search.upBottomToDownFront[depthPhaseOne]];

    final d2 = _prunning(
      sliceUpRightToDownFrontParityPrunTable,
      (24 * search.upRightToDownFront[depthPhaseOne] +
                  search.frontRightToBottomRight[depthPhaseOne]) *
              2 +
          search.parity[depthPhaseOne],
    );

    if (d2 > maxDepthPhaseTwo) return -1;

    search.minDistPhaseTwo[depthPhaseOne] = max(d1, d2);

    // already solved
    if (search.minDistPhaseTwo[depthPhaseOne] == 0) {
      return depthPhaseOne;
    }

    // now set up search

    var depthPhaseTwo = 1;
    var n = depthPhaseOne;
    var busy = false;

    search.po[depthPhaseOne] = 0;
    search.ax[depthPhaseOne] = 0;
    search.minDistPhaseTwo[n + 1] = 1;

    do {
      do {
        if ((depthPhaseOne + depthPhaseTwo - n >
                search.minDistPhaseTwo[n + 1]) &&
            !busy) {
          // Initialize next move
          if (search.ax[n] == 0 || search.ax[n] == 3) {
            search.ax[++n] = 1;
            search.po[n] = 2;
          } else {
            search.ax[++n] = 0;
            search.po[n] = 1;
          }
        } else if ((search.ax[n] == 0 || search.ax[n] == 3)
            ? (++search.po[n] > 3)
            : ((search.po[n] = search.po[n] + 2) > 3)) {
          // increment axis
          do {
            if (++search.ax[n] > 5) {
              if (n == depthPhaseOne) {
                if (depthPhaseTwo >= maxDepthPhaseTwo) {
                  return -1;
                } else {
                  depthPhaseTwo++;
                  search.ax[n] = 0;
                  search.po[n] = 1;
                  busy = false;
                  break;
                }
              } else {
                n--;
                busy = true;
                break;
              }
            } else {
              if (search.ax[n] == 0 || search.ax[n] == 3) {
                search.po[n] = 1;
              } else {
                search.po[n] = 2;
              }

              busy = false;
            }
          } while (n != depthPhaseOne &&
              (search.ax[n - 1] == search.ax[n] ||
                  search.ax[n - 1] - 3 == search.ax[n]));
        } else {
          busy = false;
        }
      } while (busy);

      final mv = 3 * search.ax[n] + search.po[n] - 1;

      search.upRightFrontToDownLeftFront[n + 1] =
          upRightFrontToDownLeftFrontMoveTable[
              search.upRightFrontToDownLeftFront[n]][mv];
      search.frontRightToBottomRight[n + 1] =
          frontRightToBottomRightMoveTable[search.frontRightToBottomRight[n]]
              [mv];
      search.parity[n + 1] = parityTable[search.parity[n]][mv];
      search.upRightToDownFront[n + 1] =
          upRightToDownFrontMoveTable[search.upRightToDownFront[n]][mv];

      search.minDistPhaseTwo[n + 1] = max(
        _prunning(
          sliceUpRightToDownFrontParityPrunTable,
          (24 * search.upRightToDownFront[n + 1] +
                      search.frontRightToBottomRight[n + 1]) *
                  2 +
              search.parity[n + 1],
        ),
        _prunning(
          sliceUpRightFrontToDownLeftFrontParityPrunTable,
          (24 * search.upRightFrontToDownLeftFront[n + 1] +
                      search.frontRightToBottomRight[n + 1]) *
                  2 +
              search.parity[n + 1],
        ),
      );
    } while (search.minDistPhaseTwo[n + 1] != 0);

    return depthPhaseOne + depthPhaseTwo;
  }

  static int _prunning(
    List<int> table,
    int index,
  ) {
    if ((index & 1) == 0) {
      return (table[index ~/ 2] & 0x0f);
    } else {
      return ((table[index ~/ 2] >> 4) & 0x0f);
    }
  }

  static const _moveTable = [
    [Move.up, Move.upDouble, Move.upInv],
    [Move.right, Move.rightDouble, Move.rightInv],
    [Move.front, Move.frontDouble, Move.frontInv],
    [Move.down, Move.downDouble, Move.downInv],
    [Move.left, Move.leftDouble, Move.leftInv],
    [Move.bottom, Move.bottomDouble, Move.bottomInv],
  ];

  static Algorithm _algorithm(
    _Search search,
    int length,
  ) {
    final moves = <Move>[];

    for (var i = 0; i < length; i++) {
      moves.add(_moveTable[search.ax[i]][search.po[i] - 1]);
    }

    return Algorithm(moves: moves);
  }
}
