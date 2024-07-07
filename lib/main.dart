import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/db_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Onboarding/loading_screen.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Screens/Onboarding/name_screen.dart';
import 'package:play_dates/Screens/Onboarding/welcome_screen.dart';
import 'package:play_dates/Screens/Quiz/match_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/repo/db_manager.dart';
import 'package:play_dates/firebase_options.dart';
import 'dart:math';

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
    return ScreenUtilInit(
      designSize: const Size(415, 923),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleWH: () => true,
      builder: (context, child) => GetMaterialApp(
        title: 'Play Date',
        theme: ThemeData(
          fontFamily: 'Anon Grotesk',
          colorScheme: ColorScheme.fromSeed(seedColor: sbColor),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Anon Grotesk',
              color: sbColor,
              fontSize: min(40, 40.sp),
              fontWeight: FontWeight.w600,
              wordSpacing: -1,
              height: 1.2,
            ),
            displayMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: min(16, 16.sp),
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: min(24, 24.sp),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingScreen();
                  } else if (snapshot.hasData &&
                      snapshot.data?.docs.length == 1) {
                    return const MatchScreen();
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
      ),
    );
  }
}
