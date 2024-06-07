import 'package:flutter/material.dart';
import 'package:projek_akhir/view/login.dart';
import '../model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}