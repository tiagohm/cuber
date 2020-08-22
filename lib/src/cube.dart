import 'package:cuber/cuber.dart';
import 'package:cuber/src/color.dart';
import 'package:cuber/src/corner.dart';
import 'package:cuber/src/edge.dart';
import 'package:cuber/src/facelet.dart';
import 'package:cuber/src/move.dart';
import 'package:cuber/src/other_tables/cornerMoveTable.dart';
import 'package:cuber/src/other_tables/edgeMoveTable.dart';
import 'package:cuber/src/solution.dart';
import 'package:equatable/equatable.dart';

const _cornerFacelet = [
  [Facelet.u9, Facelet.r1, Facelet.f3],
  [Facelet.u7, Facelet.f1, Facelet.l3],
  [Facelet.u1, Facelet.l1, Facelet.b3],
  [Facelet.u3, Facelet.b1, Facelet.r3],
  [Facelet.d3, Facelet.f9, Facelet.r7],
  [Facelet.d1, Facelet.l9, Facelet.f7],
  [Facelet.d7, Facelet.b9, Facelet.l7],
  [Facelet.d9, Facelet.r9, Facelet.b7],
];

const _cornerColor = [
  [Color.up, Color.right, Color.front],
  [Color.up, Color.front, Color.left],
  [Color.up, Color.left, Color.bottom],
  [Color.up, Color.bottom, Color.right],
  [Color.down, Color.front, Color.right],
  [Color.down, Color.left, Color.front],
  [Color.down, Color.bottom, Color.left],
  [Color.down, Color.right, Color.bottom],
];

const _edgeFacelet = [
  [Facelet.u6, Facelet.r2],
  [Facelet.u8, Facelet.f2],
  [Facelet.u4, Facelet.l2],
  [Facelet.u2, Facelet.b2],
  [Facelet.d6, Facelet.r8],
  [Facelet.d2, Facelet.f8],
  [Facelet.d4, Facelet.l8],
  [Facelet.d8, Facelet.b8],
  [Facelet.f6, Facelet.r4],
  [Facelet.f4, Facelet.l6],
  [Facelet.b6, Facelet.l4],
  [Facelet.b4, Facelet.r6],
];

const _edgeColor = [
  [Color.up, Color.right],
  [Color.up, Color.front],
  [Color.up, Color.left],
  [Color.up, Color.bottom],
  [Color.down, Color.right],
  [Color.down, Color.front],
  [Color.down, Color.left],
  [Color.down, Color.bottom],
  [Color.front, Color.right],
  [Color.front, Color.left],
  [Color.bottom, Color.left],
  [Color.bottom, Color.right],
];

const _rotation = [
  [null, 8, 0, 1, 6, 2],
  [6, null, 5, 8, 7, 3],
];

/// The [Cube]'s status.
enum CubeStatus {
  /// The cube is ok.
  ok,

  /// The cube has missing edges.
  missingEdge,

  /// The cube has twisted edge.
  twistedEdge,

  /// The cube has missing corners.
  missingCorner,

  /// The cube has twisted corner.
  twistedCorner,

  /// The cube has parity error.
  parityError,
}

/// The Rubik's [Cube].
class Cube extends Equatable {
  /// Corner permutation.
  final List<Corner> _cp;

  /// Corner orientation.
  final List<int> _co;

  /// Edge permutation.
  final List<Edge> _ep;

  /// Edge orientation.
  final List<int> _eo;

  const Cube._({
    List<Corner> cp,
    List<int> co,
    List<Edge> ep,
    List<int> eo,
  })  : _cp = cp ??
            const [
              Corner.upRightFront,
              Corner.upFrontLeft,
              Corner.upLeftBottom,
              Corner.upBottomRight,
              Corner.downFrontRight,
              Corner.downLeftFront,
              Corner.downBottomLeft,
              Corner.downRightBottom,
            ],
        _co = co ?? const [0, 0, 0, 0, 0, 0, 0, 0],
        _ep = ep ??
            const [
              Edge.upRight,
              Edge.upFront,
              Edge.upLeft,
              Edge.upBottom,
              Edge.downRight,
              Edge.downFront,
              Edge.downLeft,
              Edge.downBottom,
              Edge.frontRight,
              Edge.frontLeft,
              Edge.bottomLeft,
              Edge.bottomRight,
            ],
        _eo = eo ?? const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  /// The solved [Cube].
  static const solved = Cube._();

