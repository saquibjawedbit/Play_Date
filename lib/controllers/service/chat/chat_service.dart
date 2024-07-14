import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Models/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firsbaseAuth = FirebaseAuth.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firsbaseAuth.currentUser!.uid;
    final String currentUserEmail = _firsbaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    MessageModel messageModel = MessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

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
