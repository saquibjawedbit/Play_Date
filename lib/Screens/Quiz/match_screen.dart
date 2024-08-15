import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/chat_screen.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Screens/Quiz/leaderboard_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/result_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/Utlis/Widgets/custom_dialog_box.dart';
import 'package:play_dates/Utlis/Widgets/nav_bar.dart';
import 'package:play_dates/controllers/user_controller.dart';
import 'package:play_dates/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({
    super.key,
    required this.round,
  });

  final String round;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late bool match;

  UserModel? user;

  final UserController userController = Get.find();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() async {
    userController.todaysQuest += 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("todaysQuest", userController.todaysQuest);
  }

  void _chat() async {
    ContactModel newChat = ContactModel(
      uid: user!.id,
      name: user!.name,
      profileUrl: user!.imageUrls[0],
      isSeen: false,
      lastMessageTime: Timestamp.now(),
      lastMessage: "Say Hi",
    );
    categoryRepo.addFriend('user', userController.user!.id!, 'contacts',
        user!.id!, newChat.toMap());
    Get.offAll(() => const HomeScreen());
    Get.to(
      () => InboxScreen(
        name: userController.user!.name,
      ),
    );
    Get.to(
      () => ChatScreen(
        contact: newChat,
        openCamera: false,
      ),
    );
  }

  void _loadData(ResultModel result) async {
    List<Player> matches = result.matches;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    for (Player player in matches) {
      if (player.femaleId == uid) {
        user = await categoryRepo.fetchUser(id: player.maleId!);
        break;
      }
      if (player.maleId == uid) {
        if (player.femaleId == null) continue;
        user = await categoryRepo.fetchUser(id: player.femaleId!);
        break;
      }
    }
    if (user == null) {
      match = false;
    } else {
      match = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: sandColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 36,
          ),
          child: Center(
            child: StreamBuilder<ResultModel>(
                stream: categoryRepo.fetchPlayers(
                  id: "${DateTime.now().year}y${DateTime.now().month}m${DateTime.now().day}",
                  clgName: userController.user!.address,
                  round: widget.round,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasData == false) {
                    return const CircularProgressIndicator.adaptive();
                  }

                  _loadData(snapshot.data!);

                  return Column(
                    children: [
                      const AppTitle(),
                      SizedBox(
                        height: min(24, 24.h),
                      ),
                      if (match)
                        RichText(
                          text: TextSpan(
                            text: "It's a ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: min(40, 40.sp),
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Match!",
                                style: TextStyle(
                                  fontSize: min(56, 56.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!match)
                        Text(
                          "You couldn't find a match",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: min(36, 36.sp),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: min(18, 18.h),
                      ),
                      if (match) matchWidget(),
                      if (!match)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/02.png",
                                height: min(200, 200.h),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: min(10, 10.h),
                              ),
                              Text(
                                "But your match might be just around the corner",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: min(18, 18.sp),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: min(40, 40.h),
                      ),
                      if (match)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: _chat,
                              child: horButton(
                                "Chat",
                                const Color.fromARGB(255, 127, 159, 188),
                                min(164, 164.w),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomDialogBox(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 12),
                                    content: premiumDialogBox(),
                                  ),
                                );
                              },
                              child: horButton(
                                "Swap",
                                const Color.fromARGB(255, 255, 102, 102),
                                min(164.w, 164),
                              ),
                            ),
                          ],
                        ),
                      if (match)
                        const SizedBox(
                          height: 20,
                        ),
                      GestureDetector(
                        onTap: () {
                          final ResultModel result = snapshot.data!;

                          Get.to(
                            () => LeaderBoardScreen(
                              result: result,
                              matchedName: user?.name,
                            ),
                          );
                        },
                        child: horButton(
                          "View Leaderboard",
                          const Color.fromARGB(255, 244, 215, 56),
                          200,
                          fontSize: 16,
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
        bottomNavigationBar: const NavBar(pageIndex: 1),
      ),
    );
  }

  Stack matchWidget() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              profileImage(userController.user!.imageUrls[0]),
              SizedBox(
                height: min(10, 10.h),
              ),
              Text(
                userController.user!.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(32, 32.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: min(100, 100.h),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              Text(
                user!.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(32, 32.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: min(10, 10.h),
              ),
              profileImage(user!.imageUrls[0]),
            ],
          ),
        ),
      ],
    );
  }

  Column premiumDialogBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedText(
          text: "Want more Swaps?",
          fontSize: min(31, 31.sp),
          textColor: const Color.fromARGB(255, 255, 208, 0),
          borderColor: Colors.black,
          offset: const Offset(2, 5),
        ),
        SizedBox(
          height: min(20, 20.h),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Buy ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
            SizedBox(
              width: min(150, 150.w),
              child: const FittedBox(
                child: AppTitle(),
              ),
            ),
            Text(
              "    premium",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "At just",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
            Text(
              " Rs 99.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: min(36, 36.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container horButton(String text, Color color, double? width,
      {double fontSize = 28}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 12,
      ),
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2.0),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.black,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: SizedBox(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: min(fontSize, fontSize.sp),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Container profileImage(String link) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              offset: Offset(5, 2),
            )
          ]),
      child: CircleAvatar(
        backgroundImage: NetworkImage(link),
        radius: min(96, 96.sp),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 27, 55),
        border: Border.all(color: Colors.black, width: 5.0),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: FittedBox(
        child: OutlinedText(
          text: "playDates.",
          textColor: const Color.fromARGB(255, 235, 240, 0),
          fontSize: min(64, 64.sp),
          borderColor: Colors.black,
          offset: const Offset(2, 2),
        ),
      ),
    );
  }
}
