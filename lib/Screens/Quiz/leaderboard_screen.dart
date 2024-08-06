import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Models/result_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/controllers/user_controller.dart';
import 'package:play_dates/main.dart';

class LeaderBoardScreen extends StatelessWidget {
  LeaderBoardScreen({super.key, this.matchedName, required this.result});

  final String? matchedName;
  final ResultModel result;
  final UserController userController = Get.find();

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
            Get.back();
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
            LeaderBoardTile(
              title: "Current Match: ",
              titleColor: Colors.black,
              trailing: matchedName ?? ".....",
              leadingColor: const Color.fromARGB(255, 146, 97, 53),
              iconPath: "assets/medal-star.png",
            ),
            LeaderBoardTile(
              title: "Players: ",
              titleColor: Colors.black,
              trailing: (result.count).toString(),
              leadingColor: const Color.fromARGB(204, 21, 21, 21),
              iconPath: "assets/user-big-group.png",
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
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
                itemCount: result.matches.length,
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
                    data: result.matches[index],
                    isMale: userController.user!.gender == 'male',
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

class PlayListTile extends StatefulWidget {
  const PlayListTile({
    super.key,
    required this.index,
    required this.data,
    required this.color,
    required this.isMale,
  });

  final int index;
  final Color color;
  final Player data;
  final bool isMale;

  @override
  State<PlayListTile> createState() => _PlayListTileState();
}

class _PlayListTileState extends State<PlayListTile> {
  UserModel? playerData;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    String id = widget.isMale ? widget.data.maleId! : widget.data.femaleId!;
    playerData = await categoryRepo.fetchUser(id: id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              (widget.index + 1).toString(),
              maxLines: 1,
              style: TextStyle(
                color: widget.color,
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
                color: widget.color,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color,
                  spreadRadius: 3,
                  offset: const Offset(4, 4),
                )
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                playerData != null
                    ? playerData!.imageUrls[0]
                    : "https://picsum.photos/200/300",
              ),
              maxRadius: min(16, 16.w),
            ),
          )
        ],
      ),
      title: Text(
        maxLines: 1,
        playerData != null ? playerData!.name : "San",
        style: TextStyle(
          color: widget.color,
          fontSize: min(20, 20.sp),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: AutoSizeText(
        (widget.data.score).toString(),
        maxLines: 1,
        style: TextStyle(
          color: widget.color,
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
