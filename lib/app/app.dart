import 'package:firebase_auth/firebase_auth.dart';
import 'package:zc_dodiddone/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import 'package:zc_dodiddone/theme/theme.dart';
import '../pages/login_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService(); // Initialize your AuthService
  late User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    user = _authService.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: user == null ? const LoginPage() : const MainPage(),
    );
  }
}
