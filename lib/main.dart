import 'package:flutter/material.dart';
import 'package:loca_student/app_widget.dart';
import 'package:loca_student/utils/parse_configs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ParseConfigs.initializeParse();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWidget();
  }
}
