import 'package:flutter/material.dart';

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
          height: 60,
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
                Icons.home_outlined,
                pageIndex == 0,
                onTap: () => onTap(0),
              ),
              navItem(
                Icons.message_outlined,
                pageIndex == 1,
                onTap: () => onTap(1),
              ),
              const SizedBox(width: 80),
              navItem(
                Icons.notifications_none_outlined,
                pageIndex == 2,
                onTap: () => onTap(2),
              ),
              navItem(
                Icons.person_outline,
                pageIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.black,
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
