import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_home_cubit.dart';
import 'package:loca_student/bloc/home/republic/student_interested_list_cubit.dart';
import 'package:loca_student/bloc/home/republic/tenant_list_cubit.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'package:loca_student/ui/home/pages/home_page.dart';
import 'package:loca_student/ui/theme/app_theme.dart';
import 'package:loca_student/ui/user_type/pages/user_type_page.dart';
import 'package:loca_student/utils/convert_data.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Widget? _initialPage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialPage();
  }

  Future<void> _loadInitialPage() async {
    final authRepo = AuthRepository();
    final isLogged = await authRepo.isLoggedIn();

    if (isLogged) {
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      final userType = currentUser?.get<String>('userType');

      if (userType != null) {
        _initialPage = HomePage(userType: stringToUserType(userType));
      } else {
        _initialPage = const UserTypePage();
      }
    } else {
      _initialPage = const UserTypePage();
    }

    // Força pelo menos 300ms para exibir o loader visualmente
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() => _isLoading = false);
  }

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
          BlocProvider(create: (_) => UserTypeCubit()),
          BlocProvider(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
              userTypeCubit: context.read<UserTypeCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => UserRegisterBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (_) => RepublicHomeCubit()),
          BlocProvider(create: (context) => StudentHomeCubit(context.read<HomeRepository>())),
          BlocProvider(
            create: (context) => StudentReservationListCubit(context.read<HomeRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(profileRepository: context.read<ProfileRepository>()),
          ),
          BlocProvider(create: (context) => InterestStudentsCubit(context.read<HomeRepository>())),
          BlocProvider(create: (context) => TenantListCubit(context.read<HomeRepository>())),
        ],
        child: MaterialApp(
          title: 'Loca Student',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          home: _isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : _initialPage!,
        ),
      ),
    );
  }
}
