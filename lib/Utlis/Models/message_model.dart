import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String type;
  final String senderId;
  final String receiverId;
  final String message;
  final Map<String, dynamic>? reply;
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.reply,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type.toLowerCase(),
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "timestamp": timestamp,
      "reply": reply,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MessageModel(
      id: id,
      type: json['type'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: json['timestamp'],
      reply: json['reply'],
    );
  }
}
