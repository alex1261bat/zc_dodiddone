import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class ForTodayPage extends StatefulWidget {
  const ForTodayPage({Key? key}) : super(key: key);

  @override
  State<ForTodayPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<ForTodayPage> {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          tasksCollection.where('is_for_today', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка при получении данных');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty) {
          return const Center(
              child: Text(
                  'Нет задач, время отдыхать... \n или создать новую задачу?'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            return TaskItem(
                title: taskData['title'],
                description: taskData['description'],
                deadline: (taskData['deadline'] as Timestamp).toDate(),
                toLeft: () {
                  tasksCollection.doc(tasks[index].id).update({
                    'completed': false,
                    'is_for_today': false,
                  });
                },
                toRight: () {
                  tasksCollection
                      .doc(tasks[index].id)
                      .update({'is_for_today': false, 'completed': true});
                });
          }
        );
      }
    );
  }
}