  /// Creates a [Cube] from the your [definition] string U..R..F..D..L..B.
  factory Cube.from(String definition) {
    if (definition == null || definition.length != 54) {
      throw ArgumentError('Invalid definition');
    }

    return Cube.of([
      for (var i = 0; i < definition.length; i++) colorFromString(definition[i])
    ]);
  }

  /// Creates a [Cube] from a list of [colors]
  /// representating your 54 facelets U..R..F..D..L..B.
  factory Cube.of(List<Color> colors) {
    if (colors == null || colors.length != 54) {
      throw ArgumentError('Invalid definition');
    }

    colors = _correctOrientation(colors);

    final cp = List.filled(cornerCount, Corner.upRightFront);
    final co = List.filled(cornerCount, 0);
    final ep = List.filled(edgeCount, Edge.upRight);
    final eo = List.filled(edgeCount, 0);

    for (var i = 0; i < cornerCount; i++) {
      var ori = 0;
      // get the colors of the cube at corner i, starting with U/D
      for (; ori < 3; ori++) {
        if (colors[_cornerFacelet[i][ori].index] == Color.up ||
            colors[_cornerFacelet[i][ori].index] == Color.down) {
          break;
        }
      }

      final a = colors[_cornerFacelet[i][(ori + 1) % 3].index];
      final b = colors[_cornerFacelet[i][(ori + 2) % 3].index];

      for (var j = 0; j < cornerCount; j++) {
        if (a == _cornerColor[j][1] && b == _cornerColor[j][2]) {
          cp[i] = Corner.values[j];
          co[i] = ori % 3;
          break;
        }
      }
    }

    for (var i = 0; i < edgeCount; i++) {
      for (var j = 0; j < edgeCount; j++) {
        if (colors[_edgeFacelet[i][0].index] == _edgeColor[j][0] &&
            colors[_edgeFacelet[i][1].index] == _edgeColor[j][1]) {
          ep[i] = Edge.values[j];
          eo[i] = 0;
          break;
        }

        if (colors[_edgeFacelet[i][0].index] == _edgeColor[j][1] &&
            colors[_edgeFacelet[i][1].index] == _edgeColor[j][0]) {
          ep[i] = Edge.values[j];
          eo[i] = 1;
          break;
        }
      }
    }

    return Cube._(cp: cp, co: co, ep: ep, eo: eo);
  }

  /// Creates a scrambled [Cube] after [n] random moves.
  factory Cube.scrambled({
    int n = 20,
  }) {
    var move = Move.random();
    var cube = Cube.solved.move(move);
    const colors = Color.values;

    for (var i = 1; i < n; i++) {
      final a = move;

      do {
        move = Move.random();
      } while (move.color == a.color || move.color == colors[a.color.index]);

      cube = cube.move(move);
    }

    return cube;
  }

  /// A [Cube] from a checkerboard-like pattern.
  static final checkerboard =
      Cube.from('UFUFUFUFURURURURURFRFRFRFRFDBDBDBDBDLDLDLDLDLBLBLBLBLB');

  /// A [Cube] from a wire-like pattern.
  static final wire =
      Cube.from('UUUUUUUUURLLRRRLLRBBFFFFFBBDDDDDDDDDLRRLLLRRLFFBBBBBFF');

  /// A [Cube] from a spiral-like pattern.
  static final spiral =
      Cube.from('FFFFUFFUURRUURUUUURRFRFFRRRBBBBDBDDBDDDDLDLLDLLLLBBLLB');

  /// A [Cube] from a stripe-like pattern.
  static final stripes =
      Cube.from('UUUUUUUUUBRFBRFBRFLFRLFRLFRDDDDDDDDDFLBFLBFLBRBLRBLRBL');

  /// A [Cube] from a cross-like pattern.
  static final crossOne =
      Cube.from('DUDUUUDUDFRFRRRFRFRFRFFFRFRUDUDDDUDUBLBLLLBLBLBLBBBLBL');

  /// A [Cube] from a cross-like pattern.
  static final crossTwo =
      Cube.from('RURUUURURFRFRRRFRFUFUFFFUFULDLDDDLDLBLBLLLBLBDBDBBBDBD');

  /// A [Cube] from a four-spots pattern.
  static final fourSpots =
      Cube.from('UUUUUUUUULLLLRLLLLBBBBFBBBBDDDDDDDDDRRRRLRRRRFFFFBFFFF');

