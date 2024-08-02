import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firsbaseAuth = FirebaseAuth.instance;

  //SEND MESSAGE
  Future<void> sendMessage(
    String receiverId,
    String message,
    String type,
  ) async {
    final String currentUserId = _firsbaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    MessageModel messageModel = MessageModel(
      type: type,
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
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
            : "sent an image.",
      },
    );
  }

  //SEND IMAGE
  Future<void> sendImage(String receiverId, File image) async {
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImagetoUpload = referenceDirImages.child(uniqueName);
    try {
      await referenceImagetoUpload.putFile(image);
      String url = await referenceImagetoUpload.getDownloadURL();
      sendMessage(receiverId, url, 'image');
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
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //Construct chat room id from currentUserId and receiver Id (sorted to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _fireStore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
