import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/root/splash_cubit.dart';
import 'package:loca_student/ui/pages/home_page.dart';
import 'package:loca_student/ui/pages/user_type_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state == SplashState.navigateToUserType) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (newContext) => const UserTypePage()));
        } else if (state == SplashState.navigateToHome) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (newContext) => const HomePage()));
        }
      },
      child: const Scaffold(
        body: Center(child: Text('Splash Screen', style: TextStyle(fontSize: 24))),
      ),
    );
  }
}
