import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_black_todo/data/task.dart';
import 'package:get_black_todo/data/tasks.dart';
import 'package:get_black_todo/screens/task_details.dart';
import 'package:get_black_todo/widgets/alert_widget.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTask = Provider.of<Task>(context);
    final tasks = Provider.of<TaskList>(context);

    final Duration duration = selectedTask.time.difference(DateTime.now());

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, TaskDetail.routeName,
              arguments: selectedTask.id);
        },
        leading: IconButton(
          icon: selectedTask.isCompleted
              ? Icon(Icons.radio_button_checked)
              : Icon(Icons.radio_button_off),
          onPressed: () {
            selectedTask.toogleIsCompleted();
            tasks.notifyAllListeners();
          },
        ),
        title: Text(
          selectedTask.title,
          style: selectedTask.isCompleted
              ? const TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey)
              : const TextStyle(),
        ),
        subtitle: Text(selectedTask.isCompleted
            ? 'Task Completed'
            : duration >= Duration(days: 2)
                ? 'Time Remaining: ${duration.inDays} Days'
                : duration >= Duration(hours: 2)
                    ? 'Time Remaining: ${duration.inHours} Hours'
                    : duration >= Duration(minutes: 0)
                        ? 'Time Remaining: ${duration.inMinutes} Mins'
                        : 'Time Remaining: Time Over'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            tasks.deleteTask(selectedTask.id);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertThem();
                });
          },
        ),
      ),
    );
  }
}
