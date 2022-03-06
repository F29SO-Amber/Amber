import 'package:amber/screens/auth/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:test/test.dart';

void main() {
  group('Email', () {
    test('emailtest0', () {
      expect(EmailValidator.validate(''), false);
    });
    test('emailtest1', () {
      expect(EmailValidator.validate('foo'), false);
    });
    test('emailtest2', () {
      expect(EmailValidator.validate('foo@foo.com'), true);
    });
    test('emailtest3', () {
      expect(EmailValidator.validate('foo!@122233@gmail.com'), false);
    });
    test('emailtest4', () {
      expect(EmailValidator.validate('foo1213341241@gmail.com'), true);
    });
  });

  group('Password', () {
    test('pwtest1', () {
      expect(PWValidator.validatepw('aAABB2!a'), true);
    });
    test('pwtest2', () {
      expect(PWValidator.validatepw('aaa'), false);
    });
    test('pwtest2', () {
      expect(PWValidator.validatepw(''), false);
    });
  });

  group('Account Type', () {
    test('acctest1', () {
      expect(PWValidator.validateacc('Artist'), true);
    });
    test('acctest2', () {
      expect(PWValidator.validateacc('Student'), true);
    });
    test('acctest3', () {
      expect(PWValidator.validateacc('Content Creator'), true);
    });
    test('acctest4', () {
      expect(PWValidator.validateacc('Brand Marketer'), true);
    });
    test('acctest5', () {
      expect(PWValidator.validateacc('Personal'), true);
    });
    test('acctest6', () {
      expect(PWValidator.validateacc('aaaa'), false);
    });
    test('acctest7', () {
      expect(PWValidator.validateacc(''), false);
    });
  });

  group('Date of Birth', () {
    test('dobtest0', () {
      expect(PWValidator.validatedob('01/12/21'), true);
    });
    test('dobtest1', () {
      expect(PWValidator.validatedob('10102002'), false);
    });
    test('dobtest2', () {
      expect(PWValidator.validatedob('10)10)10'), false);
    });
    test('dobtest3', () {
      expect(PWValidator.validatedob('10/11/2200'), true);
    });
    test('dobtest4', () {
      expect(PWValidator.validatedob('aa.aa.111a'), false);
    });
    test('dobtest5', () {
      expect(PWValidator.validatedob('1.1.2001'), true);
    });
  });
}
