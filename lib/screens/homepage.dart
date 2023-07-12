import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_black_todo/data/tasks.dart';
import 'package:get_black_todo/screens/profile_dashboard.dart';
import 'package:get_black_todo/screens/search.dart';
import 'package:get_black_todo/widgets/add_task.dart';
import 'package:get_black_todo/widgets/completed_tasks.dart';
import 'package:get_black_todo/widgets/incomplete_tasks.dart';

import '../widgets/main_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskListData = Provider.of<TaskList>(context);

    return Scaffold(
      drawer: Drawer(child: MainDrawer()),
      appBar: AppBar(
        title: const Text('Black\'s Task'),
        actions: [
          IconButton(
              onPressed: () {
                //navigate to search screen
                Navigator.of(context).pushNamed(SeachPage.routeName);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: InkWell(
              onTap: () {
                //navigate to profile screen
                Navigator.of(context).pushNamed(ProfileDashboard.routeName);
              },
              splashColor: Colors.white,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: taskListData.firebaseTasks(),
          builder: (context, snapshot) {
            //get data as snapshots
            return taskListData.tasks.isEmpty
                ? //if no tasks
                const Center(
                    child: Text(
                      "No Tasks Yet!",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : //else
                SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(children: [
                            SizedBox(
                              height: 10,
                            ),
                            if (taskListData.incompleteTask.isNotEmpty)
                              InCompleteTasks(),
                            if (taskListData.CompleteTask.isNotEmpty)
                              CompletedTasks()
                          ]),
                        )
                      ],
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            //add task screen
            showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (_) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [AddTask()],
                      ),
                    ),
                  );
                });
          },
          label: const Row(
            children: [
              Text(
                'New Task',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
              ),
            ],
          )),
    );
  }
}
