import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_black_todo/data/tasks.dart';
import 'package:get_black_todo/widgets/edit_product.dart';

class TaskDetail extends StatelessWidget {
  static const routeName = 'taskdetail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final taskProvider = Provider.of<TaskList>(context);
    final selectedTask =
        taskProvider.tasks.firstWhere((element) => element.id == id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Title: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      Text(selectedTask.title, style: TextStyle(fontSize: 18))),
              Text(
                " Description: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(selectedTask.description,
                      style: TextStyle(fontSize: 18))),
              Text(
                " Date and Time: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                      '${DateFormat.yMMMd().add_jm().format(selectedTask.time)}',
                      style: TextStyle(fontSize: 18))),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(selectedTask.imageUrl)),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: new EditProduct(
                      id,
                      selectedTask.title,
                      selectedTask.description,
                      selectedTask.time,
                      TimeOfDay.fromDateTime(selectedTask.time)),
                );
              });
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
