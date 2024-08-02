import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/chat_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/controllers/inbox_controller.dart';
import 'package:play_dates/controllers/service/cache_manager.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, required this.name});

  final String name;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final InBoxController _inBoxController = Get.put(InBoxController());
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _lastDocument;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _inBoxController.fetchOldContacts(lastDocument: _lastDocument);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: min(24, 24.sp),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<List<ContactModel>>(
          stream: _inBoxController.fetchContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            if (snapshot.hasData == false || snapshot.data!.isEmpty) {
              return Column(
                children: [
                  searchBtn(),
                  const Spacer(),
                  const Text("No contacts"),
                  const Spacer(),
                ],
              );
            }

            _lastDocument = snapshot.data!.lastOrNull!.toMap();

            return _chatItemBuilder();
          }),
    );
  }

  Widget _chatItemBuilder() {
    return Obx(() {
      return ListView.builder(
        itemCount: _inBoxController.contacts.length + 1,
        controller: _scrollController,
        itemBuilder: (builder, index) {
          if (index == 0) return searchBtn();
          return _chatItem(_inBoxController.contacts[index - 1]);
        },
      );
    });
  }

  Widget _chatItem(ContactModel snapshot) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ChatScreen(
            contact: snapshot,
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
          url: snapshot.profileUrl,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              snapshot.lastMessage ?? "",
            ),
            const SizedBox(
              width: 10,
            ),
            if (!snapshot.isSeen)
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 5,
              )
          ],
        ),
        subtitleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: !snapshot.isSeen ? FontWeight.w700 : FontWeight.w400,
          fontSize: min(16, 16.sp),
        ),
        title: Text(
          snapshot.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: min(20, 20.sp),
            fontWeight: FontWeight.w600,
          ),
        ),
        minLeadingWidth: 1,
        trailing: GestureDetector(
          onTap: () => _sendImage(snapshot),
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
          textInputAction: TextInputAction.search,
          onChanged: _inBoxController.search,
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
    return Container(
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
        backgroundImage: CachedNetworkImageProvider(
          url,
          cacheManager: ContactCacheManager.instance,
        ),
        radius: radius,
      ),
    );
  }
}