  /// A [Cube] from a six-spots pattern.
  static final sixSpots =
      Cube.from('FFFFUFFFFUUUURUUUURRRRFRRRRBBBBDBBBBDDDDLDDDDLLLLBLLLL');

  /// A [Cube] from a six-Ts pattern.
  static final sixTs =
      Cube.from('DDUUUUDDURLLRRRRLLFFFBFBBFBDUUDDDDUULRRLLLLRRFBFFBFBBB');

  static int _cnk(
    int n,
    int k,
  ) {
    if (n < k) return 0;
    if (k > n / 2) k = n - k;

    var s = 1;

    for (var i = n, j = 1; i != n - k; i--, j++) {
      s *= i;
      s ~/= j;
    }

    return s;
  }

  static void _rotateLeft<T>(
    List<T> input,
    int left,
    int right,
  ) {
    final temp = input[left];

    for (var i = left; i < right; i++) {
      input[i] = input[i + 1];
    }

    input[right] = temp;
  }

  static void _rotateRight<T>(
    List<T> input,
    int left,
    int right,
  ) {
    final temp = input[right];

    for (var i = right; i > left; i--) {
      input[i] = input[i - 1];
    }

    input[left] = temp;
  }

  ///
  Cube cornerMultiply(Cube b) {
    final cp = List<Corner>(cornerCount);
    final co = List<int>(cornerCount);

    for (var corner = 0; corner < cornerCount; corner++) {
      cp[corner] = _cp[b._cp[corner].index];

      final oriA = _co[b._cp[corner].index];
      final oriB = b._co[corner];
      var ori = 0;

      // if both cubes are regular cubes...
      if (oriA < 3 && oriB < 3) {
        // just do an addition modulo 3 here.
        ori = oriA + oriB;
        // the composition is a regular cube.
        if (ori >= 3) {
          ori -= 3;
        }
      }
      // if cube b is a mirrored.
      else if (oriA < 3 && oriB >= 3) {
        ori = oriA + oriB;
        // the composition is a mirrored cube.
        if (ori >= 6) {
          ori -= 3;
        }
      }
      // if cube a is a mirrored.
      else if (oriA >= 3 && oriB < 3) {
        ori = oriA - oriB;
        // the composition is a mirrored cube.
        if (ori < 3) {
          ori += 3;
        }
      }
      // if both cubes are in mirrored.
      else if (oriA >= 3 && oriB >= 3) {
        ori = oriA - oriB;
        // the composition is a regular cube.
        if (ori < 0) {
          ori += 3;
        }
      }

      co[corner] = ori;
    }

    return Cube._(cp: cp, co: co, ep: _ep, eo: _eo);
  }

  ///
  Cube edgeMultiply(Cube b) {
    final ep = List<Edge>(12);
    final eo = List<int>(12);

    for (var edge = 0; edge < edgeCount; edge++) {
      ep[edge] = _ep[b._ep[edge].index];
      eo[edge] = (b._eo[edge] + _eo[b._ep[edge].index]) % 2;
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: eo);
  }

  ///
  Cube multiply(Cube b) {
    return cornerMultiply(b).edgeMultiply(b);
  }

  ///
  Cube inverse() {
    final cpA = List.of(_cp);
    final cpB = List<Corner>(cornerCount);
    final coA = List.of(_co);
    final coB = List<int>(cornerCount);
    final epA = List.of(_ep);
    final epB = List<Edge>(edgeCount);
    final eoA = List.of(_eo);
    final eoB = List<int>(edgeCount);

    for (var edge = 0; edge < edgeCount; edge++) {
      epB[epA[edge].index] = Edge.values[edge];
    }

    for (var edge = 0; edge < edgeCount; edge++) {
      eoB[edge] = eoA[epB[edge].index];
    }

    for (var corner = 0; corner < cornerCount; corner++) {
      cpB[cpA[corner].index] = Corner.values[corner];
    }

    for (var corner = 0; corner < cornerCount; corner++) {
      final ori = coA[cpB[corner].index];
      // Just for completeness. We do not invert mirrored.
      if (ori >= 3) {
        // cubes in the program.
        coB[corner] = ori;
      }
      // the standard case.
      else {
        coB[corner] = -ori;

        if (coB[corner] < 0) {
          coB[corner] += 3;
        }
      }
    }

    return Cube._(cp: cpB, co: coB, ep: epB, eo: eoB);
  }

