import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_black_todo/data/tasks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_black_todo/core/redirect.dart';
import 'package:get_black_todo/screens/profile_dashboard.dart';
import 'package:get_black_todo/screens/search.dart';
import 'package:get_black_todo/screens/task_details.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //provider state management
        ChangeNotifierProvider(
          create: (context) => TaskList(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black, primary: Colors.black),
            textTheme: GoogleFonts.poppinsTextTheme(
              Typography.blackCupertino,
            )),
        home: const Redirect(),
        routes: {
          ProfileDashboard.routeName: (context) => ProfileDashboard(),
          TaskDetail.routeName: (context) => TaskDetail(),
          SeachPage.routeName: (context) => SeachPage(),
        },
      ),
    );
  }
}
