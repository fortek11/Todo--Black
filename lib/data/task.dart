import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Task with ChangeNotifier {
  final cred = FirebaseAuth.instance.currentUser!.email;
  final String id;
  final String title;
  final String description;
  final DateTime time;
  bool isCompleted;
  final String imageUrl;
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    required this.imageUrl,
  });

  void toogleIsCompleted() async {
    //switch icCompleted status for a task
    isCompleted = !isCompleted;
    //updating isCompleted on database
    await FirebaseFirestore.instance.collection('${cred}').doc(id).update(
        {'isCompleted': isCompleted}).then((value) => notifyListeners());
  }
}
