import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDateTime,
    required this.onDateTimeSelected,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime selectedDateTime;
  final Function(DateTime dateTime) onDateTimeSelected;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: 'Название задачи',
              ),
            ),
            TextField(
              controller: widget.descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание задачи',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Text(
                    'Дедлайн: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime ?? DateTime.now()),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedDateTime!),
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
                                widget.onDateTimeSelected(_selectedDateTime!);
                              });
                            }
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);

                      final title = widget.titleController.text;
                      final description = widget.descriptionController.text;
                      final deadline = _selectedDateTime;

                      FirebaseFirestore.instance.collection('tasks').add({
                        'title': title,
                        'description': description,
                        'deadline': Timestamp.fromDate(deadline!),
                        'completed': false,
                        'is_for_today': false,
                      }).then((value) {
                        // Handle successful task addition
                      }).catchError((error) {
                        print('Ошибка при добавлении задачи: $error');
                      });
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
  }
}