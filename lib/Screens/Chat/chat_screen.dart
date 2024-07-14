import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/controllers/service/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contact,
  });

  final ContactModel contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.contact.uid!, _messageController.text);
      _messageController.clear();
    }
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

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!myMessage)
            ProfileIcon(
              url: widget.contact.profileUrl,
              radius: 20,
            ),
          if (!myMessage)
            const SizedBox(
              width: 10,
            ),
          Container(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(27.18),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(-1, 5),
                ),
              ],
            ),
            child: Text(
              data['message'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
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
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 243, 255, 253),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        hintText: "Message...",
        hintStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 36,
          ),
        ),
        suffixIcon: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_outlined,
              color: Colors.black,
              size: 36,
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 36,
            ),
            SizedBox(
              width: 10,
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

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileIcon(
            url: widget.contact.profileUrl,
            radius: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contact.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.contact.getTime(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 65, 65, 65),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 36,
              color: Color.fromARGB(255, 107, 107, 107),
            ),
          ),
        ],
      ),
    );
  }
}
