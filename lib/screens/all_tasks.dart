import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: tasksCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка при получении данных');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            return TaskItem(
              title: taskData['title'],
              description: taskData['description'],
              deadline: (taskData['deadline'] as Timestamp).toDate(),
            );
          },
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';

// import '../widgets/task_item.dart';

// class TaskPage extends StatefulWidget {
//   const TaskPage({Key? key}) : super(key: key);

//   @override
//   State<TaskPage> createState() => _TaskPageState();
// }

// class _TaskPageState extends State<TaskPage> {
//   final List<String> _tasks = [
//     'Купить продукты',
//     'Записаться на прием к врачу',
//     'Позвонить маме',
//     'Сделать уборку',
//     'Прочитать книгу',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _tasks.length,
//       itemBuilder: (context, index) {
//         return TaskItem(
//           title: _tasks[index],
//           description: 'Описание задачи',
//           deadline: DateTime.now(),
//         );
//       },
//     );
//   }
// }
