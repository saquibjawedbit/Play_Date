import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Screens/Chat/inbox_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/message_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/controllers/chat_controller.dart';
import 'package:play_dates/main.dart';
import 'package:record/record.dart';
import '../../Utlis/Widgets/chat_bubble.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../Views/picked_image_screen.dart';
import 'message_input_bar.dart';

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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AudioRecorder audioRecord = AudioRecorder();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.put(ChatController());
  DocumentSnapshot? _lastDocument;

  String? latestId;

  @override
  void initState() {
    super.initState();
    if (widget.openCamera) {
      _pickImage(ImageSource.camera);
    }
    _scrollController.addListener(_onScroll);
    chatController.messageSeen(
        _firebaseAuth.currentUser!.uid, widget.contact.uid!);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint("Loading...");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await chatController.getOldMessages(
              FirebaseAuth.instance.currentUser!.uid,
              widget.contact.uid!,
              _lastDocument!,
              limit: 20);
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        chatController.messageItems.addAll(querySnapshot.docs);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        String filePath = p.join(directory.path, 'recording.wav');
        await audioRecord.start(
            const RecordConfig(
              encoder: AudioEncoder.wav,
              bitRate: 96000, // Bitrate (affects quality and size)
              sampleRate: 16000, // Lower sample rate (16 kHz)
              numChannels: 1, // Mono recording
            ),
            path: filePath);
      }
    } catch (e) {
      debugPrint('Error: start recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      if (path != null) {
        File file = File(path);
        chatController.sendAudio(widget.contact.uid!, file);
      }
    } catch (e) {
      debugPrint("Error: stop recording $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _messageSeen(),
              MessageInputBar(
                startRecording: startRecording,
                stopRecording: stopRecording,
                pickImage: _pickImage,
                contact: widget.contact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<ContactModel> _messageSeen() {
    return StreamBuilder(
      stream: chatController.isMessageSeen(
          _firebaseAuth.currentUser!.uid, widget.contact.uid!),
      builder: (context, snapshot) {
        String value = "    ";

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (snapshot.hasData == false) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: const Center(child: Text("No Messages")),
          );
        }

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

  Widget _buildMessageItem(DocumentSnapshot document, int index) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //Align the message to right, if sender sends it, and to left if receiver sends it.
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Color color = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? const Color.fromARGB(255, 255, 221, 72)
        : const Color.fromARGB(255, 243, 255, 253);

    bool myMessage = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    chatController.messageSeen(
        _firebaseAuth.currentUser!.uid, widget.contact.uid!);

    return _textBubble(alignment, myMessage, color, data, index);
  }

  Widget _textBubble(Alignment alignment, bool myMessage, Color color,
      Map<String, dynamic> data, int index) {
    return ChatBubble(
      alignment: alignment,
      myMessage: myMessage,
      color: color,
      data: MessageModel.fromJson(data),
      profileUrl: widget.contact.profileUrl,
      index: index,
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatController.getMessages(
          widget.contact.uid!, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        _lastDocument = snapshot.data!.docs.lastOrNull;
        String id = snapshot.data!.docs.first.id;
        if (chatController.messageItems.isNotEmpty && id != latestId) {
          latestId = id;
          chatController.messageItems.insert(0, snapshot.data!.docs.first);
        } else {
          latestId = snapshot.data!.docs.first.id;
          chatController.messageItems.clear();
          chatController.messageItems
              .addAll(snapshot.data!.docs.map((document) {
            return document;
          }).toList());
        }

        return Obx(
          () {
            return ReorderableListView.builder(
                reverse: true,
                scrollController: _scrollController,
                itemBuilder: (context, index) {
                  return Container(
                    key: ValueKey(chatController.messageItems[index]),
                    child: _buildMessageItem(
                        chatController.messageItems[index], index),
                  );
                },
                itemCount: chatController.messageItems.length,
                onReorder: (oldIndex, newIndex) {});
          },
        );
      },
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
      if (send) {
        chatController.sendImage(widget.contact.uid!, File(images.path));
      }
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
