import 'package:flutter/material.dart';
import 'package:loca_student/app_widget.dart';
import 'package:loca_student/data/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await APIService.initializeParse();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWidget();
  }
}
