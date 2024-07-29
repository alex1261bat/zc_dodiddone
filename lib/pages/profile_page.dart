import 'package:flutter/material.dart';
import 'package:zc_dodiddone/screens/profile.dart';
import '../theme/theme.dart';
// Импортируем AuthenticationService

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0,
      ), // AppBar
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  DoDidDoneTheme.lightTheme.colorScheme.primary,
                ],
                stops: const [0.1, 0.9], // Основной цвет занимает 90%
              ),
            ),
            child: Profile()),
      ),
    );
  }
}
