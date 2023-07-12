import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_black_todo/main.dart';

//profile screen
class ProfileDashboard extends StatelessWidget {
  static const routeName = 'profile';
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return user == null
        ? Scaffold()
        : Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Logged In As: ${user.email}'),
                    IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShopApp();
                          }));
                        },
                        icon: const CircleAvatar(
                          child: Icon(Icons.logout),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
