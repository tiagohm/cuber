import 'package:cuber/cuber.dart';
import 'package:cuber/src/other_tables/cornerMoveTable.dart';
import 'package:cuber/src/other_tables/edgeMoveTable.dart';
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

  static const _defaultCornerPositions = [
    Corner.upRightFront,
    Corner.upFrontLeft,
    Corner.upLeftBottom,
    Corner.upBottomRight,
    Corner.downFrontRight,
    Corner.downLeftFront,
    Corner.downBottomLeft,
    Corner.downRightBottom,
  ];

  static const _defaultEdgePositions = [
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
  ];

  const Cube._({
    List<Corner> cp = _defaultCornerPositions,
    List<int> co = const [0, 0, 0, 0, 0, 0, 0, 0],
    List<Edge> ep = _defaultEdgePositions,
    List<int> eo = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  })  : _cp = cp,
        _co = co,
        _ep = ep,
        _eo = eo;

  /// The solved [Cube].
  static const solved = Cube._();

  /// Returns `true` if the [Cube] is solved.
  bool get isSolved => this == solved;

  /// Creates a [Cube] from the your [definition] string U..R..F..D..L..B.
  factory Cube.from(String definition) {
    if (definition.length != 54) {
      throw ArgumentError('Invalid definition');
    }

    return Cube.of([
      for (var i = 0; i < definition.length; i++) Color.of(definition[i]),
    ]);
  }

  /// Creates a [Cube] from the your [definition] colors U..R..F..D..L..B.
  factory Cube.of(List<Color> definition) {
    if (definition.length != 54) {
      throw ArgumentError('Invalid definition');
    }

    definition = Rotation.correctOrientation(definition);

    final cp = List.filled(Corner.count, Corner.upRightFront);
    final co = List.filled(Corner.count, 0);
    final ep = List.filled(Edge.count, Edge.upRight);
    final eo = List.filled(Edge.count, 0);

    for (var i = 0; i < Corner.count; i++) {
      var ori = 0;
      // get the colors of the cube at corner i, starting with U/D
      for (; ori < 3; ori++) {
        if (definition[_cornerFacelet[i][ori].index] == Color.up ||
            definition[_cornerFacelet[i][ori].index] == Color.down) {
          break;
        }
      }

      final a = definition[_cornerFacelet[i][(ori + 1) % 3].index];
      final b = definition[_cornerFacelet[i][(ori + 2) % 3].index];

      for (var j = 0; j < Corner.count; j++) {
        if (a == _cornerColor[j][1] && b == _cornerColor[j][2]) {
          cp[i] = Corner.values[j];
          co[i] = ori % 3;
          break;
        }
      }
    }

    for (var i = 0; i < Edge.count; i++) {
      for (var j = 0; j < Edge.count; j++) {
        if (definition[_edgeFacelet[i][0].index] == _edgeColor[j][0] &&
            definition[_edgeFacelet[i][1].index] == _edgeColor[j][1]) {
          ep[i] = Edge.values[j];
          eo[i] = 0;
          break;
        }

        if (definition[_edgeFacelet[i][0].index] == _edgeColor[j][1] &&
            definition[_edgeFacelet[i][1].index] == _edgeColor[j][0]) {
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
    return Algorithm.scramble(n: n).apply(Cube.solved);
  }

  /// Creates a [Cube] instance from a [json] object.
  factory Cube.fromJson(json) {
    return Cube._(
      cp: [for (final item in json['cp']) Corner.values[item]],
      co: [for (final item in json['co']) item],
      ep: [for (final item in json['ep']) Edge.values[item]],
      eo: [for (final item in json['eo']) item],
    );
  }

  /// A [Cube] from a checkerboard-like pattern.
  static final checkerboard = Cube.from('UFUFUFUFURURURURURFRFRFRFRFDBDBDBDBDLDLDLDLDLBLBLBLBLB');

  /// A [Cube] from a wire-like pattern.
  static final wire = Cube.from('UUUUUUUUURLLRRRLLRBBFFFFFBBDDDDDDDDDLRRLLLRRLFFBBBBBFF');

  /// A [Cube] from a spiral-like pattern.
  static final spiral = Cube.from('FFFFUFFUURRUURUUUURRFRFFRRRBBBBDBDDBDDDDLDLLDLLLLBBLLB');

  /// A [Cube] from a stripe-like pattern.
  static final stripes = Cube.from('UUUUUUUUUBRFBRFBRFLFRLFRLFRDDDDDDDDDFLBFLBFLBRBLRBLRBL');

  /// A [Cube] from a cross-like pattern.
  static final crossOne = Cube.from('DUDUUUDUDFRFRRRFRFRFRFFFRFRUDUDDDUDUBLBLLLBLBLBLBBBLBL');

  /// A [Cube] from a cross-like pattern.
  static final crossTwo = Cube.from('RURUUURURFRFRRRFRFUFUFFFUFULDLDDDLDLBLBLLLBLBDBDBBBDBD');

  /// A [Cube] from a cube-in-cube-like pattern.
  static final cubeInCube = Cube.from('FFFFUUFUURRURRUUUURFFRFFRRRBBBDDBDDBDDDLLDLLDLLLLBBLBB');

  /// A [Cube] from a cube-in-cube-in-cube-like pattern.
  static final cubeInCubeInCube = Cube.from('RRRRUURUFURFRRFFFFUFRUFFUUULLLDDLBDLBBBLLBDLBDDDDBBDBL');

  /// A [Cube] from a anaconda-like pattern.
  static final anaconda = Cube.from('FUFUUFFFFUUUURRURURRRFFRRFRBDBBDDBBBDLDDLLDDDLBLBBLLLL');

  /// A [Cube] from a python-like pattern.
  static final python = Cube.from('DUDDUDDUDFFFFRRFRFRFRFFRRRRUUUDDDUUUBBBBLLBLBLBLBBLLLL');

  /// A [Cube] from a twister-like pattern.
  static final twister = Cube.from('RURRUURUURRFRRFFRFUFFFFFUUULLLDDDDDLBBBLLLLLBDBDDBBDBB');

  /// A [Cube] from a tetris-like pattern.
  static final tetris = Cube.from('FFBFUBFBBUDDURDUUDRLLRFLRRLBBFBDFBFFUDDULDUUDLRRLBRLLR');

  /// A [Cube] from a chicken-feet-like pattern.
  static final chickenFeet = Cube.from('RRRRURRRURFFFRFFFFUUFUFUUUULLLLDLDLLBBBBLBLBBDDDDBDDDB');

  /// A [Cube] from a four-spots pattern.
  static final fourSpots = Cube.from('UUUUUUUUULLLLRLLLLBBBBFBBBBDDDDDDDDDRRRRLRRRRFFFFBFFFF');

  /// A [Cube] from a six-spots pattern.
  static final sixSpots = Cube.from('FFFFUFFFFUUUURUUUURRRRFRRRRBBBBDBBBBDDDDLDDDDLLLLBLLLL');

  /// A [Cube] from a six-Ts pattern.
  static final sixTs = Cube.from('DDUUUUDDURLLRRRRLLFFFBFBBFBDUUDDDDUULRRLLLLRRFBFFBFBBB');

  /// Rubik's Cube World Record by Feliks Zemdegs on May 6th, 2018,
  /// at Cube for Cambodia 2018 (Melbourne, Australia) in 4.22 seconds.
  static final feliksZemdegs422 = Cube.from('FFUUUULRUBLFURFULBFURLFBBRBLDLLDDURRRFDDLFLBDRRDDBBDBF');

  /// Rubik's Cube World Record by Yusheng Du (杜宇生) on Nov 24th, 2018,
  /// at Wuhu Open 2018 (Wuhu, China) in 3.47 seconds.
  static final yushengDu347 = Cube.from('LRUUUBBRRDLFDRRFFBRFFFFLUULLRDBDDLURULUULLBDBRBFDBFDBD');

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

  /// Returns the [Cube] state as a json object.
  Map<String, dynamic> toJson() {
    return {
      'cp': [for (final item in _cp) item.index],
      'co': _co,
      'ep': [for (final item in _ep) item.index],
      'eo': _eo,
    };
  }

  ///
  Cube cornerMultiply(Cube b) {
    final cp = List.filled(Corner.count, Corner.upRightFront);
    final co = List.filled(Corner.count, 0);

    for (var corner = 0; corner < Corner.count; corner++) {
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
    final ep = List.filled(12, Edge.upRight);
    final eo = List.filled(12, 0);

    for (var edge = 0; edge < Edge.count; edge++) {
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
    final cpB = List.filled(Corner.count, Corner.upRightFront);
    final coA = List.of(_co);
    final coB = List.filled(Corner.count, 0);
    final epA = List.of(_ep);
    final epB = List.filled(Edge.count, Edge.upRight);
    final eoA = List.of(_eo);
    final eoB = List.filled(Edge.count, 0);

    for (var edge = 0; edge < Edge.count; edge++) {
      epB[epA[edge].index] = Edge.values[edge];
    }

    for (var edge = 0; edge < Edge.count; edge++) {
      eoB[edge] = eoA[epB[edge].index];
    }

    for (var corner = 0; corner < Corner.count; corner++) {
      cpB[cpA[corner].index] = Corner.values[corner];
    }

    for (var corner = 0; corner < Corner.count; corner++) {
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

  /// Returns the [Cube]'s [definition] string U..R..F..D..L..B.
  String get definition => colors.map((e) => e.letter).join();

  /// Returns the facelet colors.
  List<Color> get colors {
    final res = List.filled(54, Color.up);

    for (var i = 0; i < Corner.count; i++) {
      final k = _cp[i].index;
      final ori = _co[i];

      for (var n = 0; n < 3; n++) {
        res[_cornerFacelet[i][(n + ori) % 3].index] = _cornerColor[k][n];
      }
    }

    for (var i = 0; i < Edge.count; i++) {
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

    for (var i = Corner.upRightFront.index; i < Corner.downRightBottom.index; i++) {
      res = 3 * res + _co[i];
    }

    return res;
  }

  ///
  Cube twist(int value) {
    final co = List.of(_co);
    var twistParity = 0;

    for (var i = Corner.downRightBottom.index - 1; i >= Corner.upRightFront.index; i--) {
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

    for (var i = Corner.downRightBottom.index; i >= Corner.upRightFront.index + 1; i--) {
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
    final edge = List.filled(4, Edge.upRight);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 4) and the permutation array.
    for (var j = Edge.bottomRight.index; j >= Edge.upRight.index; j--) {
      if (Edge.frontRight.index <= _ep[j].index && _ep[j].index <= Edge.bottomRight.index) {
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
    final ep = List.filled(Edge.count, Edge.upRight);

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
    final corner = List.filled(6, Corner.upRightFront);
    var a = 0, x = 0, b = 0;

    // compute the index a < (8 choose 6) and the permutation array.
    for (var j = Corner.upRightFront.index; j <= Corner.downRightBottom.index; j++) {
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
    final cp = List.filled(Corner.count, Corner.downRightBottom);
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

    for (var j = Corner.upRightFront.index; j <= Corner.downRightBottom.index; j++) {
      if (cp[j] == Corner.downRightBottom) {
        cp[j] = otherCorner[x++];
      }
    }

    return Cube._(cp: cp, co: _co, ep: _ep, eo: _eo);
  }

  ///
  int computeUpRightToDownFront() {
    final edge = List.filled(6, Edge.upRight);
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
    final ep = List.filled(Edge.count, Edge.bottomRight);

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
    final edge = List.filled(3, Edge.upRight);
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
    final ep = List.filled(Edge.count, Edge.bottomRight);
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
    final edge = List.filled(3, Edge.upRight);
    var a = 0, x = 0, b = 0;

    // compute the index a < (12 choose 3) and the permutation array.
    for (var j = Edge.upRight.index; j <= Edge.bottomRight.index; j++) {
      if (Edge.upBottom.index <= _ep[j].index && _ep[j].index <= Edge.downFront.index) {
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
    final ep = List.filled(Edge.count, Edge.bottomRight);
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
    final ec = List<int>.filled(Edge.count, 0);
    final cc = List<int>.filled(Corner.count, 0);

    for (var e = 0; e < Edge.count; e++) {
      ec[_ep[e].index]++;
    }

    for (var i = 0; i < Edge.count; i++) {
      // missing edges
      if (ec[i] != 1) {
        return CubeStatus.missingEdge;
      }
    }

    var sum = 0;

    for (var i = 0; i < Edge.count; i++) {
      sum += _eo[i];
    }

    if (sum % 2 != 0) {
      return CubeStatus.twistedEdge;
    }

    for (var c = 0; c < Corner.count; c++) {
      cc[_cp[c].index]++;
    }

    for (var i = 0; i < Corner.count; i++) {
      if (cc[i] != 1) {
        return CubeStatus.missingCorner;
      }
    }

    sum = 0;

    for (var i = 0; i < Corner.count; i++) {
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

  /// Checks if [Cube]'s status is okay.
  bool get isOk => verify() == CubeStatus.ok;

  /// Checks if [Cube]'s status is not okay.
  bool get isNotOk => !isOk;

  /// Turns a face of the [Cube] applying a [move].
  Cube move(Move move) {
    final type = move.color.index * 3;
    final power = move.inverted
        ? 2
        : move.double
            ? 1
            : 0;
    return _move(type + power);
  }

  Cube _move(int move) {
    final type = move ~/ 3;
    final power = move % 3;

    var cube = this;

    for (var i = 0; i <= power; ++i) {
      final cp = List.filled(Corner.count, Corner.upRightFront);
      final co = List.filled(Corner.count, 0);
      final ep = List.filled(Edge.count, Edge.upRight);
      final eo = List.filled(Edge.count, 0);

      for (var k = 0; k < Corner.count; k++) {
        final m = cornerMoveTable[type][k];
        cp[k] = cube._cp[m[0]];
        co[k] = (m[1] + cube._co[m[0]]) % 3;
      }

      for (var k = 0; k < Edge.count; k++) {
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
    return solver.solveDeeply(this, timeout: timeout);
  }

  /// Returns the [Solution] for the [Cube] using the [solver] algorithm
  /// or `null` if the [timeout] is exceeded or there is no [Solution].
  ///
  /// Returns [Solution.empty] if the [Cube] is already [solved].
  Solution? solve({
    Solver solver = kociemba,
    int maxDepth = Solver.defaultMaxDepth,
    Duration timeout = Solver.defaultTimeout,
  }) {
    return solver.solve(this, maxDepth: maxDepth, timeout: timeout);
  }

  /// Generates an SVG image of the [Cube].
  String svg({
    int width = 1024,
    int height = 1024,
    Map<Color, String> colors = const <Color, String>{},
    List<Rotation> orientation = const [],
  }) {
    return _svg(
      this.colors,
      width: width,
      height: height,
      colors: colors,
      orientation: orientation,
    );
  }

  static const _defaultSVGColors = {
    Color.up: '#FFFF00',
    Color.right: '#FF9800',
    Color.front: '#4CAF50',
    Color.down: '#FFFFFF',
    Color.left: '#F44336',
    Color.bottom: '#3F51B5',
  };

  static String _svg(
    List<Color> cube, {
    int width = 1024,
    int height = 1024,
    Map<Color, String> colors = const <Color, String>{},
    List<Rotation> orientation = const [],
  }) {
    for (final rotation in orientation) {
      cube = Rotation.rotate(cube, rotation);
    }

    final sb = StringBuffer();

    sb.write(
      '<svg xmlns="http://www.w3.org/2000/svg" version="1.1"'
      ' width="$width" height="$height"'
      ' viewBox="-0.9 -0.9 1.8 1.8">',
    );
    sb.write('<g style="stroke-width:0.1;stroke-linejoin:round;opacity:1">');
    sb.write(
      '<polygon fill="#000000" stroke="#000000"'
      ' points="-4.84653508457E-17,-0.707127090835'
      ' 0.714632556057,-0.418930531644 6.65952705638E-17,-0.0229253960154'
      ' -0.714632556057,-0.418930531644" />',
    );
    sb.write(
      '<polygon fill="#000000" stroke="#000000"'
      ' points="6.65952705638E-17,-0.0229253960154'
      ' 0.714632556057,-0.418930531644 0.621255187784,0.36419102922'
      ' 5.65124685731E-17,0.82453746441" />',
    );
    sb.write(
      '<polygon fill="#000000" stroke="#000000"'
      ' points="-0.714632556057,-0.418930531644'
      ' 6.65952705638E-17,-0.0229253960154 5.65124685731E-17,0.82453746441'
      ' -0.621255187784,0.36419102922" />',
    );
    sb.write('</g>');

    sb.write(
      '<g style="opacity:1;stroke-opacity:0.5;stroke-width:0;'
      'stroke-linejoin:round">',
    );

    final facelets = <String>[];

    for (var i = 0; i < 3; i++) {
      for (var k = 0; k < 9; k++) {
        final color = cube[i * 9 + k];
        facelets.add(colors[color] ?? _defaultSVGColors[color]!);
      }
    }

    _polygons(facelets).forEach(sb.write);

    sb.write('</g>');
    sb.write('</svg>');

    return '$sb';
  }

  static List<String> _polygons(List<String> c) {
    return [
      '<polygon fill="${c[0]}" stroke="#000000" points="-4.87551797431E-17,-0.737698233548 0.194927184994,-0.659088123315 -1.69798662097E-17,-0.572632437735 -0.194927184994,-0.659088123315" />',
      '<polygon fill="${c[1]}" stroke="#000000" points="0.231132827495,-0.643722159841 0.445514455592,-0.557266474262 0.251609072518,-0.461728998466 0.036205642501,-0.557266474262" />',
      '<polygon fill="${c[2]}" stroke="#000000" points="0.485543858527,-0.540273655293 0.722445335488,-0.444736179497 0.530923413951,-0.338606583425 0.291638475453,-0.444736179497" />',
      '<polygon fill="${c[3]}" stroke="#000000" points="-0.231132827495,-0.643722159841 -0.036205642501,-0.557266474262 -0.251609072518,-0.461728998466 -0.445514455592,-0.557266474262" />',
      '<polygon fill="${c[4]}" stroke="#000000" points="-1.19318607633E-17,-0.540273655293 0.215403430017,-0.444736179497 1.3503554096E-17,-0.338606583425 -0.215403430017,-0.444736179497" />',
      '<polygon fill="${c[5]}" stroke="#000000" points="0.255646658169,-0.425842878909 0.494931596668,-0.319713282838 0.280929717193,-0.201126685309 0.0402432281522,-0.319713282838" />',
      '<polygon fill="${c[6]}" stroke="#000000" points="-0.485543858527,-0.540273655293 -0.291638475453,-0.444736179497 -0.530923413951,-0.338606583425 -0.722445335488,-0.444736179497" />',
      '<polygon fill="${c[7]}" stroke="#000000" points="-0.255646658169,-0.425842878909 -0.0402432281522,-0.319713282838 -0.280929717193,-0.201126685309 -0.494931596668,-0.319713282838" />',
      '<polygon fill="${c[8]}" stroke="#000000" points="1.98802186902E-17,-0.29858065171 0.240686489041,-0.179994054182 6.67136692317E-17,-0.0466204974798 -0.240686489041,-0.179994054182" />',
      '<polygon fill="${c[9]}" stroke="#000000" points="0.0201111765828,-0.011857046289 0.260797665624,-0.145230602991 0.248037844521,0.130168579642 0.0201111765828,0.272261733054" />',
      '<polygon fill="${c[10]}" stroke="#000000" points="0.300028166812,-0.168216269351 0.514030046287,-0.28680286688 0.491194203476,-0.0199477487617 0.28726834571,0.107182913282" />',
      '<polygon fill="${c[11]}" stroke="#000000" points="0.54910606962,-0.307361681575 0.740627991156,-0.413491277647 0.709796611771,-0.154919865813 0.526270226809,-0.0405065634573" />',
      '<polygon fill="${c[12]}" stroke="#000000" points="0.0190986741114,0.319184192481 0.247025342049,0.177091039068 0.235550314041,0.424760133224 0.0190986741114,0.573100884905" />',
      '<polygon fill="${c[13]}" stroke="#000000" points="0.284320264841,0.152776875121 0.488246122608,0.0256462130776 0.467594360539,0.266978597956 0.272845236833,0.400445969277" />',
      '<polygon fill="${c[14]}" stroke="#000000" points="0.521782650322,0.00377667342169 0.705309035284,-0.110636628934 0.677285677909,0.124384937577 0.501130888253,0.2451090583" />',
      '<polygon fill="${c[15]}" stroke="#000000" points="0.0181832343963,0.615263518691 0.234634874326,0.466922767011 0.224259890887,0.690849257498 0.0181832343963,0.843550846245" />',
      '<polygon fill="${c[16]}" stroke="#000000" points="0.270176847485,0.441649489407 0.464925971191,0.308182118085 0.446159253256,0.527486252065 0.259801864047,0.665575979894" />',
      '<polygon fill="${c[17]}" stroke="#000000" points="0.497051417024,0.285333873902 0.67320620668,0.164609753178 0.647623961491,0.379158611785 0.478284699089,0.504638007881" />',
      '<polygon fill="${c[18]}" stroke="#000000" points="-0.741333479677,-0.412760362386 -0.549811558141,-0.306630766315 -0.52697571533,-0.039775648197 -0.710502100292,-0.154188950552" />',
      '<polygon fill="${c[19]}" stroke="#000000" points="-0.514919107026,-0.286048978834 -0.300917227551,-0.167462381306 -0.288157406448,0.107936801328 -0.492083264215,-0.0191938607162" />',
      '<polygon fill="${c[20]}" stroke="#000000" points="-0.261923532191,-0.144461226811 -0.0212370431507,-0.0110876701087 -0.0212370431507,0.273031109235 -0.249163711089,0.130937955822" />',
      '<polygon fill="${c[21]}" stroke="#000000" points="-0.705959470164,-0.110079792019 -0.522433085202,0.0043335103365 -0.501781323133,0.245665895215 -0.677936112789,0.124941774492" />',
      '<polygon fill="${c[22]}" stroke="#000000" points="-0.489055834437,0.0262053344844 -0.28512997667,0.153335996528 -0.273654948662,0.401005090684 -0.468404072368,0.267537719363" />',
      '<polygon fill="${c[23]}" stroke="#000000" points="-0.248037844521,0.177642297739 -0.0201111765828,0.319735451152 -0.0201111765828,0.573652143575 -0.236562816513,0.425311391895" />',
      '<polygon fill="${c[24]}" stroke="#000000" points="-0.673807576732,0.1650293363 -0.497652787076,0.285753457023 -0.478886069141,0.505057591002 -0.648225331543,0.379578194906" />',
      '<polygon fill="${c[25]}" stroke="#000000" points="-0.465666418353,0.308589973071 -0.270917294647,0.442057344393 -0.260542311208,0.66598383488 -0.446899700418,0.527894107051" />',
      '<polygon fill="${c[26]}" stroke="#000000" points="-0.235550314041,0.467307546752 -0.0190986741114,0.615648298432 -0.0190986741114,0.843935625986 -0.225175330603,0.691234037239" />',
    ];
  }

  /// Returns the [Cube]'s pretty [definition].
  String get prettyDefinition {
    final d = definition;

    return '''
            |***********|
            |**${d[0]}**${d[1]}**${d[2]}**|
            |***********|
            |**${d[3]}**${d[4]}**${d[5]}**|
            |***********|
            |**${d[6]}**${d[7]}**${d[8]}**|
|***********|***********|***********|***********|
|**${d[36]}**${d[37]}**${d[38]}**|**${d[18]}**${d[19]}**${d[20]}**|**${d[9]}**${d[10]}**${d[11]}**|**${d[45]}**${d[46]}**${d[47]}**|
|***********|***********|***********|***********|
|**${d[39]}**${d[40]}**${d[41]}**|**${d[21]}**${d[22]}**${d[23]}**|**${d[12]}**${d[13]}**${d[14]}**|**${d[48]}**${d[49]}**${d[50]}**|
|***********|***********|***********|***********|
|**${d[42]}**${d[43]}**${d[44]}**|**${d[24]}**${d[25]}**${d[26]}**|**${d[15]}**${d[16]}**${d[17]}**|**${d[51]}**${d[52]}**${d[53]}**|
|***********|***********|***********|***********|
            |**${d[27]}**${d[28]}**${d[29]}**|
            |***********|
            |**${d[30]}**${d[31]}**${d[32]}**|
            |***********|
            |**${d[33]}**${d[34]}**${d[35]}**|
            |***********|
    ''';
  }

  @override
  List<Object> get props => [_cp, _co, _ep, _eo];
}
