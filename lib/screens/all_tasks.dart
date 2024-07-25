import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<String> _tasks = [
    'Купить продукты',
    'Записаться на прием к врачу',
    'Позвонить маме',
    'Сделать уборку',
    'Прочитать книгу',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          title: _tasks[index],
          description: 'Описание задачи',
          deadline: DateTime.now(),
        );
      },
    );
  }
}
