import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final double height;
  final bool? isOnline;
  final Timestamp? lastSeen;
  final String address;
  final String gender;
  final DateTime dob;
  final List<String> imageUrls;

  UserModel({
    this.id,
    this.isOnline,
    this.lastSeen,
    required this.name,
    required this.dob,
    required this.email,
    required this.height,
    required this.address,
    required this.gender,
    required this.imageUrls,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserModel(
      id: id,
      name: json['name'],
      email: json['email'],
      height: json['height'],
      address: json['address'],
      gender: json['gender'],
      imageUrls: List<String>.from(json['imageUrls']),
      dob: (json['dob'] as Timestamp).toDate(),
      lastSeen: json['lastSeen'] as Timestamp,
      isOnline: json['isOnline'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'height': height,
      'address': address,
      'gender': gender,
      'imageUrls': imageUrls,
      'dob': Timestamp.fromDate(dob),
      'lastSeen': lastSeen ?? Timestamp.now(),
      'isOnline': isOnline ?? false,
    };
  }

  int get age {
    DateTime date = DateTime.now();
    int ageDiff = (date.year - dob.year);
    int delta = ((date.month <= dob.month && date.day < dob.day) ? 1 : 0);

    return (ageDiff - delta);
  }

  String get lastActive {
    if (isOnline!) return "Active";

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
