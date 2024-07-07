import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 228),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => const HomeScreen());
          },
          icon: const Icon(
            Icons.close_sharp,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status",
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontSize: min(32.sp, 32),
                fontWeight: FontWeight.w600,
              ),
            ),
            const LeaderBoardTile(
              title: "Current Match: ",
              titleColor: Colors.black,
              trailing: "Vanshika",
              leadingColor: Color.fromARGB(255, 146, 97, 53),
              iconPath: "assets/medal-star.png",
            ),
            const LeaderBoardTile(
              title: "Players: ",
              titleColor: Colors.black,
              trailing: "15",
              leadingColor: Color.fromARGB(204, 21, 21, 21),
              iconPath: "assets/user-big-group.png",
            ),
            SizedBox(
              height: 20.h,
            ),
            AutoSizeText(
              "Rankings",
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontSize: min(32, 32.sp),
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  Color color = Colors.black;
                  if (index == 0) {
                    color = const Color.fromARGB(255, 226, 177, 52);
                  } else if (index == 1) {
                    color = const Color.fromARGB(255, 150, 162, 174);
                  } else if (index == 2) {
                    color = const Color.fromARGB(255, 174, 129, 61);
                  }
                  return PlayListTile(
                    index: index,
                    color: color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayListTile extends StatelessWidget {
  const PlayListTile({
    super.key,
    required this.index,
    required this.color,
  });

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              (index + 1).toString(),
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: min(20, 20.sp),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5 * 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: color,
                  spreadRadius: 3,
                  offset: const Offset(4, 4),
                )
              ],
            ),
            child: CircleAvatar(
              backgroundImage: const NetworkImage(
                "https://images.unsplash.com/photo-1718963892270-04300c864522?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              ),
              maxRadius: min(16, 16.w),
            ),
          )
        ],
      ),
      title: Text(
        maxLines: 1,
        "Vanshika",
        style: TextStyle(
          color: color,
          fontSize: min(20, 20.sp),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: AutoSizeText(
        (index + 1).toString(),
        maxLines: 1,
        style: TextStyle(
          color: color,
          fontSize: min(20, 20.sp),
          fontWeight: FontWeight.w600,
        ),
      ),
      minVerticalPadding: 10,
      minTileHeight: 10,
    );
  }
}

class LeaderBoardTile extends StatelessWidget {
  const LeaderBoardTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.trailing,
    required this.titleColor,
    required this.leadingColor,
  });

  final String iconPath;
  final String title;
  final String trailing;
  final Color titleColor;
  final Color leadingColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(iconPath),
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: titleColor,
                  fontSize: min(24.sp, 24),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 100.w,
            child: Center(
              child: Text(
                trailing,
                maxLines: 1,
                style: TextStyle(
                  color: leadingColor,
                  fontSize: min(24, 24.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
