import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_cubit.dart'; // Importar cubit
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/root/splash_cubit.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'package:loca_student/ui/splash/pages/splash_page.dart';
import 'package:loca_student/ui/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => HomeRepository()),
        RepositoryProvider(create: (_) => ProfileRepository()),
      ],
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
          BlocProvider(create: (context) => RepublicHomeCubit()),
          BlocProvider(
            create: (context) => StudentHomeCubit(RepositoryProvider.of<HomeRepository>(context)),
          ),
          BlocProvider(
            create: (context) =>
                StudentReservationListCubit(RepositoryProvider.of<HomeRepository>(context)),
          ),
          BlocProvider(
            create: (context) =>
                ProfileCubit(profileRepository: RepositoryProvider.of<ProfileRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'User Type App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
