import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Screens/Profile/profile_screen.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/controllers/user_controller.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  const NavBar({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find();
    final icons = [
      "assets/profile_icon.png",
      "assets/play-icon.png",
      "assets/chat_icon.png",
      "assets/discover.png"
    ];
    final labels = ["profile", "quest", "chat", "Discover"];
    final width = MediaQuery.of(context).size.width - 72;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomAppBar(
          elevation: 0.0,
          padding: const EdgeInsets.all(0),
          child: Container(
            height: min(60, 60.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(
                  (12),
                ),
              ),
              border: Border(
                top: BorderSide(color: Colors.black),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(
                    icons[0],
                    label: (pageIndex != 0) ? labels[0] : "",
                    pageIndex == 0,
                    onTap: () {
                      Get.to(
                        () => const ProfileScreen(),
                      );
                    },
                  ),
                  navItem(
                    icons[1],
                    label: (pageIndex != 1) ? labels[1] : "",
                    pageIndex == 1,
                    onTap: () {
                      Get.offAll(() => const HomeScreen());
                    },
                  ),
                  navItem(
                    icons[2],
                    label: (pageIndex != 2) ? labels[2] : "",
                    pageIndex == 2,
                    onTap: () {
                      Get.to(
                        () => InboxScreen(
                          name: controller.user!.name,
                        ),
                      );
                    },
                  ),
                  navItem(
                    icons[3],
                    label: (pageIndex != 3) ? labels[3] : "",
                    pageIndex == 3,
                    onTap: () => {
                      Get.showSnackbar(const GetSnackBar(
                        message: "Comming Soon!",
                        duration: Duration(seconds: 2),
                      ))
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: pageIndex == 0 ? width / 8 - 20 : width / 4 + width / 8 - 16,
          child: _floatActnBtn(icons[pageIndex], labels[pageIndex]),
        )
      ],
    );
  }

  Widget navItem(String imagePath, bool selected,
      {Function()? onTap, String label = ""}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              color: Colors.black,
              fit: BoxFit.contain,
              height: min(24, 24.h),
            ),
            SizedBox(
              height: min(4, 4.h),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: min(14, 14.sp),
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatActnBtn(String icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.large(
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 244, 215, 56),
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.black,
              ),
            ),
            elevation: 10,
            hoverColor: Colors.black,
            hoverElevation: 20,
            child: Image.asset(
              icon,
              fit: BoxFit.fill,
              height: min(24, 24.h),
            ),
          ),
          SizedBox(
            height: min(2, 2.h),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: min(14, 14.sp),
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}
