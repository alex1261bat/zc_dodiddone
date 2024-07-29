import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируем пакет для форматирования даты
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_widget.dart'; // Импортируем FirebaseFirestore

class TaskItem extends StatefulWidget {
  String title;
  String description;
  DateTime deadline;
  final String documentId; // Добавляем ID документа
  final Function? toLeft;
  final Function? toRight;

  TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.documentId, // Передаем ID документа
    this.toLeft,
    this.toRight,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  // Удалите эти строки:
  // DateTime? get deadline => null;
  // String? get title => null;
  // get toLeft => null;
  // get toRight => null;
  // get documentId => null;
  // get description => null;

  // Функция для обновления задачи
  void _updateTask(DateTime newDeadline) {
    setState(() {
      widget.deadline = newDeadline;
    });
  }

  // Функция для определения цвета градиента
  Color getGradientColor() {
    final now = DateTime.now();
    final difference = widget.deadline.difference(now);

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
    final formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(widget.deadline);

    return Dismissible(
      key: Key(widget.title), // Устанавливаем уникальный ключ для Dismissible
      background: Container(
        color: Colors.green,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.toLeft?.call(); //Вызываем функцию, если элемент был сдвинут влево
        } else if (direction == DismissDirection.startToEnd) {
          widget.toRight?.call(); //Вызываем функцию, если элемент был сдвинут вправо
        }
      },
      child: Card(
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
                      widget.title,
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final titleController =
                                  TextEditingController(text: widget.title); // Инициализация titleController
                              final descriptionController =
                                  TextEditingController(text: widget.description); // Инициализация descriptionController
                              DateTime _selectedDateTime = widget.deadline;

                              return EditWidget(
                                titleController: titleController,
                                descriptionController: descriptionController,
                                selectedDateTime: _selectedDateTime,
                                onDateTimeSelected: (DateTime dateTime) {
                                  setState(() {
                                    _selectedDateTime = dateTime;
                                  });
                                },
                                taskDocumentId: widget.documentId,
                                initialTitle: widget.title, // Передача widget.title
                                initialDescription: widget.description, // Передача widget.description
                                initialDeadline: widget.deadline,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // Удаление задачи из Firestore
                          FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.documentId)
                              .delete()
                              .then((value) => print('Задача удалена'))
                              .catchError((error) =>
                                  print('Ошибка при удалении: $error'));
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
                    widget.description,
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
      ),
    );
  }
}
