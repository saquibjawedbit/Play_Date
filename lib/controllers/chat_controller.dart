import 'package:get/get.dart';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/message_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firsbaseAuth = FirebaseAuth.instance;

  final AudioPlayer audioPlayer = AudioPlayer();
  final FocusNode focusNode = FocusNode();

  var replyMessage = "".obs;
  var messageType = "".obs;
  var myMessage = false.obs;
  var audioIndex = RxInt(-1);
  var timePlayed = RxDouble(0);
  var isReply = false.obs;

  var messageItems = [].obs;

  //Reply to message, on right swipe
  void reply(String message, String type, bool mMessage) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      isReply.value = true;
      replyMessage.value = message;
      messageType.value = type;
      myMessage.value = mMessage;
      focusNode.requestFocus();
    });
  }

  //Send Reply
  void sendReply(String message, String receiverId) {
    Map<String, String> reply = {
      "reply": replyMessage.value,
      "type": messageType.value,
      "receiverId": receiverId,
    };
    sendMessage(receiverId, message, "reply", reply: reply);
    cancelReply();
  }

  //Cancel reply, when user presses close or X button
  void cancelReply() {
    replyMessage.value = "";
    messageType.value = "";
    isReply.value = false;
    focusNode.unfocus();
  }

  @override
  void onClose() {
    // Cleanup code
    focusNode.dispose();
    super.onClose();
  }

  //PLAY AUDIO
  Future<void> playRecording(String? audioPath, int index) async {
    if (audioPath == null) return;
    if (audioPlayer.playing) {
      audioIndex.value = -1;
      audioPlayer.stop();
    } else {
      audioIndex.value = index;
      await audioPlayer.setFilePath(audioPath);
      await audioPlayer.play();
      // Listen to the position stream
      audioPlayer.positionStream.listen((position) {
        timePlayed.value =
            position.inSeconds.toDouble() / audioPlayer.duration!.inSeconds;
      });
      audioPlayer.stop();
      audioIndex.value = -1;
    }
  }

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message, String type,
      {Map<String, String>? reply}) async {
    final String currentUserId = _firsbaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    MessageModel messageModel = MessageModel(
      type: type,
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      reply: reply,
    );

    //Construct chat room id from currentUserId and receiver Id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomId = ids.join('_');

    //Add a new message to database
    await _fireStore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection("messages")
        .add(messageModel.toMap());

    await _fireStore
        .collection('user')
        .doc(receiverId)
        .collection('contacts')
        .doc(currentUserId)
        .update(
      {
        "isSeen": false,
        "lastMessage": (type == 'text')
            ? message.substring(0, min(message.length, 100))
            : (type == 'image' ? "sent an image." : "sent a voicenote"),
      },
    );
  }

  //SEND IMAGE
  Future<void> sendImage(String receiverId, File image) async {
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('chat_image');
    Reference referenceImagetoUpload = referenceDirImages.child(uniqueName);
    try {
      await referenceImagetoUpload.putFile(image);
      String url = await referenceImagetoUpload.getDownloadURL();
      sendMessage(receiverId, url, 'image');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //SEND AUDIO
  Future<void> sendAudio(String receiverId, File image) async {
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('chat_audio');
    Reference referenceImagetoUpload = referenceDirImages.child(uniqueName);
    try {
      await referenceImagetoUpload.putFile(image);
      String url = await referenceImagetoUpload.getDownloadURL();
      sendMessage(receiverId, url, 'audio');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Set Message Seen
  void messageSeen(String userId, String receiverId) {
    _fireStore
        .collection('user')
        .doc(userId)
        .collection('contacts')
        .doc(receiverId)
        .update({
      'isSeen': true,
    });
  }

  Stream<ContactModel> isMessageSeen(String userId, String receiverId) {
    final data = _fireStore
        .collection('user')
        .doc(receiverId)
        .collection('contacts')
        .doc(userId)
        .snapshots()
        .map(
            (doc) => ContactModel.fromJson(doc.data() as Map<String, dynamic>));
    return data;
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId,
      {int limit = 20}) {
    //Construct chat room id from currentUserId and receiver Id (sorted to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _fireStore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }

  //Pagination
  Future<QuerySnapshot<Map<String, dynamic>>> getOldMessages(
      String userId, String otherUserId, DocumentSnapshot document,
      {int limit = 1}) async {
    //Construct chat room id from currentUserId and receiver Id (sorted to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return await _fireStore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .startAfterDocument(document)
        .limit(limit)
        .get();
  }
}
