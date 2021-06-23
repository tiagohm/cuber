import 'dart:io';

import 'package:cuber/cuber.dart';
import 'package:test/test.dart';

void main() {
  test('solved cube instance is ok', () {
    const cube = Cube.solved;
    expect(cube.computeCornerParity(), 0);
    expect(cube.computeEdgeParity(), 0);
    expect(cube.computeFlip(), 0);
    expect(cube.computeTwist(), 0);
    expect(cube.computeFrontRightToBottomRight(), 0);
    expect(cube.computeUpRightFrontToDownLeftBottom(), 0);
    expect(cube.computeUpRightToDownFront(), 0);
    expect(cube.computeUpRightToUpLeft(), 0);
    expect(cube.computeUpBottomToDownFront(), 114);
    expect(cube.computeUpRightFrontToDownLeftFront(), 0);
    expect(cube.computeUpRightToBottomRight(), 0);
    expect(cube.isOk, true);
    expect(cube.definition,
        'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB');
  });

  test('parse solved cube input is equals to solved cube', () {
    const input = 'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB';
    final cube = Cube.from(input);
    expect(cube.isSolved, true);
    expect(cube.isOk, true);
    print(cube.prettyDefinition);
  });

  test('parse random cube input is not equals to solved cube', () {
    const input = 'DRLUUBFBRBLURRLRUBLRDDFDLFUFUFFDBRDUBRUFLLFDDBFLUBLRBD';
    final cube = Cube.from(input);
    expect(cube.isSolved, false);
    expect(cube.isOk, true);
    print(cube.prettyDefinition);
  });

  test('solved cube solution is empty', () {
    final s = Cube.solved.solve();
    expect(s, isEmpty);
  });

  test('valid random cube solutions', () {
    expectSolution(
      'UUUUUUUUUFFFRRRRRRLLLFFFFFFDDDDDDDDDBBBLLLLLLRRRBBBBBB',
      'U',
    );
    expectSolution(
      'BBURUDBFUFFFRRFUUFLULUFUDLRRDBBDBDBLUDDFLLRRBRLLLBRDDF',
      "B U' L' D' R' D' L2 D' L F' L' D F2 R2 U R2 B2 U2 L2 F2 D'",
    );
    expectSolution(
      'FDLUUURLFLBDFRRDLBBBUBFLDDLFBBUDUBRLURDFLRUFRFLRFBDUDR',
      "U F' L2 U F' L2 F L2 F2 D L' F' U2 B2 D F2 D' R2 L2 D F2 U'",
    );
    expectSolution(
      'UDRFULDRBLDUBRDUFBFBDRFDFURLBBLDRDURLLRULUFBUFRBFBFDLL',
      "F U2 D2 L' F2 D' B R L2 U F U F2 D2 B2 D R2 U2 F2 L2 B2",
    );
    expectSolution(
      'LRLLURRLBDUULRFUFLFDRUFBRBLDUFDDRRBDDFURLLBFFBDBUBBFDU',
      "B2 D' R2 F U R F' D2 L' B D F2 R2 L2 U' B2 D2 B2 U B2",
    );
    expectSolution(
      'UUULULFLFDUBDRRDBBUFLFFLBRRLDFFDDBUUFBRRLDRUDLBLFBBRRD',
      "U2 F' D F U F' U F2 R' F R' D2 R2 F2 U2 D B2 U2 L2 F2",
    );
    expectSolution(
      'LRRFUUBDLFBBLRDLLRUFDLFURLFBBUBDDDDUDULRLFRRDUUBRBFFBF',
      "R' B' D' R' B' L F2 U' D F' R2 L2 U' R2 F2 U R2 U B2 D'",
    );
    expectSolution(
      'FBRDULFBRFBBRRRDLBRRUDFUUDFLBLFDUBFDLLDLLFRRBUUUDBFLUD',
      "U F R' D' R' U2 L D B' R L' U' B2 L2 U2 D2 B2 R2 D L2 B2",
    );
    expectSolution(
      'FLBUULFFLFDURRDBUBUUDDFFBRDDBLRDRFLLRLRULFUDRRBDBBBUFL',
      "U2 D B' U2 R' D2 L2 D R2 L B' U' L2 D L2 D F2 L2 B2 U'",
    );
    expectSolution(
      'UBLLURBDLDDFRRLRFLDFBLFURFFFLDBDULBUBDRRLBDDUUURUBFBRF',
      "U' R2 F U2 R' L' F' L U D' R' U' R2 B2 L2 B2 L2 U2 R2 D' F2",
    );
    expectSolution(
      'UDLFUBLRFRDDLRFDBDBBDDFUUUBFRRLDUFFLBLUFLRRBLFLRUBDBRU',
      "U R' L F L' U' F' D R F' L' B2 U L2 B2 D L2 U2 R2 B2 D",
    );
    expectSolution(
      'URBLUBDDBURDLRDLDBFBLLFFULDBBFUDFLRRRURBLDFFRLUFRBUDFU',
      "U2 R2 F' R B' D2 B L' B U' R2 B L2 F2 U2 F2 U' R2 D' L2 D R2",
    );
    expectSolution(
      'BLBDUULUDBLRDRFLBUUBLRFFURDLDFRDRRUFRBFLLUFFBDDULBBRFD',
      "U2 D2 B' D' F B L2 F2 L D2 L' U F2 U L2 D L2 U2 L2 D F2",
    );
    expectSolution(
      'ULFUUURRURLLLRRUBLDFFLFFBDRURBRDDDFBFBFFLDBBLDBLUBDDUR',
      "U2 B2 L2 B' D R U2 B2 L' U D2 F' U F2 L2 U2 D' R2 F2 U2 D' F2",
    );
    expectSolution(
      'LUFBUUUDDLLRDRRDDLBFFFFRUDBLLRRDBRBFDURFLRFUBUFBBBLULD',
      "D' L B2 U' F' B U B' R2 D2 R' B2 L2 U R2 U B2 R2 U' F2 D2",
    );
    expectSolution(
      'UDDBURDDBUFLFRLFDFRRLRFLUBRFDUBDFRFLBLBRLUFULBLRUBBDUD',
      "U2 B' U' B' R' F2 U' L' F' D B U F2 D2 F2 D F2 R2 U2 F2 D'",
    );
    expectSolution(
      'UUBUUBUDBDRLFRFDUDBBRBFRFBRUUFDDLLDFFRRDLLBRRUFLLBFLLD',
      "U2 R' B2 U' F2 D B R F2 R U2 B2 U2 R2 U' F2 U2 R2 D'",
    );
    expectSolution(
      'BDLRULLRRDFFBRLDRLBFFFFUUDBBRRLDURDDLBULLUUBRUBDUBDFFF',
      "F2 D' L2 U B' D B L F' B U' L2 D2 L2 B2 U R2 F2 U F2",
    );
    expectSolution(
      'LFRUULBBDBFBDRBLFRDDLLFLFRDRBFDDUBUUURRFLBLRDURFUBDFLU',
      "R' D' F' R U' L2 D2 R D L' D' F2 D' R2 U' R2 F2 B2 L2 U2",
    );
    expectSolution(
      'UBBRUDBLFRBRRRUFBBLFDDFFFULUFDDDLBLUFUDBLRLFRDULLBRRDU',
      "R' U B R U' R D' R2 L' F' R' F2 R2 U L2 D' B2 U2 L2 D'",
    );
    expectSolution(
      'FRRUUFURDBLFRRFFLUBDLRFBLFUFULLDDBBBULRDLURBDDFRDBBLUD',
      "U R2 U F R' B' R F2 D F' L' D' R2 D B2 D' L2 B2 D R2 L2",
    );
    expectSolution(
      'ULDFUBBRRBDLFRBFFLUUDBFLRFDUDRLDUFUDRRLDLUUDBBBFRBRFLL',
      "F' B' L' U D B U2 F' B' D2 R' B2 U L2 D' F2 R2 D2 R2 U R2",
    );
    expectSolution(
      'ULLLURFBBDUBBRUBLFURRDFDRFUDRRFDBUULLURRLLLDFDFBBBDDFF',
      "U' F2 D2 B2 R2 U B R B U L' B' U B2 D B2 R2 D L2 U D2",
    );
    expectSolution(
      'BDBDURFFRDFDRRLUBLLLFBFURFBBULDDURLDRFURLRUBDLLUUBDFBF',
      "U2 B2 U' F' D' R2 U F2 D' L' B R2 B2 U' B2 U' B2 D' B2 R2 U'",
    );
    expectSolution(
      'DRUUUDDBRULLBRBFFLLLBFFDBURLFUUDLRRURRFFLDFLDFDBUBRBBD',
      "D F R L B2 L' B U F' D' R U B2 U F2 U B2 U2 F2 U' L2",
    );
    expectSolution(
      'BDLLURUFRDBDRRRDFURLFLFUBFLRDBLDUBBLDDFFLBLUUFBRDBRFUU',
      "L' D R' U' B D F D F2 B' R B2 U' L2 U' F2 U D F2 R2 D2",
    );
    expectSolution(
      'RRRUURUUBDDBFRBFLURLRFFRLULDBDLDBLLLDFFULDUDBUBFDBRFFB',
      "U D2 R' F' R' U' B R' U' L F2 B2 U2 B2 D' F2 D R2 F2 D2",
    );
    expectSolution(
      'LFRLUUBBLBFUDRRUUFDDUDFFULLBUFLDBLFDFDRBLRBBRFRDUBRRLD',
      "F2 R U' F D2 B D B' L U2 R U F2 U2 R2 U2 R2 U' B2 D'",
    );
    expectSolution(
      'FRRBUBDDURLBDRDLUDRLFLFBLBFDUUFDRLUFRRBRLFUUBUDDFBFLLB',
      "U2 D F' B' R' D' L B' R B R L2 D2 L2 F2 U B2 R2 B2 D2 F2",
    );
    expectSolution(
      'DBUFUFDFUBLLLRURUBLRRDFBFLDUUBFDRDDLFUFBLLLDRFDRBBRURB',
      "F' B' U' B2 D' F L U' B R' D2 L2 U2 F2 D B2 U' F2 U2 L2",
    );
    expectSolution(
      'BFRFUBBLBLRFDRBDUUUBDFFRLFFULLDDRFDRDULLLRRLFDDRUBUBBU',
      "L F2 R F' U2 R F' L F R U F2 D2 R2 U R2 L2 B2 D2 F2",
    );
    expectSolution(
      'BFDDURFBRDBLURLBUUDLFRFBDRURURLDLFFFUBLFLDUFBBRLDBDRUL',
      "L2 U R2 B L' F L' F' R' L F R2 U2 R2 U F2 U F2 D R2 D2",
    );
    expectSolution(
      'LRBUULRDRDBLLRBDDUFRFDFURLLBFBUDBBFLFBUDLFURDUFDRBLFUR',
      "R' B' D' R2 L B' L D L' B' U2 L2 D2 R2 B2 U' L2 D' F2 B2",
    );
    expectSolution(
      'RBBDUBBRRFLDFRFFRRDUUFFUDFULLLLDBBLBDBRDLRLUFLUFDBRUDU',
      "U2 F2 U' D2 F U' R B' U L F B2 U D B2 R2 U2 B2 D' F2",
    );
    expectSolution(
      'FRBUURUDBLBRDRLDFDRBDDFLUFFLULDDLBLRLBFFLRUFBDUUUBRFBR',
      "D B' U' D' F' U2 F' R F D2 F B2 U D2 F2 R2 D2 L2 F2 D' B2",
    );
    expectSolution(
      'FLURURDBRBDBBRUUUUFLDFFULUFFLRDDRLBRLFRFLLBBDLDUFBDBRD',
      "F' U' F2 D2 F2 L' B' R2 U' R F U B2 D L2 D' F2 R2 D L2 U2",
    );
    expectSolution(
      'BULRUULFRDBDDRLUDRULFFFBLUBDRLFDLURBDBFLLDFRBFFRUBBUDR',
      "U' F2 R' D2 L2 U2 F' B' R' F' B2 U2 D L2 F2 L2 D' F2 U2 F2",
    );
    expectSolution(
      'FFRRULFBDRFBURLFBUDLBRFFDBRBUUDDDLRLRULRLDULLUDDUBFFBB',
      "U F D' B' U D' F L2 U R F' R2 F2 U' R2 F2 D' R2 U D' B2",
    );
    expectSolution(
      'DUFBUDBRDBRUFRURRBDFLLFDDLBLFULDURBLFDRDLBUUFLBRFBLURF',
      "U L2 B D' L' U B' R2 L2 D' R F2 B2 R2 U2 B2 U' D2 F2 B2 R2",
    );
    expectSolution(
      'DRRUURBRURUBDRLUBFDBFBFBLFLDRFFDULLDLFRDLLUDBUDFUBLRFB',
      "F2 B D2 R B' U2 B2 D2 F' L B2 R2 F2 L2 U' L2 U' R2 B2 U",
    );
    expectSolution(
      'BRLFUDLDRFLUFRUFFLFBURFRUUDFBRUDDRRBRLDLLBDLLBUUFBBDDB',
      "F2 D L F' B' L' F2 D F' U' R U F2 L2 F2 L2 F2 U2 L2 U' R2",
    );
    expectSolution(
      'UULFUFDLRFDBBRDBLFLFULFUDDURBRRDDURDFUFLLBBFBDRLRBURBL',
      "F' R U B2 D B U2 R' L' F' L' D' F2 R2 U F2 L2 U2 B2 U B2",
    );
    expectSolution(
      'DUDUUUDBUFRFRRBRDUBLLUFDUBFBDDFDLUFFRBLFLFBRRLLBRBDRLL',
      "B2 L U B' R' F2 B D2 R2 U2 R' U' R2 D' R2 D' R2 U B2 U' R2",
    );
    expectSolution(
      'LDRLUDRLFURBRRRRDDBBRFFUUBFLUDUDLLBFUFDFLUBLBUBFFBDLRD',
      "D F2 R' L2 D' B2 R' D' L B U' F2 R2 B2 R2 F2 U B2 U D",
    );
    expectSolution(
      'FUBUUFLBLURRDRFFUDDUFBFRUBDBLRRDLBFFURBLLDLBRDFRLBDLDU',
      "F R' U L B' U' R2 L F D' F' D L2 D B2 U' B2 U2 R2 B2 L2",
    );
    expectSolution(
      'DFRBURUDDLBDRRFUDULLFLFUULFFBRRDRFBRBDBFLUDFLBULDBLBUR',
      "U F2 R B' U L' U2 L' U' B2 L F U' R2 D2 F2 R2 D2 B2 D B2 U'",
    );
    expectSolution(
      'RLRUURDLFUFDBRLFRBLFRFFDDLUFULRDUDFLUBFRLULBRBDBBBDUDB',
      "U2 F2 D' F' L' F' B' U B' R' L2 B' U' F2 L2 D L2 U' F2 U2 L2 U2",
    );
    expectSolution(
      'BBURULRUULFLBRRBFBDFBFFDFRDUULUDRDDUDBFLLDFBRFLRDBURLL',
      "U F D L2 U2 R' L U2 B2 R B' D' R2 D' F2 B2 D F2 D L2 D2",
    );
    expectSolution(
      'LBLLUBUFUBRUURFDLRRLRDFLDFLFRBRDDLBDFBFRLFFDRBUDUBUBDU',
      "U L' D2 B U B D2 F R B U2 R' D' R2 U L2 D R2 D2 R2 D2 F2",
    );
    expectSolution(
      'FUFBUBURDFLRDRFBUFLDRFFLBDDDBLFDLURLLUBFLURDRURULBRDBB',
      "B' R L F U' B' U L U R' B U L2 U2 L2 F2 U' F2 L2 B2 U2",
    );
    expectSolution(
      'RURFUDDDFLBBFRULUBFFUDFLDLDRBFBDLBDLFRRULRDRBURUBBFULL',
      "U' D' R B2 U R2 F2 R' F' L' U' F2 B2 R2 D B2 U2 R2 U2 R2",
    );
    expectSolution(
      'DBRDULBFBUDUDRRULLDRLLFRLBRFUBUDUDDFBFRBLFRFDFLLUBRUBF',
      "L' U R2 L F2 D2 B' U' L U2 R2 U D' R2 D' F2 R2 F2",
    );
    expectSolution(
      'URBLUBFDUBRRLRFLULRLRBFFLDDBFFLDRFFBRBDBLUUUUDDFRBDDUL',
      "U' R L' F' R' U B R2 U B2 R' F2 R2 B2 U2 D R2 U D2 F2 U2",
    );
    expectSolution(
      'BUULURRDFRURFRBUFUBLDDFLFBFDRRBDRUULLBDRLFBULBFDDBDFLL',
      "R D L' U' R2 B' L2 B2 U F' D' R U2 D' F2 R2 F2 D' F2 U L2 D",
    );
    expectSolution(
      'FURBUDLRRUBDFRLBDFBUBFFRUDDRRLDDFULLRUUBLULLFBLDBBRDFF',
      "R B' U' F' B2 L2 D2 R' U2 F' L D L2 U2 D' F2 L2 U R2 B2 R2",
    );
    expectSolution(
      'LLRDUBUBBURBBRBLRRRLLLFUBFDDRFFDUULFDFFDLULURUDBDBRDFF',
      "R2 L2 U' B' U2 L' B' R L' D2 B D F2 B2 L2 U' F2 D B2 U",
    );
    expectSolution(
      'FDRUUBBBLDRBDRLFFFDUBLFRBURURUFDRFFUDLRFLBDLLUBLDBDLUR',
      "U D2 B' U' L' U' F U' B R' D2 L D' B2 U2 R2 D R2 L2 B2",
    );
    expectSolution(
      'FBBDULLFRUBRLRLDFUDRBBFFUURLLFUDDDBLURBFLRFRBDURDBUFDL',
      "U R' D L' U2 D L U2 L' D2 F' R D' L2 U2 R2 D' F2 R2 D' F2 D2",
    );
    expectSolution(
      'LLBDURRDURBDLRLRULBBFBFDDBBFUUFDRLFFBRDFLLDDRLUUFBRUUF',
      "U2 L' U2 B' R L2 U R' F2 R' B D R2 U2 D R2 F2 D R2 L2 F2",
    );
    expectSolution(
      'LFFDUBLRDLLDURLBDFDUFLFFFDUUBRRDRDBUBLBRLUBBRRDUFBFLUR',
      "D2 B2 L' F R' L' B' L2 F2 D' R' U2 B2 D2 B2 D L2 U F2 D' F2",
    );
    expectSolution(
      'FBUDUBBRBUURLRRUFLDBLLFDRFFDLRFDRFUBDBRRLUUDFBLLUBDDFL',
      "R2 U R F' U R2 D2 B' R' B' R' U2 F2 D F2 U F2 D2 L2 B2 D'",
    );
    expectSolution(
      'ULBFURBDBDDDFRRBFFUBRLFUFRURBRUDDDLURRLLLFFBDLDFUBULBL',
      "F2 L U' R' B2 L' D B2 L B' D' B2 U B2 L2 U B2 L2 D2 R2",
    );
    expectSolution(
      'DUBBUFLFFLRLDRBBLRDUUDFLLRRFBDDDURRUFLBFLRBFDUBRDBLFUU',
      "D' F' D' L' F2 D F D2 R' L2 D2 R2 D B2 D B2 L2 U R2",
    );
    expectSolution(
      'BRDFUUUUULBFDRDDDFRLBUFRLBBUDRFDLBLDRRFBLFDLFLUUFBRRBL',
      "L' U R' F B2 D F R B R L2 D R2 U2 F2 R2 B2 R2 U R2",
    );
    expectSolution(
      'DBRLUFFUBDLFBRFLBLLFRFFUBLBRUDDDDFUULDUBLRRRUDLFDBRBRU',
      "R2 B2 R' L' F2 R2 B' D L U B D B2 R2 D' R2 D B2 D2 F2",
    );
    expectSolution(
      'LLURULDUDLBLURBBRFRFFRFLFRURBRFDDBBRDFBFLULDDFDBUBLUDU',
      "U F D' R' B' U R' F' D' F U2 L B2 U2 D L2 F2 L2 U F2 L2 U",
    );
    expectSolution(
      'UFLRULBLUBUBBRFRDFDFRBFLFUFLRDDDRBBLRFRBLULLUDDFUBDDRU',
      "U R L' D2 B' L F2 U F L2 U2 L D' R2 D2 R2 B2 U' L2 F2 D' L2",
    );
    expectSolution(
      'BRRLUFBFFLRFDRUDLURDUFFRULFRDLRDUDBBLFULLUBUFDBDBBBLDR',
      "U' D' F D' B' L2 F' R D' F B R2 F2 R2 D' R2 F2 U2 D R2 F2",
    );
    expectSolution(
      'DRDUUBRRLBLLRRLUFDUFULFBFDLULFDDUDBBFRBDLUFFRBDRFBBRUL',
      "L' B R D' L B R D' F2 U2 F L2 F2 U B2 D F2 R2 D' B2 D2",
    );
    expectSolution(
      'LLFLUBRURDLUFRDRURUBFRFULBDDRBRDRLDUBUBDLDDFBLFUBBFFLF',
      "L B' R' U' F L U D2 B' R B2 R2 F2 D2 B2 U2 D B2 L2 U2",
    );
    expectSolution(
      'LLBRUFUBBUURURDLLRBDLRFBBLFLUUDDFRRFFDRRLFUFDDBDLBBDUF',
      "F L' U D B' L' U' D R' U2 F' D2 R2 U2 L2 F2 U L2 B2 L2 U",
    );
    expectSolution(
      'FLLUUULLULBDRRFUFDUDBBFBBFRLRBBDURDBURFDLLFDDFURLBRRFD',
      "F2 B2 U2 B' U F2 D2 F B2 R F R2 U R2 D R2 L2 B2 U F2 D2",
    );
    expectSolution(
      'FURFUDBUDFLBFRBDRDUBRBFRULBFFRBDULDFUULRLRBDLULRLBDLFD',
      "U R L D R B U D F2 B2 R' U L2 B2 R2 U F2 D R2 B2 U'",
    );
    expectSolution(
      'BFFBUFUBFDRDDRDFRDBRLFFBBDUDLLBDUUFLUURLLLFLRRDLRBUBUR',
      "F' B' U2 R' F' B2 R' F2 L U' R U' B2 L2 D L2 D B2 D' F2 D",
    );
    expectSolution(
      'UFFDUULUUBFRLRFLDUDLRRFBBRDDUFDDFFBLLLBRLDDBRURBLBBFUR',
      "U D' F' R2 L' B2 R' L' D' L2 F' D' L2 U2 R2 F2 D' R2 F2 D'",
    );
    expectSolution(
      'DDRBUUBUFUBFURLBRFDFRRFRFFULLRDDBLULBDRLLFUFUDRLDBBDLB',
      "U' R' B2 R F' R U2 D F2 U2 R' U' R2 U R2 D' B2 L2 F2 D2",
    );
    expectSolution(
      'BDRLUBDBDFRBFRRBFFRURRFUDDDLLLUDLFDUUUBBLFRRFUBLDBLLFU',
      "R2 F D L' D B U' L' D2 R' B' R2 D R2 F2 U' R2 D' F2 U'",
    );
    expectSolution(
      'RFLUUFFDFDRBLRBRBRULLBFFUUFFFDLDDUDDURRBLRBULDDBLBUBRL',
      "F2 L B2 U2 B' L' D R' U R' F2 U F2 B2 R2 D' F2 B2 U' F2",
    );
    expectSolution(
      'DURFULUBUFDFLRFRUBLRLRFBFDBUBUFDRDFRBRBULDFLRDLLDBBDUL',
      "U L B2 R2 D' R B D2 F R L F R2 D R2 B2 D2 F2 U' D2 L2 B2",
    );
    expectSolution(
      'BRDFUBUBULULRRUDFUFRBDFUDFFRDLDDLFLFRULLLRDBBBFULBBRDR',
      "F2 R D L B2 U L2 B' R' U D' F' R2 F2 R2 D F2 U2 D B2 R2 U'",
    );
    expectSolution(
      'LFDLUUDRDBBBRRUBFLFFLBFURDUFBRUDDUBFFDRRLLBLURLDFBDURL',
      "D' R B L' D R' D2 R F B L' U' R2 U' F2 L2 U' L2 D R2 U2",
    );
    expectSolution(
      'FUDLUBDLFLRBURFUDLLDUFFLBUFURRBDFRDBRFFDLRBLLRBDUBRDBU',
      "F' U D2 B2 L B' U' R2 F2 R' D' L2 U' B2 L2 D' R2 L2 B2 D",
    );
    expectSolution(
      'LUFFUURDFDLURRDBBFUBLUFFBRDDDLLDRRLDBLBBLRUDRLFUFBURBF',
      "L F' L2 F D2 R2 L2 B2 U' F U D R2 D' B2 L2 F2 R2 U2 D'",
    );
    expectSolution(
      'URDBUDLLBDFLBRUDLFBDRBFDDURLLFRDBULRBUUDLRLUFBFRFBRUFF',
      "B2 U2 L' B' R L2 F B R2 L F' U' B2 U B2 R2 U' R2 F2 B2 L2",
    );
    expectSolution(
      'RLFDUFFBLDUDBRLDFFLDBUFULLBBDRRDDFURURURLLLBURFBBBFURD',
      "U F' R2 F2 U' R F R2 D F2 R' F' D B2 U2 R2 B2 U2 R2 D F2 R2",
    );
    expectSolution(
      'BRDBUFBFBUURBRRFUUDLLDFDDDRLFULDLBULRURLLRDBFFFUBBDFRL',
      "F' D B2 R' L2 U2 B L' F' D L' U R2 U' L2 B2 D2 B2 D2 L2 B2",
    );
    expectSolution(
      'BRBFUURBFRRDURLBDDFRDFFBBLRUDDLDRUBFRUUFLDLULLFUBBLLDF',
      "U F' B R' D B' R U R' F U' L U' B2 U2 L2 U' R2 B2 L2 U F2",
    );
    expectSolution(
      'FLDRUBBRUBDRBRRLRFDFRDFUUUBFFDDDUULRDDRLLFBLLFULBBFUBL',
      "U R F' U' L' F R2 F R' U2 B L' F2 B2 U F2 L2 D L2 D R2 U2",
    );
    expectSolution(
      'BFRLURUFFLFBBRRDLDLLUDFRULFRDLFDURBRLBBRLBDUFUDDDBUFUB',
      "R B' D' L' U R D L' D R2 F D2 F2 D' R2 L2 B2 R2 U' R2",
    );
    expectSolution(
      'BDFBUUFDLUFDLRUFURDBFLFDUURLBUDDRDLBDRLFLFLRBRFRLBRUBB',
      "R L2 U F R2 D2 R' L2 U F' D' L' U' B2 U' L2 U F2 R2 D2 L2 D",
    );
    expectSolution(
      'FDLBUBRLUBUFDRURRBDURFFLLDUDFFRDFDLLDLFRLUBBBUBLRBDUFR',
      "U R D' R U' B2 D2 R' B' D' F' L' U L2 D' F2 L2 D F2 U2 L2 U",
    );
    expectSolution(
      'BBFRURDDLBFRDRFDLDFLUDFRFDFLBLUDBRULDURULFBLUURRLBFBBU',
      "U' F' D2 B' L' U2 R2 D R D2 R' F2 U L2 F2 D B2 D2 L2 D' R2",
    );
    expectSolution(
      'BDBBULRBRFBLLRDFFBURUDFUDUULFLUDRRFDDUBLLRFRFUBRLBFLDD',
      "U B' L' B L F B D' R L' F R U L2 F2 B2 D F2 D2 R2 U D2",
    );
    expectSolution(
      'URLBULDDULDBBRLRRFRRBFFLFLFDFDUDUURRBUBBLDLFLDFRUBDUBF',
      "U L2 U D2 R' D B2 L F D L2 B' R2 B2 D2 F2 U2 L2 F2 L2 U L2",
    );
    expectSolution(
      'LDUFULFRURDRLRULBDDFFRFBFBURDBBDUBFLULLDLURRDBFFLBRBUD',
      "F' U2 D' F U' F2 U' F D B' L' D2 F2 U R2 U' L2 B2 U' B2 U2",
    );
    expectSolution(
      'FDBBUDUBRDBLLRFBRRBUFRFULDDUFLFDURLUDRRLLDDUFULLRBFFBB',
      "R2 F' R L' U R' U2 F' D2 F R U' R2 U L2 U' B2 L2 U2 D B2",
    );
    expectSolution(
      'UFBBURLLBRFDBRRFURBDUDFLDBDLDRFDLUBDRUUFLRLDFLLFUBUBRF',
      "R D F' L F' L2 B' U' D' R D B' U2 F2 U' L2 B2 U' L2 D R2 L2",
    );
    expectSolution(
      'DURBULRULBUDRRRLDLDBULFFFBBULDDDRBBFLDFDLFUFRBFFUBLURR',
      "F U' R F' R L D2 L' B' D R F2 U' R2 B2 D R2 D2 R2 L2 B2",
    );
    expectSolution(
      'UFBLURRDLDURRRLUFFFBBFFDULRFFBRDUFBDLBUDLRLBLDDBUBLRUD',
      "B U R' D2 R2 D' B2 U' R B' U R2 D2 R2 B2 U F2 D' B2 U'",
    );
    expectSolution(
      'FLBUUDFBDBFURRRUBLLULRFFLLFBDRBDLDRDRLUFLDBDURFDBBUFUR',
      "U' D' R' F' R2 U' D2 F U' L U R2 U2 L2 F2 R2 L2 U' F2 D'",
    );
    expectSolution(
      'DRLUUBFBRBLURRLRUBLRDDFDLFUFUFFDBRDUBRUFLLFDDBFLUBLRBD',
      "D2 R' D' F2 B D R2 D2 R' F2 D' F2 U' B2 L2 U2 D R2 U",
    );
  });

  test('multiple solutions', () async {
    final cube =
        Cube.from('BLRRULDLRFDDBRFLFRFFUBFULRDBBFUDRFRBLDRULDUFUBBDDBLUUL');

    expect(
      cube.solveDeeply().map((s) => '$s'),
      emitsInOrder(
        const [
          "U D R F U D2 R' U F' U' B' L2 U L2 U' R2 U2 B2 L2 U F2",
          "R' B D B2 L D F' L' F2 D L B2 U' B2 U' L2 D' L2 B2 D'",
          "D2 F D' L U' F D2 B U' F2 L F' D' F2 R2 B2 L2 U' F2",
          "R' B U2 B2 U R2 D2 R2 F U2 D' B2 R' U F2 U' F2 U'",
        ],
      ),
    );
  });

  test('solve pattern', () {
    expectPatternSolution(
      'UUUUUUUUUFFFRRRRRRLLLFFFFFFDDDDDDDDDBBBLLLLLLRRRBBBBBB',
      'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB',
      'U',
    );
    expectPatternSolution(
      'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB',
      'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB',
      isEmpty,
    );
    expectPatternSolution(
      'UUFLUFBULDLRURUUFBUBBFFLDBRFDBLDRDRRFDLBLDFBRURLFBRDDL',
      'RRRUUFRLBLDFRRDULLUBDBFUULLRUFFDFLLDBFBRLUURFDDDBBBFDB',
      "B2 D' F2 D2 B' D' R2 F D' R F2 R2 D2 R2 U B2 U2 R2 F2",
    );
    expectPatternSolution(
      'DLLLUULDRBFUFRRFFLFBDRFRUBRBUUDDLBLFFDDRLDDFRBBRBBUUUL',
      'UULRUFDFBRDFFRDFBDFRURFUUFLLLDDDLDDBRURBLBLRBULFLBURBB',
      "U2 F B L' U' B2 D F' B2 U2 D2 R' U2 R2 U R2 D' B2 U2 R2 B2 L2",
    );
    expectPatternSolution(
      'FBURUFDDLFDBLRLUBBFLDRFFRBFBLRFDUBRDLDRFLBURDLDUUBULUR',
      'LFBRUULLLUFRDRDUDFDDFRFRUBFLRRLDBUBDFFBBLURUBDLDFBURLB',
      "L' U' D2 B2 L D' B R L' B U2 D2 R2 F2 B2 U' B2 U2 L2 F2",
    );
    expectPatternSolution(
      'LRDBURRFDFBFBRUBLBUDRRFLLLRUFDFDURRLDDBDLDUUFLUBBBLUFF',
      'LDLLUBFRUBDBLRFLBRUBRDFDRBDDUFRDLLUDUFRULFUFFDRFUBRBLB',
      "U D2 B D' R' U' F' D' F' L2 F' U2 F2 D L2 U R2 U' L2 U'",
    );
    expectPatternSolution(
      'BBLFUFFRRBDFDRLUBURBDUFRUDBRLLRDUDBRLRDLLFFUFULDUBFBDL',
      'ULLFUUDURDRBLRDUBDLBFFFDLLRBUBRDRUBBFRFLLUFDUDFLFBBRDR',
      "R' D2 B' R F D2 F2 D F R' L2 F2 U' R2 D F2 U D R2 D'",
    );
    expectPatternSolution(
      'DRLLUUURBRBFBRUDLULBUFFDLDFDFLRDDDLFFBBRLUBFBUURLBDRFR',
      'LFFFUBDLDRLUBRRLDBFUBDFDRRBFBDFDRBUUFRRDLFLLULUDUBLRBU',
      "U' F R2 U B2 L' B2 U2 B R F U R2 B2 U D F2 U' B2 D'",
    );
    expectPatternSolution(
      'DDULUULFDFRRBRURDDDURFFDUBULRFUDFLFBLBBDLRFBBBLFLBRRLU',
      'FRLLULDFLFFUDRBRRRFDDUFRDBDBLBBDFUBULURDLFRDLBUUUBLFRB',
      "F L D R B U2 L B' L2 D2 R' D' B2 D F2 B2 D L2 D B2 R2",
    );
    expectPatternSolution(
      'DBBUUBUDBRRDRRDLUFLFUDFFRUFBLUFDRFBDLFBBLRRLDLUFLBLRDU',
      'RBRFULBBLUUUDRDBRRLUFBFLRLLDFUUDUDFDUDDRLLFFFFDBRBBBRL',
      "R' F' R B2 R D B L D2 L F' U' L2 D2 F2 U' B2 R2 F2 L2 D'",
    );
    expectPatternSolution(
      'DRFFUBLBFDRDBRULRRUDLLFURRBFFDFDDLDBRUFDLBULURUBLBLUFB',
      'DLUDUFUFRURFBRULLLLDBUFDDUFFRULDUDBDRRBBLFLFRRDBBBLFRB',
      "U2 R U2 R B' L' D B D F L' U B2 D2 R2 D2 R2 D L2 U B2",
    );
  });

  test('predefinied patterns', () {
    expect(Cube.checkerboard.isOk, true);
    expect(
      Cube.checkerboard.solve().toString(),
      "F' R L' F2 U D' R2 F' B R' U R2 L2 F2 B2 D B2 D2 B2 U2",
    );

    expect(Cube.wire.isOk, true);
    expect(
      Cube.wire.solve().toString(),
      "R L U2 R L F2 U' D' F2 B2 R2 U D F2",
    );

    expect(Cube.spiral.isOk, true);
    expect(
      Cube.spiral.solve().toString(),
      "R2 L U F D2 B R' U2 L' U B' R2 U2 R2 D' B2 U F2 U' B2 U",
    );

    expect(Cube.stripes.isOk, true);
    expect(
      Cube.stripes.solve().toString(),
      "R L' F U D' L2 B2 L F B' U' F2 D F2 B2 U B2 R2 F2 D",
    );

    expect(Cube.crossOne.isOk, true);
    expect(
      Cube.crossOne.solve().toString(),
      'U R2 L2 F2 U2 D2 R2 L2 B2 U D2',
    );

    expect(Cube.crossTwo.isOk, true);
    expect(
      Cube.crossTwo.solve().toString(),
      'R U2 F2 B2 U2 F2 B2 R L2 U F2 B2 U2 R2 L2 D F2 B2',
    );

    expect(Cube.cubeInCube.isOk, true);
    expect(
      Cube.cubeInCube.solve().toString(),
      "U' B2 D' F' L F' L F' L D B2 U' F2 R2 U2",
    );

    expect(Cube.cubeInCubeInCube.isOk, true);
    expect(
      Cube.cubeInCubeInCube.solve().toString(),
      "U R D B R2 F2 R L2 B2 D B' R2 D2 R2 D' L2 F2 U' B2 D' F2",
    );

    expect(Cube.anaconda.isOk, true);
    expect(
      Cube.anaconda.solve().toString(),
      "R B U' R' U' B2 U L B L' U B2 U' B2 U' L2 U' L2 U' B2",
    );

    expect(Cube.python.isOk, true);
    expect(
      Cube.python.solve().toString(),
      "U R U F' L2 F U' R' F2 U' F2 U L2 U' F2 D L2 D'",
    );

    expect(Cube.twister.isOk, true);
    expect(
      Cube.twister.solve().toString(),
      "U' F2 U R' U2 R F' R2 F' U2 R2 F2 R2 U2 F2 R2 U' F2 U",
    );

    expect(Cube.tetris.isOk, true);
    expect(
      Cube.tetris.solve().toString(),
      "U D F B R L F2 R2 F2 R2 U' D' R2 F2 L2 B2",
    );

    expect(Cube.chickenFeet.isOk, true);
    expect(
      Cube.chickenFeet.solve().toString(),
      "R B2 U2 L' F' U D R' L' F' L2 F2 D R2 F2 U B2 D L2 U'",
    );

    expect(Cube.fourSpots.isOk, true);
    expect(
      Cube.fourSpots.solve().toString(),
      "U R2 L2 U D' F2 B2 D'",
    );

    expect(Cube.sixSpots.isOk, true);
    expect(
      Cube.sixSpots.solve().toString(),
      "U D F B R L U2 L2 F2 R2 D2 L2 B2 U' D' F2",
    );

    expect(Cube.sixTs.isOk, true);
    expect(
      Cube.sixTs.solve().toString(),
      "U D F2 R2 U D' L2 B2 D2",
    );
  });

  test('scrambled cube', () {
    final cube = Cube.scrambled();
    print(cube.definition);
    expect(cube.isOk, true);
    expect(cube.solve()!.algorithm.length, greaterThan(16));
  });

  group('move', () {
    const c = Cube.solved;

    test('up', () async {
      expect(
        c.move(Move.up).definition,
        'UUUUUUUUUBBBRRRRRRRRRFFFFFFDDDDDDDDDFFFLLLLLLLLLBBBBBB',
      );
      expect(
        c.move(Move.upInv).definition,
        'UUUUUUUUUFFFRRRRRRLLLFFFFFFDDDDDDDDDBBBLLLLLLRRRBBBBBB',
      );
      expect(
        c.move(Move.upDouble).definition,
        'UUUUUUUUULLLRRRRRRBBBFFFFFFDDDDDDDDDRRRLLLLLLFFFBBBBBB',
      );
    });

    test('right', () async {
      expect(
        c.move(Move.right).definition,
        'UUFUUFUUFRRRRRRRRRFFDFFDFFDDDBDDBDDBLLLLLLLLLUBBUBBUBB',
      );
      expect(
        c.move(Move.rightInv).definition,
        'UUBUUBUUBRRRRRRRRRFFUFFUFFUDDFDDFDDFLLLLLLLLLDBBDBBDBB',
      );
      expect(
        c.move(Move.rightDouble).definition,
        'UUDUUDUUDRRRRRRRRRFFBFFBFFBDDUDDUDDULLLLLLLLLFBBFBBFBB',
      );
    });

    test('front', () async {
      expect(
        c.move(Move.front).definition,
        'UUUUUULLLURRURRURRFFFFFFFFFRRRDDDDDDLLDLLDLLDBBBBBBBBB',
      );
      expect(
        c.move(Move.frontInv).definition,
        'UUUUUURRRDRRDRRDRRFFFFFFFFFLLLDDDDDDLLULLULLUBBBBBBBBB',
      );
      expect(
        c.move(Move.frontDouble).definition,
        'UUUUUUDDDLRRLRRLRRFFFFFFFFFUUUDDDDDDLLRLLRLLRBBBBBBBBB',
      );
    });

    test('down', () async {
      expect(
        c.move(Move.down).definition,
        'UUUUUUUUURRRRRRFFFFFFFFFLLLDDDDDDDDDLLLLLLBBBBBBBBBRRR',
      );
      expect(
        c.move(Move.downInv).definition,
        'UUUUUUUUURRRRRRBBBFFFFFFRRRDDDDDDDDDLLLLLLFFFBBBBBBLLL',
      );
      expect(
        c.move(Move.downDouble).definition,
        'UUUUUUUUURRRRRRLLLFFFFFFBBBDDDDDDDDDLLLLLLRRRBBBBBBFFF',
      );
    });

    test('left', () async {
      expect(
        c.move(Move.left).definition,
        'BUUBUUBUURRRRRRRRRUFFUFFUFFFDDFDDFDDLLLLLLLLLBBDBBDBBD',
      );
      expect(
        c.move(Move.leftInv).definition,
        'FUUFUUFUURRRRRRRRRDFFDFFDFFBDDBDDBDDLLLLLLLLLBBUBBUBBU',
      );
      expect(
        c.move(Move.leftDouble).definition,
        'DUUDUUDUURRRRRRRRRBFFBFFBFFUDDUDDUDDLLLLLLLLLBBFBBFBBF',
      );
    });

    test('bottom', () async {
      expect(
        c.move(Move.bottom).definition,
        'RRRUUUUUURRDRRDRRDFFFFFFFFFDDDDDDLLLULLULLULLBBBBBBBBB',
      );
      expect(
        c.move(Move.bottomInv).definition,
        'LLLUUUUUURRURRURRUFFFFFFFFFDDDDDDRRRDLLDLLDLLBBBBBBBBB',
      );
      expect(
        c.move(Move.bottomDouble).definition,
        'DDDUUUUUURRLRRLRRLFFFFFFFFFDDDDDDUUURLLRLLRLLBBBBBBBBB',
      );
    });
  });

  test('correct orientation', () {
    const d = 'DUUDDDDUULLRRRRLLRBBBFBFFBFDDUUUUDDURRLLLLRRLBFBBFBFFF';
    final cube = Cube.from(d);
    expect(cube, Cube.sixTs);
  });

  test('svg', () {
    const cube = Cube.solved;

    for (var a = 0; a < 4; a++) {
      for (var b = 0; b < 4; b++) {
        for (var c = 0; c < 4; c++) {
          final ra = Rotation(axis: Axis.x, n: a);
          final rb = Rotation(axis: Axis.y, n: b);
          final rc = Rotation(axis: Axis.z, n: c);

          File('./cube.$ra.$rb.$rc.svg').writeAsStringSync(
            cube.svg(orientation: [ra, rb, rc]),
          );
        }
      }
    }
  });

  test('feliksZemdegs422', () async {
    final feliksZemdegs422 = Cube.feliksZemdegs422;
    expect(feliksZemdegs422.isOk, true);
  });

  test('yushengDu347', () async {
    final yushengDu347 = Cube.yushengDu347;
    expect(yushengDu347.isOk, true);
  });
}

void expectSolution(
  String definition,
  solution,
) {
  final cube = Cube.from(definition);
  expect(cube.solve().toString(), solution);
}

void expectPatternSolution(
  String from,
  String to,
  solution,
) {
  final a = Cube.from(from);
  final b = Cube.from(to);
  final p = a.patternize(b);
  expect(p.solve().toString(), solution);
}
