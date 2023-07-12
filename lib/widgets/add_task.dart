import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:get_black_todo/data/tasks.dart';
import 'package:get_black_todo/widgets/alert_wrong_form.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? title;
  String? desc;
  DateTime? taskDay;
  TimeOfDay? tasktime;
  bool datePicked = false;
  bool timePicked = false;
  bool isUploading = false;
  final DateTime timeNow = DateTime.now();

  File? _pickedImageFile;
  String? imageUrl;

  Widget build(BuildContext context) {
    final cred = FirebaseAuth.instance.currentUser!.email;
    final tasksProvider = Provider.of<TaskList>(context);
    void _pickimage() async {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(cred.toString())
          .child('${timeNow.toString()}.jpg');

      try {
        await storageRef.putFile(_pickedImageFile!).then((p0) {
          setState(() {
            isUploading = false;
          });
        });
      } catch (e) {
        setState(() {
          isUploading = false;
        });
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text("Failed, Please Try Again"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            });
      }
      imageUrl = await storageRef.getDownloadURL();
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text(
                'New Task',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          Form(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    onChanged: (value) => title = value,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Title'),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    onChanged: (value) => desc = value,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Description'),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Text(
                                !datePicked
                                    ? 'Pick a Date'
                                    : DateFormat.yMMMd().format(taskDay!),
                                style: TextStyle(fontSize: 16)),
                            SizedBox(
                              width: 2,
                            ),
                            IconButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(Duration(days: 2)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2024))
                                    .then((value) {
                                  taskDay = value!;
                                  setState(() {
                                    datePicked = true;
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
                            Text(
                                !timePicked
                                    ? 'Pick a Time'
                                    : tasktime!.format(context).toString(),
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              width: 2,
                            ),
                            IconButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  tasktime = value!;
                                  setState(() {
                                    timePicked = true;
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
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isUploading = true;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                          _pickimage();
                        },
                        icon: CircleAvatar(
                            backgroundColor: Colors.black,
                            foregroundImage: _pickedImageFile != null
                                ? FileImage(_pickedImageFile!)
                                : null,
                            child: Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            )),
                        style: IconButton.styleFrom(),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                          _pickedImageFile == null
                              ? 'Upload an Image'
                              : 'Replace Image',
                          style: TextStyle(fontSize: 17)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (title == null ||
                          desc == null ||
                          taskDay == null ||
                          tasktime == null ||
                          _pickedImageFile == null) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertThemWrongForm();
                            });
                        return;
                      }

                      final dateTimeFinal = DateTime(
                          taskDay!.year,
                          taskDay!.month,
                          taskDay!.day,
                          tasktime!.hour,
                          tasktime!.minute);
                      print(title);
                      tasksProvider.addTask(timeNow.toString(), title!, desc!,
                          dateTimeFinal, imageUrl!, context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: isUploading
                        ? Container(
                            width: 200, child: const LinearProgressIndicator())
                        : const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 90),
                            child: Text('Submit',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ))
              ],
            ),
          )),
        ],
      ),
    );
  }
}
