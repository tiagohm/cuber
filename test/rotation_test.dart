// ignore_for_file: use_named_constants

import 'package:cuber/cuber.dart';
import 'package:test/test.dart';

void main() {
  test('zero', () {
    expect(Rotation.none, const Rotation(axis: Axis.x, n: 0));
    expect(const Rotation.x(4), Rotation.none);
    expect(const Rotation.x(0), Rotation.none);
    expect(const Rotation.x(-4), Rotation.none);
  });

  test('one', () {
    expect(const Rotation.x(5), const Rotation(axis: Axis.x));
    expect(const Rotation.x(-5), const Rotation(axis: Axis.x));
  });

  test('two', () {
    expect(const Rotation.x(6), const Rotation(axis: Axis.x, n: 2));
    expect(const Rotation.x(-6), const Rotation(axis: Axis.x, n: 2));
  });

  test('three', () {
    expect(const Rotation.x(7), const Rotation(axis: Axis.x, n: 3));
    expect(const Rotation.x(-7), const Rotation(axis: Axis.x, n: 3));
  });

  test('clockwise', () {
    expect(const Rotation.x(), const Rotation(axis: Axis.x));
    expect(const Rotation.x(2), const Rotation(axis: Axis.x, n: 2));
    expect(const Rotation.x(3), const Rotation(axis: Axis.x, n: 3));
  });

  test('counterclockwise', () {
    expect(const Rotation.x(-1), const Rotation(axis: Axis.x, n: 3));
    expect(const Rotation.x(-2), const Rotation(axis: Axis.x, n: 2));
    expect(const Rotation.x(-3), const Rotation(axis: Axis.x));
  });

  test('inverse', () {
    expect(const Rotation.x().inverse(), const Rotation.x(-1));
    expect(const Rotation.x().inverse(), const Rotation(axis: Axis.x, n: 3));
  });
}
