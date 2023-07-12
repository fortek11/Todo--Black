import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as db;
import 'package:flutter/material.dart';
import 'package:get_black_todo/data/task.dart';
import 'package:get_black_todo/widgets/alert_add_task.dart';
import 'package:get_black_todo/widgets/alert_task_edited.dart';

class TaskList with ChangeNotifier {
  final cred = FirebaseAuth.instance.currentUser!.email;
  //tasks
  List<Task> _tasks = [
    //scoped this list, couldnt edit from any other file code
    Task(
        id: DateTime.now().toString(),
        title: 'TestProvider ',
        description: 'This Task is not on Firebase',
        time: DateTime.now().add(Duration(days: 2)),
        imageUrl: 'https://fortek.in/wp-content/uploads/2022/11/tf-logo2.jpg')
  ];

  List<Task> get tasks {
    //this list would be accessible by any file
    return [..._tasks];
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  Future firebaseTasks() async {
    //initialize on every snapshot
    _tasks.clear();
    try {
      //read data from database
      await FirebaseFirestore.instance
          .collection('${cred}')
          .get()
          .then(
            (value) => value.docs.forEach((element) {
              Map<String, dynamic> data = element.data();
              _tasks.insert(
                  //recently added task's at the top
                  0,
                  Task(
                    id: element.reference.id,
                    title: data['title'],
                    description: data['description'],
                    time: data['time'].toDate(),
                    isCompleted: data['isCompleted'],
                    imageUrl: data['imageUrl'],
                  ));
            }),
          )
          .then((value) {});
    } catch (e) {
      print('errrror' + e.toString());
    }
  }

  List<Task> get incompleteTask {
    return [..._tasks.where((element) => element.isCompleted == false)];
  }

  List<Task> get CompleteTask {
    return [..._tasks.where((element) => element.isCompleted == true)];
  }

  void deleteTask(String id) async {
    //delete task on database
    await FirebaseFirestore.instance.collection(cred!).doc(id).delete();
    final storageRef = db.FirebaseStorage.instance
        .ref()
        .child(cred.toString())
        .child('${id}.jpg');
    notifyListeners();
    //deleting image from Storage (firebase)
    await storageRef.delete();
  }

  void addTask(String timenow, String title, String desc, DateTime time,
      String imageUrl, BuildContext ctx) async {
    // getUserLocation().then((value) {
    //   print(value.latitude.toString() + 'hahah' + value.longitude.toString());
    // });

    //writing task on database

    await FirebaseFirestore.instance
        .collection(cred!)
        .doc(timenow)
        .set({
          'title': title,
          'description': desc,
          'time': time,
          'imageUrl': imageUrl,
          'isCompleted': false
        })
        .then((value) {
          //for debugging
          print('done');
        })
        .then((value) => showDialog(
            context: ctx,
            builder: (_) {
              return AlertThemTaskAdded();
            }))
        .catchError((error) => showDialog(
            context: ctx,
            builder: (_) {
              return AlertDialog(
                content: Text('Failed, Try Again Later'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"))
                ],
              );
            }));
    Navigator.of(ctx).pop();
    notifyListeners();
  }

  void editTask(String id, String title, String description, DateTime time,
      String imageUrl, BuildContext ctx) async {
    //updating the task
    await FirebaseFirestore.instance
        .collection(cred!)
        .doc(id)
        .delete()
        .then(await FirebaseFirestore.instance
            .collection(cred!)
            .doc(id)
            .set({
              'title': title,
              'description': description,
              'time': time,
              'imageUrl': imageUrl,
              'isCompleted': false
            })
            .then((value) {
              //for debugging
              print('done');
            })
            .then((value) => showDialog(
                context: ctx,
                builder: (_) {
                  //Navigator.of(ctx).pushNamed('/');
                  return AlertTaskEdited();
                }))
            .catchError((error) => showDialog(
                context: ctx,
                builder: (_) {
                  return AlertDialog(
                    content: Text('Failed, Try Again Later'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("OK"))
                    ],
                  );
                })));

    notifyListeners();
  }
}
