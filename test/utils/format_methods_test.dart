import 'package:flutter_test/flutter_test.dart';
import 'package:loca_student/utils/format_methods.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';

void main() {
  final format = FormatMethods();

  group('FormatMethods.stringToUserType', () {
    test('retorna UserType.student para "estudante"', () {
      expect(format.stringToUserType('estudante'), UserType.student);
    });

    test('retorna UserType.republic para "república"', () {
      expect(format.stringToUserType('república'), UserType.republic);
    });

    test('retorna null para valor inválido', () {
      expect(format.stringToUserType('qualquer'), null);
    });

    test('retorna null para valor nulo', () {
      expect(format.stringToUserType(null), null);
    });
  });

  group('FormatMethods.applyPhoneMask', () {
    test('aplica máscara corretamente para 11 dígitos', () {
      expect(format.applyPhoneMask('11987654321'), '(11) 98765-4321');
    });

    test('aplica máscara corretamente para 10 dígitos', () {
      expect(format.applyPhoneMask('1133224455'), '(11) 33224-455');
    });

    test('remove caracteres não numéricos antes de aplicar', () {
      expect(format.applyPhoneMask('(11)98765-4321'), '(11) 98765-4321');
    });

    test('limita a 11 dígitos mesmo se passar mais', () {
      expect(format.applyPhoneMask('119876543211111'), '(11) 98765-4321');
    });
  });
}
