import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/root/splash_cubit.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/ui/pages/splash_page.dart';
import 'package:loca_student/ui/theme/app_theme.dart'; // Importa o tema

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SplashCubit(authRepository: RepositoryProvider.of<AuthRepository>(context)),
          ),
          BlocProvider(create: (context) => UserTypeCubit()),
          BlocProvider(
            create: (context) =>
                LoginBloc(authRepository: RepositoryProvider.of<AuthRepository>(context)),
          ),
          BlocProvider(
            create: (context) =>
                UserRegisterBloc(authRepository: RepositoryProvider.of<AuthRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'User Type App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData, // Usa o ThemeData do arquivo app_theme.dart
          home: const SplashPage(),
        ),
      ),
    );
  }
}
