import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login/login_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_cubit.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_cubit.dart';
import 'package:loca_student/bloc/student-home/filtered_republic_list_cubit.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:loca_student/data/repositories/student_home_repository.dart';
import 'package:loca_student/ui/student-home/pages/student_home_page.dart';
import 'package:loca_student/ui/republic-home/pages/republic_home_page.dart';
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
      final userTypeStr = currentUser?.get<String>('userType');
      final userType = userTypeStr != null ? stringToUserType(userTypeStr) : null;

      if (userType == UserType.student) {
        _initialPage = const StudentHomePage();
      } else if (userType == UserType.republic) {
        _initialPage = const RepublicHomePage();
      } else {
        // fallback caso userType esteja errado
        _initialPage = const UserTypePage();
      }
    } else {
      _initialPage = const UserTypePage();
    }

    // Para dar um tempo de loader
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => StudentHomeRepository()),
        RepositoryProvider(create: (_) => RepublicHomeRepository()),
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
          BlocProvider(
            create: (context) => FilteredRepublicListCubit(context.read<StudentHomeRepository>()),
          ),
          BlocProvider(
            create: (context) => StudentReservationListCubit(context.read<StudentHomeRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(profileRepository: context.read<ProfileRepository>()),
          ),
          BlocProvider(
            create: (context) => InterestStudentListCubit(context.read<RepublicHomeRepository>()),
          ),
          BlocProvider(
            create: (context) => TenantListCubit(context.read<RepublicHomeRepository>()),
          ),
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
