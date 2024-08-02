import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/chat_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, required this.name, required this.contacts});

  final String name;
  final Stream<List<ContactModel>>? contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: min(24, 24.sp),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<List<ContactModel>>(
          stream: contacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            if (snapshot.hasData == false) {
              return const Text("No contacts");
            }

            return _chatItemBuilder(snapshot);
          }),
    );
  }

  ListView _chatItemBuilder(AsyncSnapshot<List<ContactModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length + 1,
      itemBuilder: (builder, index) {
        if (index == 0) return searchBtn();
        return _chatItem(snapshot, index);
      },
    );
  }

  Widget _chatItem(AsyncSnapshot<List<ContactModel>> snapshot, int index) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ChatScreen(
            contact: snapshot.data![index - 1],
            openCamera: false,
          ),
        );
      },
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 2, horizontal: -4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        isThreeLine: false,
        leading: ProfileIcon(
          radius: min(32, 32.w),
          url: snapshot.data![index - 1].profileUrl,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              snapshot.data![index - 1].lastMessage ?? "",
            ),
            const SizedBox(
              width: 10,
            ),
            if (!snapshot.data![index - 1].isSeen)
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 5,
              )
          ],
        ),
        subtitleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: !snapshot.data![index - 1].isSeen
              ? FontWeight.w700
              : FontWeight.w400,
          fontSize: min(16, 16.sp),
        ),
        title: Text(
          snapshot.data![index - 1].name,
          style: TextStyle(
            color: Colors.black,
            fontSize: min(20, 20.sp),
            fontWeight: FontWeight.w600,
          ),
        ),
        minLeadingWidth: 1,
        trailing: GestureDetector(
          onTap: () => _sendImage(snapshot.data![index - 1]),
          child: Icon(
            Icons.camera_alt_rounded,
            color: Colors.black,
            size: min(36, 36.sp),
          ),
        ),
      ),
    );
  }

  void _sendImage(ContactModel contact) {
    Get.to(() => ChatScreen(
          contact: contact,
          openCamera: true,
        ));
  }

  Padding searchBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(-4, 4),
            ),
          ],
        ),
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontSize: min(18, 18.sp),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 250, 239, 223),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: min(18, 18.sp),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: min(36, 36.h),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
    required this.url,
    required this.radius,
  });

  final String url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(-4, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          url,
        ),
        radius: radius,
      ),
    );
  }
}
