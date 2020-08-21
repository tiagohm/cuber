import 'package:cuber/cuber.dart';
import 'package:test/test.dart';

void main() {
  test('parser', () {
    expect(Move.parse('U'), Move.up);
    expect(Move.parse("R'"), Move.rightInv);
    expect(Move.parse('B2'), Move.bottomDouble);
  });

  test('toString', () {
    expect(Move.parse(Move.downDouble.toString()), Move.downDouble);
    expect(Move.parse(Move.frontInv.toString()), Move.frontInv);
    expect(Move.parse(Move.left.toString()), Move.left);
  });

  test('inverse', () {
    expect(Move.downDouble.inverse(), Move.downDouble);
    expect(Move.down.inverse(), Move.downInv);
    expect(Move.downInv.inverse(), Move.down);
  });
}
