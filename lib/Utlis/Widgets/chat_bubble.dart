import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Utlis/Models/message_model.dart';
import 'package:play_dates/controllers/chat_controller.dart';
import 'package:play_dates/controllers/service/cache_manager.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../Screens/Chat/image_screen.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.alignment,
    required this.data,
    required this.myMessage,
    required this.profileUrl,
    required this.color,
    required this.index,
  });

  final Alignment alignment;
  final MessageModel data;
  final bool myMessage;
  final String profileUrl;
  final Color color;
  final int index;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  File? file;
  final ChatController chatController = Get.find();

  Widget _showContent() {
    String type = widget.data.type;
    if (type == 'text' || type == 'reply') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          widget.data.message,
          style: TextStyle(
            color: Colors.black,
            fontSize: min(16, 16.sp),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (type == 'image') {
      return GestureDetector(
        onTap: () {
          Get.to(
            () => ImageScreen(
              imagePath: widget.data.message,
            ),
          );
        },
        child: SizedBox(
          width: 300,
          height: 300,
          child: CachedNetworkImage(
            cacheManager: ChatCacheManager.instance,
            imageUrl: widget.data.message,
            placeholder: (context, message) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              if (file != null) {
                chatController.playRecording(file!.path, widget.index);
              } else {
                debugPrint("NOT DOWNLOADED");
              }
            },
            icon: Obx(() {
              return (chatController.audioIndex.value == widget.index)
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow);
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Obx(
                () {
                  return LinearProgressIndicator(
                    value: (chatController.audioIndex.value == widget.index)
                        ? chatController.timePlayed.value
                        : 0.0,
                    minHeight: 10,
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  void _cacheAndPlayAudio(String url) async {
    try {
      final fileInfo = await ChatCacheManager.instance.downloadFile(url);
      file = fileInfo.file;
    } catch (e) {
      debugPrint('Error caching or playing audio: $e');
    }
  }

  Widget _replyBar() {
    String type = widget.data.reply!['type'] ?? "text";
    String message = widget.data.reply!['reply'] ?? "Unavailable";
    if (type == "text" || type == 'reply') {
      return Text(
        message,
        maxLines: 4,
        textAlign: TextAlign.right,
        softWrap: true,
        overflow: TextOverflow.clip,
        style: TextStyle(
          color: const Color.fromARGB(255, 107, 105, 105),
          fontSize: min(16, 16.sp),
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (type == 'image') {
      return Expanded(
        child: Row(
          children: [
            Text(
              "Photo",
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: const Color.fromARGB(255, 59, 59, 59),
                fontSize: min(16, 16.sp),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 80,
              width: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CachedNetworkImage(
                  cacheManager: ChatCacheManager.instance,
                  imageUrl: message,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Row(
          children: [
            Text(
              "Audio",
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: const Color.fromARGB(255, 59, 59, 59),
                fontSize: min(16, 16.sp),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const SizedBox(
              height: 80,
              width: 80,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Icon(
                  Icons.play_arrow,
                  color: Color.fromARGB(135, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.type == 'audio') {
      _cacheAndPlayAudio(widget.data.message);
    }
    return SwipeTo(
      onRightSwipe: (details) {
        chatController.reply(
            widget.data.message, widget.data.type, widget.myMessage);
      },
      child: Container(
        alignment: widget.alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.myMessage)
              ProfileIcon(
                url: widget.profileUrl,
                radius: min(20, 20.w),
              ),
            if (!widget.myMessage)
              SizedBox(
                width: min(10.w, 10),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(27.18),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(-1, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: widget.myMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.data.type == 'reply')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      color: widget.data.reply!['receiverId'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? const Color.fromARGB(125, 255, 221, 72)
                          : const Color.fromARGB(125, 243, 255, 253),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                            width: 4,
                            height: 40,
                            color: Colors.blue,
                          ),
                          _replyBar(),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  _showContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