  /// Returns the cube [definition] string U..R..F..D..L..B.
  String get definition => colors.map(stringFromColor).join();

  /// Returns the facelet colors.
  List<Color> get colors {
    final res = List<Color>(54);

    for (var i = 0; i < cornerCount; i++) {
      final k = _cp[i].index;
      final ori = _co[i];

      for (var n = 0; n < 3; n++) {
        res[_cornerFacelet[i][(n + ori) % 3].index] = _cornerColor[k][n];
      }
    }

    for (var i = 0; i < edgeCount; i++) {
      final k = _ep[i].index;
      final ori = _eo[i];

      for (var n = 0; n < 2; n++) {
        res[_edgeFacelet[i][(n + ori) % 2].index] = _edgeColor[k][n];
      }
    }

    // Center.
    for (var i = 0; i < 6; i++) {
      res[i * 9 + 4] = Color.values[i];
    }

    return res;
  }

  ///
  int computeTwist() {
    var res = 0;

    for (var i = Corner.upRightFront.index;
        i < Corner.downRightBottom.index;
        i++) {
      res = 3 * res + _co[i];
    }

    return res;
  }

  ///
  Cube twist(int value) {
    final co = List.of(_co);
    var twistParity = 0;

    for (var i = Corner.downRightBottom.index - 1;
        i >= Corner.upRightFront.index;
        i--) {
      co[i] = value % 3;
      twistParity += co[i];
      value ~/= 3;
    }

    co[Corner.downRightBottom.index] = (3 - twistParity % 3) % 3;

    return Cube._(cp: _cp, co: co, ep: _ep, eo: _eo);
  }

  ///
  int computeFlip() {
    var res = 0;

    for (var i = Edge.upRight.index; i < Edge.bottomRight.index; i++) {
      res = 2 * res + _eo[i];
    }

    return res;
  }

  ///
  Cube flip(int value) {
    final eo = List.of(_eo);
    var flipParity = 0;

    for (var i = Edge.bottomRight.index - 1; i >= Edge.upRight.index; i--) {
      eo[i] = value % 2;
      flipParity += eo[i];
      value ~/= 2;
    }

    eo[Edge.bottomRight.index] = (2 - flipParity % 2) % 2;

    return Cube._(cp: _cp, co: _co, ep: _ep, eo: eo);
  }

  ///
  int computeCornerParity() {
    var s = 0;

    for (var i = Corner.downRightBottom.index;
        i >= Corner.upRightFront.index + 1;
        i--) {
      for (var j = i - 1; j >= Corner.upRightFront.index; j--) {
        if (_cp[j].index > _cp[i].index) {
          s++;
        }
      }
    }

    return s % 2;
  }

  ///
  int computeEdgeParity() {
    var s = 0;

    for (var i = Edge.bottomRight.index; i >= Edge.upRight.index + 1; i--) {
      for (var j = i - 1; j >= Edge.upRight.index; j--) {
        if (_ep[j].index > _ep[i].index) {
          s++;
        }
      }
    }

    return s % 2;
  }

  ///
  int computeFrontRightToBottomRight() {
    final edge = List<Edge>(4);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 4) and the permutation array.
    for (var j = Edge.bottomRight.index; j >= Edge.upRight.index; j--) {
      if (Edge.frontRight.index <= _ep[j].index &&
          _ep[j].index <= Edge.bottomRight.index) {
        a += _cnk(11 - j, x + 1);
        edge[3 - x++] = _ep[j];
      }
    }

