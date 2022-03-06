import 'package:amber/screens/auth/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amber/screens/auth/login.dart';
void main() {
  test('pwtest1', () {
    var x = PWValidator.validate('aAABB2!a');
    expect(x, true);
  });
  test('pwtest2', () {
    var x = PWValidator.validate('aaa');
    expect(x, false);
  });
  test('pwtest2', () {
    var x = PWValidator.validate('');
    expect(x, false);
  });
}