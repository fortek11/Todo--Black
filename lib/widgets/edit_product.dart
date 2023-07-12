import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/tasks.dart';
import 'alert_wrong_form.dart';

// ignore: must_be_immutable
class EditProduct extends StatefulWidget {
  final String id;
  DateTime taskDay;
  String title;
  String description;
  TimeOfDay taskTime;
  EditProduct(
      this.id, this.title, this.description, this.taskDay, this.taskTime);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String? title;
  String? desc;
  TimeOfDay? taskTime;
  DateTime? taskDay;
  @override
  void initState() {
    title = widget.title;
    desc = widget.description;
    taskTime = widget.taskTime;
    taskDay = widget.taskDay;
    super.initState();
  }

  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskList>(context);
    final imageUrl = taskProvider.tasks
        .firstWhere((element) => element.id == widget.id)
        .imageUrl;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new)),
              Text(
                'Edit',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              onChanged: (value) => title = value,
              initialValue: title,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: TextFormField(
              onChanged: (value) => desc = value,
              initialValue: desc,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Description'),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Text(DateFormat.yMMMd().format(taskDay!),
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 2,
                  ),
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      showDatePicker(
                              context: context,
                              initialDate: taskDay!,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2024))
                          .then((value) {
                        setState(() {
                          taskDay = value!;
                        });
                      });
                    },
                    icon: Icon(Icons.calendar_month),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Text(taskTime!.format(context).toString(),
                      style: TextStyle(fontSize: 17)),
                  SizedBox(
                    width: 2,
                  ),
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      showTimePicker(context: context, initialTime: taskTime!)
                          .then((value) {
                        setState(() {
                          taskTime = value!;
                        });
                      });
                    },
                    icon: Icon(Icons.access_time),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ]),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () async {
                if (widget.title == '' || widget.description == '') {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertThemWrongForm();
                      });
                  return;
                }
                final dateTimeFinal = DateTime(taskDay!.year, taskDay!.month,
                    taskDay!.day, taskTime!.hour, taskTime!.minute);

                taskProvider.editTask(
                    widget.id, title!, desc!, dateTimeFinal, imageUrl, context);
                print({
                  'title': title,
                  'description': desc,
                });
              },
              child: Text(
                "UPDATE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.bottomRight,
                  padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 100))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
