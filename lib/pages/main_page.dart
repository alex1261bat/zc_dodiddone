import 'package:flutter/material.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';
import '../screens/profile_page.dart';
import '../theme/theme.dart';
import 'package:intl/intl.dart'; // Импортируем пакет для форматирования даты

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskPage(),
    Text('Сегодня'),
    Text('Выполнено'),
    ProfilePage()
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Устанавливаем ширину диалогового окна
          insetPadding: const EdgeInsets.symmetric(horizontal: 16), // Отступ от краев экрана
          child: Container(
            width: 400, // Ширина диалогового окна
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Название задачи',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Описание задачи',
                  ),
                ),
                // Используем кнопку вместо текстового поля для дедлайна
                Padding(
                  padding: const EdgeInsets.only(top: 16), // Отступ сверху
                  child: ElevatedButton(
                    onPressed: () {
                      // Открываем showDateTimePicker
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          // Если выбрана дата, открываем TimePicker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                            // Устанавливаем формат времени в 24 часа
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          ).then((pickedTime) {
                            if (pickedTime != null) {
                              setState(() {
                                _selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.secondary, // Цвет secondary
                    ),
                    child: Text(
                      'Выбрать дедлайн ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}', // Добавили текущую дату и время
                      style: TextStyle(color: Colors.white), // Белый текст
                    ),
                  ),
                ),
                // Добавляем кнопки "Отмена" и "Добавить"
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Выравниваем кнопки справа
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Обработка добавления задачи
                          // Используйте _selectedDateTime для получения выбранной даты и времени
                          Navigator.of(context).pop();
                        },
                        child: const Text('Добавить'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      ),
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
              ? const ProfilePage() // Если да, отображаем profile_page
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
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
