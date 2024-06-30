import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final double height;
  final String address;
  final String gender;
  final DateTime dob;
  final List<String> imageUrls;

  UserModel({
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
      name: json['name'],
      email: json['email'],
      height: json['height'],
      address: json['address'],
      gender: json['gender'],
      imageUrls: json['imageUrls'],
      dob: (json['dob'] as Timestamp).toDate(),
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
    };
  }
}
