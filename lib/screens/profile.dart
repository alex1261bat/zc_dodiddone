import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../services/firebase_auth.dart'; // Импортируем AuthenticationService

class Profile extends StatefulWidget {
  const Profile({super.key});
  
  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  final AuthService _authService = AuthService(); // Создаем экземпляр сервиса
  String? _userEmail;
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    // Получаем данные пользователя при инициализации
    _userEmail = _authService.currentUser?.email;
    _userPhotoUrl = _authService.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          CircleAvatar(
            radius: 50,
            backgroundImage: _userPhotoUrl != null
                ? NetworkImage(_userPhotoUrl!)
                : const AssetImage('assets/profile.png'),
          ),
          const SizedBox(height: 20),
          // Почта
          Text(
            _userEmail ?? 'example@email.com', // Замените на реальную почту пользователя
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (_authService.currentUser!.emailVerified == false)
            ElevatedButton(
              onPressed: () async {
                // Обработка отправки запроса подтверждения почты
                try {
                  await _authService.currentUser!.sendEmailVerification();
                  // Показать диалог с сообщением о том, что письмо отправлено
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Подтверждение почты'),
                      content: const Text(
                          'Письмо с подтверждением отправлено на ваш адрес.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                            builder:(context) => const LoginPage())),
                       child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                } catch (e) {
                  // Обработка ошибки
                  print('Ошибка отправки письма: $e');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Ошибка'),
                      content: const Text('Не удалось отправить письмо.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),
          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              // Обработка выхода из профиля
              // Например, можно перейти на страницу входа
              await _authService.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
