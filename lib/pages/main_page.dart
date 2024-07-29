import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/profile_page.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';
import '../screens/completed.dart';
import '../screens/for_today.dart';
import '../theme/theme.dart';

import '../widgets/dialog_widget.dart'; // Импортируем FirebaseFirestore

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskPage(),
    ForTodayPage(),
    CompletedPage(),
    //ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Переменная для хранения выбранной даты и времени
  DateTime _selectedDateTime = DateTime.now();

  // Функция для открытия диалогового окна
  void _showAddTaskDialog() {
    // Создаем контроллеры для текстовых полей
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          titleController: titleController,
          descriptionController: descriptionController,
          selectedDateTime: _selectedDateTime,
          onDateTimeSelected: (DateTime dateTime) {
            setState(() {
              _selectedDateTime = dateTime;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // Убираем тень
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person_2, color: Colors.white)),
          ]),
      body: Container(
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
        child: Center(
          child: _selectedIndex == 3 // Проверяем, выбран ли профиль
              ? ProfilePage() // Если да, отображаем profile_page
              : _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Профиль',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Цвет фона
        // Добавляем тему для BottomNavigationBar
        type: BottomNavigationBarType.fixed,
        // Устанавливаем цвет иконок в основной цвет
        // Используем Theme.of(context).colorScheme.primary для получения основного цвета
        // из текущей темы приложения
        fixedColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
