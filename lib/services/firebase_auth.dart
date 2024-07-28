import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Объект для работы с Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Метод для регистрации с помощью электронной почты и пароля
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, {required bool sendEmailVerification}) async {
    try {
      // Регистрация пользователя
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Отправка запроса на подтверждение почты
      //await result.user!.sendEmailVerification();
      // Возвращение объекта UserCredential
      return result;
    } catch (e) {
      // Обработка ошибок
      print(e.toString());
      rethrow;
    }
  }

  // Метод для входа с помощью электронной почты и пароля
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Вход пользователя
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Возвращение объекта UserCredential
      return result;
    } catch (e) {
      // Обработка ошибок
      print(e.toString());
      rethrow;
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    try {
      // Выход из Firebase
      await _auth.signOut();
      // Выход из Google
    } catch (e) {
      // Обработка ошибок
      print(e.toString());
      rethrow;
    }
  }
}
