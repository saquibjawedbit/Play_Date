import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String name;
  final String? uid;
  final String profileUrl;
  final String? lastMessage;
  final Timestamp lastMessageTime;
  final bool isSeen;

  ContactModel({
    required this.name,
    required this.profileUrl,
    required this.isSeen,
    required this.lastMessageTime,
    this.uid,
    required this.lastMessage,
  });

  factory ContactModel.fromDocument(DocumentSnapshot doc, String id) {
    return ContactModel(
      uid: id,
      isSeen: doc['isSeen'] as bool,
      name: doc['name'],
      lastMessageTime: doc['lastMessageTime'] as Timestamp,
      profileUrl: doc['profileUrl'],
      lastMessage: doc['lastMessage'],
    );
  }

  factory ContactModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ContactModel(
      name: json['name'],
      lastMessageTime: json['lastMessageTime'],
      isSeen: json['isSeen'],
      uid: id,
      profileUrl: json['profileUrl'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "profileUrl": profileUrl,
      "lastMessage": lastMessage ?? "",
      "isSeen": false,
      "lastMessageTime": lastMessageTime,
    };
  }
}
