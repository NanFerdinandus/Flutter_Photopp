import 'package:flutter/material.dart';
import 'view/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Wijzigd hier de home naar LoginPage
      home: const LoginPage(),
    );
  }
}

