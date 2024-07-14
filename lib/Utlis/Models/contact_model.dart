import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String name;
  final String? uid;
  final String profileUrl;
  final String? lastMessage;
  final Timestamp? lastSeen;

  ContactModel({
    required this.name,
    this.uid,
    required this.profileUrl,
    this.lastSeen,
    this.lastMessage,
  });

  factory ContactModel.fromDocument(DocumentSnapshot doc, String id) {
    return ContactModel(
      uid: id,
      name: doc['name'],
      profileUrl: doc['profileUrl'],
      lastMessage: doc['lastMessage'],
      lastSeen: doc['lastSeen'] as Timestamp,
    );
  }

  factory ContactModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ContactModel(
      name: json['name'],
      uid: id,
      profileUrl: json['profileUrl'],
      lastMessage: json['lastMessage'],
      lastSeen: json['lastSeen'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uid": uid,
      "profileUrl": profileUrl,
      "lastMessage": lastMessage,
      "lastSeen": lastSeen,
    };
  }

  String getTime() {
    final prevTime = lastSeen!.toDate();
    final currTime = DateTime.now();
    final delta = currTime.difference(prevTime);

    if (delta.inDays != 0) {
      return "Active ${delta.inDays.toString()} days ago";
    } else if (delta.inHours != 0) {
      return "Active ${delta.inHours.toString()} hours ago";
    } else {
      return "Active ${delta.inMinutes.toString()} min ago";
    }
  }
}
