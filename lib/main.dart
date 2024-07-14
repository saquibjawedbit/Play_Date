import 'package:db_client/db_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Onboarding/loading_screen.dart';
import 'package:play_dates/Screens/Onboarding/name_screen.dart';
import 'package:play_dates/Screens/Onboarding/welcome_screen.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/repo/db_manager.dart';
import 'package:play_dates/controllers/user_controller.dart';
import 'package:play_dates/firebase_options.dart';
import 'dart:math';

final dbClient = DbClient();
final categoryRepo = DbManager(dbClient: dbClient);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final UserController userController = Get.put(UserController());

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
              userController.getUser();
              return Obx(() {
                if (userController.loading.value == true) {
                  return const LoadingScreen();
                } else if (userController.user != null) {
                  return const HomeScreen();
                } else {
                  return NameScreen();
                }
              });
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}
