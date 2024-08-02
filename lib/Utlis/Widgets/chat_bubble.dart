import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/chat_screen.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.alignment,
    required this.data,
    required this.myMessage,
    required this.profileUrl,
    required this.color,
  });

  final Alignment alignment;
  final Map<String, dynamic> data;
  final bool myMessage;
  final String profileUrl;
  final Color color;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool onTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      color: onTapped == true
          ? const Color.fromARGB(181, 83, 86, 82)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          GestureDetector(
            onLongPress: () {
              setState(() {
                onTapped = true;
              });
              // showDialog(
              //   context: context,
              //   builder: (context) => Dialog(
              //     backgroundColor: Colors.white,
              //     elevation: 100,
              //     insetPadding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         TextButton(
              //           onPressed: () {

              //           },
              //           style: TextButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 100, vertical: 12),
              //           ),
              //           child: const Text(
              //             "Delete for everyone",
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 24, right: 12),
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
              child: (widget.data['type'] == 'text')
                  ? Text(
                      widget.data['message'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: min(16, 16.sp),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.to(() => ImageScreen(
                              imagePath: widget.data['message'],
                            ));
                      },
                      child: Image.network(widget.data['message']),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