    // compute the index b < 4! for the permutation.
    for (var j = 3; j > 0; j--) {
      var k = 0;

      while (edge[j].index != j + 8) {
        _rotateLeft(edge, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return 24 * a + b;
  }

  ///
  Cube frontRightToBottomRight(int index) {
    final ep = List.filled(edgeCount, Edge.downBottom);

    final sliceEdge = [
      Edge.frontRight, Edge.frontLeft, //
      Edge.bottomLeft, Edge.bottomRight
    ];

    final otherEdge = [
      Edge.upRight, Edge.upFront, //
      Edge.upLeft, Edge.upBottom, //
      Edge.downRight, Edge.downFront, //
      Edge.downLeft, Edge.downBottom, //
    ];

    var b = index % 24; // Permutation
    var a = index ~/ 24; // Combination
    var k = 0;

    // generate permutation from index b
    for (var j = 1; j < 4; j++) {
      k = b % (j + 1);
      b ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(sliceEdge, 0, j);
      }
    }

    // generate combination and set slice edges
    var x = 3;

    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (a - _cnk(11 - j, x + 1) >= 0) {
        ep[j] = sliceEdge[3 - x];
        a -= _cnk(11 - j, x-- + 1);
      }
    }

    x = 0;

    // set the remaining edges UR..DB
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (ep[j] == Edge.downBottom) {
        ep[j] = otherEdge[x++];
      }
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: _eo);
  }

  ///
  int computeUpRightFrontToDownLeftFront() {
    final corner = List<Corner>(6);
    var a = 0, x = 0, b = 0;

    // compute the index a < (8 choose 6) and the permutation array.
    for (var j = Corner.upRightFront.index;
        j <= Corner.downRightBottom.index;
        j++) {
      if (_cp[j].index <= Corner.downLeftFront.index) {
        a += _cnk(j, x + 1);
        corner[x++] = _cp[j];
      }
    }

    // compute the index b < 6! for the permutation.
    for (var j = 5; j > 0; j--) {
      var k = 0;

      while (corner[j].index != j) {
        _rotateLeft(corner, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return 720 * a + b;
  }

  ///
  Cube upRightFrontToDownLeftFront(int index) {
    final cp = List.filled(cornerCount, Corner.downRightBottom);
    final corner = [
      Corner.upRightFront, Corner.upFrontLeft, //
      Corner.upLeftBottom, Corner.upBottomRight, //
      Corner.downFrontRight, Corner.downLeftFront, //
    ];
    final otherCorner = [
      Corner.downBottomLeft,
      Corner.downRightBottom,
    ];

    var b = index % 720; // Permutation
    var a = index ~/ 720; // Combination

    // generate permutation from index b
    for (var j = 1; j < 6; j++) {
      var k = b % (j + 1);
      b ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(corner, 0, j);
      }
    }

    var x = 5;

    // generate combination and set edges
    for (var j = Corner.downRightBottom.index; j >= 0; j--) {
      if (a - _cnk(j, x + 1) >= 0) {
        cp[j] = corner[x];
        a -= _cnk(j, x-- + 1);
      }
    }

    x = 0;

    for (var j = Corner.upRightFront.index;
        j <= Corner.downRightBottom.index;
        j++) {
      if (cp[j] == Corner.downRightBottom) {
        cp[j] = otherCorner[x++];
      }
    }

    return Cube._(cp: cp, co: _co, ep: _ep, eo: _eo);
  }

  ///
  int computeUpRightToDownFront() {
    final edge = List<Edge>(6);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 6) and the permutation array.
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (_ep[j].index <= Edge.downFront.index) {
        a += _cnk(j, x + 1);
        edge[x++] = _ep[j];
      }
    }

    // compute the index b < 6! for the permutation.
    for (var j = 5; j > 0; j--) {
      var k = 0;

      while (edge[j].index != j) {
        _rotateLeft(edge, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return 720 * a + b;
  }

  ///
  Cube upRightToDownFront(int index) {
    final ep = List.filled(edgeCount, Edge.bottomRight);

    final edge = [
      Edge.upRight, Edge.upFront, //
      Edge.upLeft, Edge.upBottom, //
      Edge.downRight, Edge.downFront, //
    ];

    final otherEdge = [
      Edge.downLeft, Edge.downBottom, //
      Edge.frontRight, Edge.frontLeft, //
      Edge.bottomLeft, Edge.bottomRight, //
    ];

    var b = index % 720; // Permutation
    var a = index ~/ 720; // Combination
    var k = 0;

    // generate permutation from index b
    for (var j = 1; j < 6; j++) {
      k = b % (j + 1);
      b ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(edge, 0, j);
      }
    }

    // generate combination and set slice edges
    var x = 5;

    for (var j = Edge.bottomRight.index; j >= 0; j--) {
      if (a - _cnk(j, x + 1) >= 0) {
        ep[j] = edge[x];
        a -= _cnk(j, x-- + 1);
      }
    }

    x = 0;

    // set the remaining edges UR..DB
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (ep[j] == Edge.bottomRight) {
        ep[j] = otherEdge[x++];
      }
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: _eo);
  }

  ///
  int computeUpRightToUpLeft() {
    final edge = List<Edge>(3);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 3) and the permutation array.
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (_ep[j].index <= Edge.upLeft.index) {
        a += _cnk(j, x + 1);
        edge[x++] = _ep[j];
      }
    }

    // compute the index b < 3! for the permutation.
    for (var j = 2; j > 0; j--) {
      var k = 0;

      while (edge[j].index != j) {
        _rotateLeft(edge, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return 6 * a + b;
  }

  ///
  Cube upRightToUpLeft(int index) {
    final ep = List.filled(edgeCount, Edge.bottomRight);
    final edge = [Edge.upRight, Edge.upFront, Edge.upLeft];

    var b = index % 6; // Permutation
    var a = index ~/ 6; // Combination

    // generate permutation from index b
    for (var j = 1; j < 3; j++) {
      var k = b % (j + 1);
      b ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(edge, 0, j);
      }
    }

    var x = 2;

    // generate combination and set edges
    for (var j = Edge.bottomRight.index; j >= 0; j--) {
      if (a - _cnk(j, x + 1) >= 0) {
        ep[j] = edge[x];
        a -= _cnk(j, x-- + 1);
      }
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: _eo);
  }

  ///
  int computeUpBottomToDownFront() {
    final edge = List<Edge>(3);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 3) and the permutation array.
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (Edge.upBottom.index <= _ep[j].index &&
          _ep[j].index <= Edge.downFront.index) {
        a += _cnk(j, x + 1);
        edge[x++] = _ep[j];
      }
    }

    // compute the index b < 3! for the permutation.
    for (var j = 2; j > 0; j--) {
      var k = 0;

      while (edge[j].index != j + Edge.upBottom.index) {
        _rotateLeft(edge, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return 6 * a + b;
  }

  ///
  Cube upBottomToDownFront(int index) {
    final ep = List.filled(edgeCount, Edge.bottomRight);
    final edge = [Edge.upBottom, Edge.downRight, Edge.downFront];

    var b = index % 6; // Permutation
    var a = index ~/ 6; // Combination

    // generate permutation from index b
    for (var j = 1; j < 3; j++) {
      var k = b % (j + 1);
      b ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(edge, 0, j);
      }
    }

    var x = 2;

    // generate combination and set edges
    for (var j = Edge.bottomRight.index; j >= 0; j--) {
      if (a - _cnk(j, x + 1) >= 0) {
        ep[j] = edge[x];
        a -= _cnk(j, x-- + 1);
      }
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: _eo);
  }

  ///
  int computeUpRightFrontToDownLeftBottom() {
    final perm = List.of(_cp);
    var b = 0;

    // compute the index b < 8! for the permutation
    for (var j = 7; j > 0; j--) {
      var k = 0;

      while (perm[j].index != j) {
        _rotateLeft(perm, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return b;
  }

  ///
  Cube upRightFrontToDownLeftBottom(int index) {
    final cp = List.of(_cp);
    final perm = List.of(Corner.values);

    for (var j = 1; j < 8; j++) {
      var k = index % (j + 1);
      index ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(perm, 0, j);
      }
    }

    var x = 7;

    for (var j = 7; j >= 0; j--) {
      cp[j] = perm[x--];
    }

    return Cube._(cp: cp, co: _co, ep: _ep, eo: _eo);
  }

  ///
  int computeUpRightToBottomRight() {
    final perm = List.of(_ep);
    var b = 0;

    // compute the index b < 12! for the permutation
    for (var j = 11; j > 0; j--) {
      var k = 0;

      while (perm[j].index != j) {
        _rotateLeft(perm, 0, j);
        k++;
      }

      b = (j + 1) * b + k;
    }

    return b;
  }

  ///
  Cube upRightToBottomRight(int index) {
    final ep = List.of(_ep);
    final perm = List.of(Edge.values);

    for (var j = 1; j < 12; j++) {
      var k = index % (j + 1);
      index ~/= j + 1;

      while (k-- > 0) {
        _rotateRight(perm, 0, j);
      }
    }

    var x = 11;

    for (var j = 11; j >= 0; j--) {
      ep[j] = perm[x--];
    }

    return Cube._(cp: _cp, co: _co, ep: ep, eo: _eo);
  }

  /// Verifies if the [Cube] has invalid facelet positions.
  CubeStatus verify() {
    final ec = List<int>.filled(edgeCount, 0);
    final cc = List<int>.filled(cornerCount, 0);

    for (var e = 0; e < edgeCount; e++) {
      ec[_ep[e].index]++;
    }

    for (var i = 0; i < edgeCount; i++) {
      // missing edges
      if (ec[i] != 1) {
        return CubeStatus.missingEdge;
      }
    }

    var sum = 0;

    for (var i = 0; i < edgeCount; i++) {
      sum += _eo[i];
    }

    if (sum % 2 != 0) {
      return CubeStatus.twistedEdge;
    }

    for (var c = 0; c < cornerCount; c++) {
      cc[_cp[c].index]++;
    }

    for (var i = 0; i < cornerCount; i++) {
      if (cc[i] != 1) {
        return CubeStatus.missingCorner;
      }
    }

    sum = 0;

    for (var i = 0; i < cornerCount; i++) {
      sum += _co[i];
    }

    if (sum % 3 != 0) {
      return CubeStatus.twistedCorner;
    }

    // parity error
    if ((computeEdgeParity() ^ computeCornerParity()) != 0) {
      return CubeStatus.parityError;
    }

    // cube ok
    return CubeStatus.ok;
  }

  /// Turns a face of the [Cube] applying a [move].
  Cube move(Move move) {
    final type = move.color.index * 3;
    final power = move.inverted ? 2 : move.double ? 1 : 0;
    return _move(type + power);
  }

  Cube _move(int move) {
    final type = move ~/ 3;
    final power = move % 3;

    var cube = this;

    for (var i = 0; i <= power; ++i) {
      final cp = List<Corner>(cornerCount);
      final co = List<int>(cornerCount);
      final ep = List<Edge>(edgeCount);
      final eo = List<int>(edgeCount);

      for (var k = 0; k < cornerCount; k++) {
        final m = cornerMoveTable[type][k];
        cp[k] = cube._cp[m[0]];
        co[k] = (m[1] + cube._co[m[0]]) % 3;
      }

      for (var k = 0; k < edgeCount; k++) {
        final m = edgeMoveTable[type][k];
        ep[k] = cube._ep[m[0]];
        eo[k] = (m[1] + cube._eo[m[0]]) % 2;
      }

      cube = Cube._(cp: cp, co: co, ep: ep, eo: eo);
    }

    return cube;
  }

  /// Returns the patternized [Cube]
  /// to solve the pattern from [this] cube to [to] cube.
  Cube patternize(Cube to) {
    return to.inverse().multiply(this);
  }

  /// Gets the [Solution]s as much as possible
  /// using the [solver] algorithm until the
  /// minimum number of moves is reached or the [timeout] is exceeded.
  Stream<Solution> solveDeeply({
    Solver solver = kociemba,
    Duration timeout = Solver.defaultTimeout,
  }) {
    return solver?.solveDeeply(this, timeout: timeout);
  }

  /// Returns the [Solution] for the [cube] using the [solver] algorithm
  /// or `null` if the [timeout] is exceeded or there is no [Solution].
  ///
  /// Returns [Solution.empty] if the [cube] is already [solved].
  Solution solve({
    Solver solver = kociemba,
    int maxDepth = Solver.defaultMaxDepth,
    Duration timeout = Solver.defaultTimeout,
  }) {
    return solver?.solve(this, maxDepth: maxDepth, timeout: timeout);
  }

  static List<Color> _correctOrientation(List<Color> input) {
    return _findRotation(input).fold(input, _applyRotation);
  }

  static List<Color> _applyRotation(
    List<Color> input,
    int rotation,
  ) {
    final type = rotation ~/ 3;
    final power = rotation % 3;

    for (var i = 0; i <= power; i++) {
      if (type == 0) {
        input = _rotateX(input);
      } else if (type == 1) {
        input = _rotateY(input);
      } else {
        input = _rotateZ(input);
      }
    }

    return input;
  }

  static List<int> _findRotation(List<Color> input) {
    return [
      for (var i = 4; i < 54; i += 9)
        if (input[i] == Color.up && _rotation[0][i ~/ 9] != null)
          _rotation[0][i ~/ 9]
        else if (input[i] == Color.right && _rotation[1][i ~/ 9] != null)
          _rotation[1][i ~/ 9]
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
  List<Object> get props => [_cp, _co, _ep, _eo];
}
