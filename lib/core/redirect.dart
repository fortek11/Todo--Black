import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_black_todo/screens/login.dart';
import 'package:get_black_todo/screens/homepage.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.hasData) {
                //if user loged in
                return HomePage();
              } else {
                //is user not found
                return LoginPage();
              }
            }));
  }
}
