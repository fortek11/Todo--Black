import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_black_todo/data/tasks.dart';

import '../data/task.dart';
import '../widgets/task_tile.dart';
//search page

class SeachPage extends StatefulWidget {
  static const routeName = 'searchpage';

  @override
  State<SeachPage> createState() => _SeachPageState();
}

class _SeachPageState extends State<SeachPage> {
  String searched = '';
  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TaskList>(context);

    List<Task> searchedTasks(insertedTask) {
      //updates list
      if (insertedTask == '' || insertedTask == null) {
        return tasksProvider.tasks;
      } else {
        return tasksProvider.tasks
            .where((element) => element.title
                .toLowerCase()
                .contains(insertedTask.toLowerCase()))
            .toList();
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  searched = value;
                });
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedTasks(searched).length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: searchedTasks(searched)[index],
                      child: const TaskTile(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
