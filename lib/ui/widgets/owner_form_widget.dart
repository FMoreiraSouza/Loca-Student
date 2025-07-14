import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:loca_student/bloc/auth/owner_register_event.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_state.dart';

class OwnerForm extends StatefulWidget {
  final UserRegisterState state;

  const OwnerForm({super.key, required this.state});

  @override
  _OwnerFormState createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();
  final vacanciesController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final valueFocus = FocusNode();
  final addressFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();
  final emailFocus = FocusNode();
  final vacanciesFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    emailController.dispose();
    vacanciesController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    valueFocus.dispose();
    addressFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    emailFocus.dispose();
    vacanciesFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  bool _validateFields(BuildContext context) {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        valueController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos para proprietário')));
      return false;
    }
    return true;
  }

  // Função para consultar a bounding box da cidade usando Nominatim
  Future<Map<String, double>?> _getCityCoordinates(String city) async {
    try {
      const userAgent = 'LocaStudent/1.0 (fmoreirasouza701@gmail.com)'; // Substitua pelo seu e-mail
      final query = city;
      final url =
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1&addressdetails=1&featuretype=city';
      final response = await http.get(Uri.parse(url), headers: {'User-Agent': userAgent});

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      if (data.isEmpty) {
        return null;
      }

      final result = data[0];
      final boundingBox = result['boundingbox'] as List<dynamic>;
      final minLat = double.parse(boundingBox[0] as String);
      final maxLat = double.parse(boundingBox[1] as String);
      final minLon = double.parse(boundingBox[2] as String);
      final maxLon = double.parse(boundingBox[3] as String);

      // Gera coordenadas aleatórias dentro da bounding box
      final random = Random();
      final latitude = minLat + (maxLat - minLat) * random.nextDouble();
      final longitude = minLon + (maxLon - minLon) * random.nextDouble();

      return {'latitude': latitude, 'longitude': longitude};
    } catch (e) {
      print('Erro ao consultar Nominatim: $e');
      return null;
    }
  }

  void _submitForm(BuildContext context) async {
    if (_validateFields(context)) {
      // Obtém coordenadas aleatórias com base na cidade e estado
      final coords = await _getCityCoordinates(cityController.text.trim());

      // Verifica se o widget ainda está montado antes de usar o context
      if (!mounted) return;

      if (coords == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao obter coordenadas da cidade')));
        return;
      }

      context.read<UserRegisterBloc>().add(
        OwnerRegisterSubmitted(
          name: nameController.text.trim(),
          value: double.tryParse(valueController.text.trim()) ?? 0.0,
          address: addressController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          latitude: coords['latitude']!,
          longitude: coords['longitude']!,
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: nameController,
          focusNode: nameFocus,
          decoration: const InputDecoration(labelText: 'Nome'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(valueFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: valueController,
          focusNode: valueFocus,
          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(addressFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: addressController,
          focusNode: addressFocus,
          decoration: const InputDecoration(labelText: 'Endereço'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(cityFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: cityController,
          focusNode: cityFocus,
          decoration: const InputDecoration(labelText: 'Cidade'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(stateFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: stateController,
          focusNode: stateFocus,
          decoration: const InputDecoration(labelText: 'Estado'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(emailFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          focusNode: emailFocus,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(vacanciesFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: vacanciesController,
          focusNode: vacanciesFocus,
          decoration: const InputDecoration(labelText: 'Vagas'),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(passwordFocus);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          focusNode: passwordFocus,
          decoration: const InputDecoration(labelText: 'Senha'),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            // Fechar o teclado
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(height: 24),
        widget.state is UserRegisterLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: () => _submitForm(context), child: const Text('Cadastrar')),
      ],
    );
  }
}
