import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/root/splash_cubit.dart';
import 'package:loca_student/data/services/shared_preferences_service.dart';
import 'package:loca_student/ui/pages/home_page.dart';
import 'package:loca_student/ui/pages/user_type_page.dart';
import 'package:loca_student/utils/convert_data.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreferencesService().getString('user_type'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Enquanto espera o resultado do SharedPreferences
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Converte o resultado do SharedPreferences para UserType?
        final userType = stringToUserType(snapshot.data);

        return BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state == SplashState.navigateToUserType) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (newContext) => const UserTypePage()));
            } else if (state == SplashState.navigateToHome) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (newContext) => HomePage(userType: userType)),
              );
            }
          },
          child: const Scaffold(
            body: Center(child: Text('Splash Screen', style: TextStyle(fontSize: 24))),
          ),
        );
      },
    );
  }
}
