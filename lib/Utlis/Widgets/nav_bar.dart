import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
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
          child: Row(
            children: [
              navItem(
                "assets/profile_icon.png",
                "item 1",
                pageIndex == 0,
                onTap: () => onTap(0),
              ),
              navItem(
                "assets/profile_icon.png",
                "profile",
                pageIndex == 1,
                onTap: () => onTap(1),
              ),
              SizedBox(width: min(80, 80.w)),
              navItem(
                "assets/chat_icon.png",
                "chat",
                pageIndex == 2,
                onTap: () => onTap(2),
              ),
              navItem(
                "assets/chat_icon.png",
                "item 4",
                pageIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(String imagePath, String label, bool selected,
      {Function()? onTap}) {
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
}

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}
