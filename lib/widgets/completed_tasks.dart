import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_black_todo/widgets/task_tile.dart';
import '../data/tasks.dart';

class CompletedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskList>(context).CompleteTask;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Completed Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              ' (${tasks.length})',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            // Icon(Icons.keyboard_double_arrow_down_sharp),
            // Expanded(
            //   child: Divider(
            //     color: Colors.grey,
            //   ),
            // )
          ],
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: tasks[index],
                child: const TaskTile(),
              );
            }),
      ],
    );
  }
}
