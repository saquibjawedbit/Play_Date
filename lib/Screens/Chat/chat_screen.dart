import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Utlis/Buttons/flat_btn.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/controllers/service/chat/chat_service.dart';
import 'package:play_dates/main.dart';

import '../../Utlis/Widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contact,
    required this.openCamera,
  });

  final ContactModel contact;
  final bool openCamera;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.contact.uid!,
        _messageController.text,
        'text',
      );
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.openCamera) {
      _pickImage(ImageSource.camera);
    }
    _chatService.messageSeen(
        _firebaseAuth.currentUser!.uid, widget.contact.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _inputBar(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<ContactModel> _messageSeen() {
    return StreamBuilder(
      stream: _chatService.isMessageSeen(
          _firebaseAuth.currentUser!.uid, widget.contact.uid!),
      builder: (context, snapshot) {
        String value = "";

        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data!.isSeen == true) {
          value = "Seen";
        }

        return Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
          child: Text(
            value,
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //Align the message to right, if sender sends it, and to left if receiver sends it.
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Color color = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? const Color.fromARGB(255, 255, 221, 72)
        : const Color.fromARGB(255, 243, 255, 253);

    bool myMessage = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    _chatService.messageSeen(
        _firebaseAuth.currentUser!.uid, widget.contact.uid!);

    return _textBubble(alignment, myMessage, color, data);
  }

  Widget _textBubble(Alignment alignment, bool myMessage, Color color,
      Map<String, dynamic> data) {
    return ChatBubble(
      alignment: alignment,
      myMessage: myMessage,
      color: color,
      data: data,
      profileUrl: widget.contact.profileUrl,
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.contact.uid!, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        List<Widget> messageItems = snapshot.data!.docs.reversed
            .map((document) => _buildMessageItem(document))
            .toList();

        messageItems.insert(0, _messageSeen());

        return ListView(
          controller: _scrollController,
          reverse: true,
          children: messageItems,
        );
      },
    );
  }

  Widget _inputBar() {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _messageController,
      onSubmitted: (message) {
        sendMessage();
      },
      maxLines: 5,
      minLines: 1,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: min(20, 20.sp),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 243, 255, 253),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        hintText: "Message...",
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: min(20, 20.sp),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              _pickImage(ImageSource.camera);
            },
            child: Icon(
              Icons.camera_alt_outlined,
              size: min(36, 36.sp),
            ),
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_outlined,
              color: Colors.black,
              size: min(36, 36.w),
            ),
            SizedBox(
              width: min(5, 5.w),
            ),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery);
              },
              child: Icon(
                Icons.image_outlined,
                color: Colors.black,
                size: min(36, 36.w),
              ),
            ),
            SizedBox(
              width: min(10, 10.w),
            ),
          ],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(21),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(21),
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(
        source: source, imageQuality: 40, maxHeight: 720, maxWidth: 720);

    if (images != null) {
      bool send = await Get.to(() => PickedImageScreen(
            imagePath: File(images.path),
          ));
      if (send) _chatService.sendImage(widget.contact.uid!, File(images.path));
    }
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileIcon(
            url: widget.contact.profileUrl,
            radius: min(24, 24.w),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contact.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(20, 20.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder<UserModel>(
                stream: categoryRepo.getUserStream(widget.contact.uid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasData == false) {
                    return const Text("");
                  }
                  return Text(
                    snapshot.data!.lastActive,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 65, 65, 65),
                      fontSize: min(17, 17.sp),
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: min(36, 36.h),
              color: const Color.fromARGB(255, 107, 107, 107),
            ),
          ),
        ],
      ),
    );
  }
}

class PickedImageScreen extends StatelessWidget {
  const PickedImageScreen({
    super.key,
    required this.imagePath,
  });

  final File imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.file(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: min(20, 20.h),
          ),
          FlatBtn(
            onTap: () {
              Get.back(result: true);
            },
            text: "SEND",
          ),
        ],
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          child: Image.network(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
