import 'package:amber/screens/auth/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amber/screens/auth/login.dart';
void main() {
  test('pwtest1', () {
    var x = PWValidator.validatepw('aAABB2!a');
    expect(x, true);
  });
  test('pwtest2', () {
    var x = PWValidator.validatepw('aaa');
    expect(x, false);
  });
  test('pwtest2', () {
    var x = PWValidator.validatepw('');
    expect(x, false);
  });
}