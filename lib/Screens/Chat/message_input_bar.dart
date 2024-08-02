import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/controllers/chat_controller.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({
    super.key,
    required this.stopRecording,
    required this.pickImage,
    required this.startRecording,
    required this.contact,
  });

  final Function() stopRecording;
  final Function(ImageSource) pickImage;
  final Function() startRecording;
  final ContactModel contact;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  bool isRecording = false;
  bool _isTyping = false;
  final TextEditingController _controller = TextEditingController();
  final ChatController chatController = Get.find();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isRecording ? _recordWidget() : _inputBar();
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      await chatController.sendMessage(
        widget.contact.uid!,
        message,
        'text',
      );
    }
  }

  Widget _recordWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Container(color: Colors.blue)),
          const Text(
            "Recording....",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              onPressed: () {
                widget.stopRecording();
                setState(() {
                  isRecording = false;
                });
              },
              icon: const Icon(
                Icons.stop,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 4),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          children: [
            if (chatController.isReply.value)
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 8),
                constraints: const BoxConstraints(minHeight: 60),
                decoration: BoxDecoration(
                  color: chatController.myMessage.value
                      ? const Color.fromARGB(125, 255, 221, 72)
                      : const Color.fromARGB(125, 243, 255, 253),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                ),
                child: _replyUI(),
              ),
            _inputUI(),
          ],
        ),
      );
    });
  }

  void _sendMessage() {
    if (chatController.isReply.value) {
      chatController.sendReply(_controller.text, widget.contact.uid!);
    } else {
      sendMessage(_controller.text);
    }
    setState(() {
      _isTyping = false;
    });
    _controller.clear();
  }

  TextField _inputUI() {
    return TextField(
      focusNode: chatController.focusNode,
      textInputAction: TextInputAction.done,
      controller: _controller,
      onSubmitted: (String message) {
        _sendMessage();
      },
      onChanged: (String msg) {
        if (msg == "") {
          setState(() {
            _isTyping = false;
          });
        } else {
          setState(() {
            _isTyping = true;
          });
        }
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
              widget.pickImage(ImageSource.camera);
            },
            child: Icon(
              Icons.camera_alt_outlined,
              size: min(36, 36.sp),
            ),
          ),
        ),
        suffixIcon: _actionsUI(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(21),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(21),
        ),
      ),
    );
  }

  Row _actionsUI() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: (_isTyping)
          ? [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ]
          : [
              InkWell(
                onTap: () {
                  widget.startRecording();
                  setState(() {
                    isRecording = true;
                  });
                },
                child: Icon(
                  Icons.mic_outlined,
                  color: Colors.black,
                  size: min(36, 36.w),
                ),
              ),
              SizedBox(
                width: min(5, 5.w),
              ),
              GestureDetector(
                onTap: () {
                  widget.pickImage(ImageSource.gallery);
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
    );
  }

  Row _replyUI() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          width: 4,
          height: 40,
          color: Colors.blue,
        ),
        if (chatController.messageType.value == "text" ||
            chatController.messageType.value == "reply")
          Expanded(
            child: Text(
              chatController.replyMessage.value,
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: const Color.fromARGB(255, 59, 59, 59),
                fontSize: min(16, 16.sp),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (chatController.messageType.value == 'image')
          Expanded(
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
                    child: Image.network(
                      chatController.replyMessage.value,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (chatController.messageType.value == "audio")
          Expanded(
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
          ),
        IconButton(
          onPressed: chatController.cancelReply,
          icon: const Icon(
            Icons.close,
          ),
        ),
      ],
    );
  }
}
