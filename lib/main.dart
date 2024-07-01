import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/db_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/home_screen.dart';
import 'package:play_dates/Screens/Onboarding/name_screen.dart';
import 'package:play_dates/Screens/Onboarding/welcome_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/repo/db_manager.dart';
import 'package:play_dates/firebase_options.dart';

final dbClient = DbClient();
final categoryRepo = DbManager(dbClient: dbClient);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Play Date',
      theme: ThemeData(
        fontFamily: 'Anon Grotesk',
        colorScheme: ColorScheme.fromSeed(seedColor: sbColor),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Anon Grotesk',
            color: sbColor,
            fontSize: 40,
            fontWeight: FontWeight.w600,
            wordSpacing: -1,
            height: 1.2,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Image.asset('assets/01.png'),
              ),
            );
          } else if (snapshot.hasData == true) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where("email", isEqualTo: snapshot.data!.email.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.docs.length == 1) {
                  return HomeScreen();
                } else {
                  return NameScreen();
                }
              },
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
