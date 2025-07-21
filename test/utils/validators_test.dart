import 'package:flutter_test/flutter_test.dart';
import 'package:loca_student/utils/validators.dart';

void main() {
  group('Validators.requiredField', () {
    test('retorna mensagem quando valor é nulo', () {
      expect(Validators.requiredField(null), 'Entrada obrigatória');
    });

    test('retorna mensagem quando valor é vazio', () {
      expect(Validators.requiredField('   '), 'Entrada obrigatória');
    });

    test('retorna null quando valor preenchido', () {
      expect(Validators.requiredField('teste'), null);
    });
  });

  group('Validators.email', () {
    test('retorna mensagem quando email é vazio', () {
      expect(Validators.email(''), 'Email é obrigatório');
    });

    test('retorna mensagem quando email inválido', () {
      expect(Validators.email('emailinvalido'), 'Email inválido');
    });

    test('retorna null para email válido', () {
      expect(Validators.email('teste@email.com'), null);
    });
  });

  group('Validators.phone', () {
    test('retorna mensagem quando telefone é vazio', () {
      expect(Validators.phone(''), 'Telefone é obrigatório');
    });

    test('retorna mensagem quando telefone tem menos dígitos', () {
      expect(Validators.phone('12345'), 'Telefone inválido');
    });

    test('retorna null para telefone válido com 10 dígitos', () {
      expect(Validators.phone('1133224455'), null);
    });

    test('retorna null para telefone válido com 11 dígitos', () {
      expect(Validators.phone('11987654321'), null);
    });
  });

  group('Validators.age', () {
    test('retorna mensagem quando idade é vazia', () {
      expect(Validators.age(''), 'Idade é obrigatório');
    });

    test('retorna mensagem quando idade não é número', () {
      expect(Validators.age('abc'), 'Idade inválida');
    });

    test('retorna mensagem quando idade é zero', () {
      expect(Validators.age('0'), 'Idade inválida');
    });

    test('retorna mensagem quando idade é negativa', () {
      expect(Validators.age('-5'), 'Idade inválida');
    });

    test('retorna null para idade válida', () {
      expect(Validators.age('25'), null);
    });
  });

  group('Validators.password', () {
    test('retorna mensagem quando senha é vazia', () {
      expect(Validators.password(''), 'Entrada obrigatória');
    });

    test('retorna mensagem quando senha tem menos de 8 caracteres', () {
      expect(Validators.password('1234567'), 'A Senha deve ter mais do que 8 caracteres');
    });

    test('retorna null quando senha tem 8 caracteres', () {
      expect(Validators.password('12345678'), null);
    });

    test('retorna null quando senha tem mais de 8 caracteres', () {
      expect(Validators.password('minhasenha123'), null);
    });
  });
}
