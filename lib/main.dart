import 'package:flutter/material.dart';

import 'package:pawfect_bites/selectservicescreen.dart';
import 'package:pawfect_bites/sqldb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  final Color appColor = const Color.fromRGBO(255, 212, 197, 1);
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: appColor,
        ),
        home: const SelectServiceScreen());
  }
}
