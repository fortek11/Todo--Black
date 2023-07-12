import 'package:flutter/material.dart';

import '../screens/profile_dashboard.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/Colorful_Sound_Waves_Music_App_Logo.png',
                fit: BoxFit.fill),
          ),
          const Divider(
            color: Colors.black,
            indent: 15,
            endIndent: 15,
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Made By Darshan Wadhva"),
                      content: Text("Visit https//fortek.in for more"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'))
                      ],
                    );
                  });
            },
            leading: const Icon(
              Icons.info_rounded,
              size: 28,
              color: Colors.black,
            ),
            title: const Text(
              "Details",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileDashboard.routeName);
            },
            leading: const Icon(
              Icons.account_box,
              size: 28,
              color: Colors.black,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
