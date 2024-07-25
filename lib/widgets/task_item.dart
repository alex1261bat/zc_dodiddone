import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируем пакет для форматирования даты

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;

  const TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
  }) : super(key: key);

  // Функция для определения цвета градиента
  Color getGradientColor() {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays <= 1) {
      return Colors.red; // Срочная задача
    } else if (difference.inDays <= 2) {
      return Colors.yellow; // Задача средней срочности
    } else {
      return Colors.green; // Несрочная задача
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Используем Container для создания градиента
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  getGradientColor(), // Цвет градиента
                  Colors.white, // Белый цвет
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Цвет текста
                    ),
                  ),
                ),
                // Добавляем колонку с кнопками
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Обработка нажатия на кнопку "Редактировать"
                        print('Редактировать задачу: $title');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        // Обработка нажатия на кнопку "Удалить"
                        print('Удалить задачу: $title');
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ), // Text
                const SizedBox(height: 8),
                Text(
                  'Дедлайн: $formattedDeadline', // Используем отформатированную дату
                  style: const TextStyle(fontSize: 14),
                ), // Text
              ],
            ),
          )
        ],
      ),
    );
  }
}
