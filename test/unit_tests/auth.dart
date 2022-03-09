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
      expect(PWValidator.validatePassword('aAABB2!a'), true);
    });
    test('pwtest2', () {
      expect(PWValidator.validatePassword('aaa'), false);
    });
    test('pwtest2', () {
      expect(PWValidator.validatePassword(''), false);
    });
  });

  group('Account Type', () {
    test('acctest1', () {
      expect(PWValidator.validateAccount('Artist'), true);
    });
    test('acctest2', () {
      expect(PWValidator.validateAccount('Student'), true);
    });
    test('acctest3', () {
      expect(PWValidator.validateAccount('Content Creator'), true);
    });
    test('acctest4', () {
      expect(PWValidator.validateAccount('Brand Marketer'), true);
    });
    test('acctest5', () {
      expect(PWValidator.validateAccount('Personal'), true);
    });
    test('acctest6', () {
      expect(PWValidator.validateAccount('aaaa'), false);
    });
    test('acctest7', () {
      expect(PWValidator.validateAccount(''), false);
    });
  });

  group('Date of Birth', () {
    test('dobtest0', () {
      expect(PWValidator.validateDOB('01/12/21'), true);
    });
    test('dobtest1', () {
      expect(PWValidator.validateDOB('10102002'), false);
    });
    test('dobtest2', () {
      expect(PWValidator.validateDOB('10)10)10'), false);
    });
    test('dobtest3', () {
      expect(PWValidator.validateDOB('10/11/2200'), true);
    });
    test('dobtest4', () {
      expect(PWValidator.validateDOB('aa.aa.111a'), false);
    });
    test('dobtest5', () {
      expect(PWValidator.validateDOB('1.1.2001'), true);
    });
  });
}
