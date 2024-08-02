import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/main.dart';

class UserController extends GetxController {
  var name = '';
  var height = 0.0;
  var address = '';
  var currentIndex = 0.obs;
  String email = '';
  DateTime dateTime = DateTime.now();
  // 1- Male, 0 -Female
  var gender = "male";
  var loading = true.obs;

  UserModel? user;
  Stream<List<ContactModel>>? contacts;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getUser() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    UserModel? data = await categoryRepo.fetchUser(email: email);
    if (data != null) user = data;
    loading.value = false;
    //addFriend();
    if (user != null) getContacts();
  }

  void getContacts() async {
    contacts = categoryRepo.fetchContacts(
      id: user!.id!,
    );
    //print(contacts);
  }

  Future<void> addFriend() async {
    String id = _firebaseAuth.currentUser!.uid;
    String fId = "SkxU63QxXWaLiHl30hysHhNzc142";
    ContactModel model = ContactModel(
      name: "Saquib",
      isSeen: false,
      profileUrl:
          "https://firebasestorage.googleapis.com/v0/b/play-date-6570f.appspot.com/o/images%2F17209354737247430?alt=media&token=862ee22d-5c72-4f36-a1e1-68a04a1076af",
    );
    dbClient.addFriend(
        collection: "user",
        id: fId,
        subCollection: "contacts",
        subId: id,
        data: model.toMap());
  }

  void updateGender(bool male) {
    if (!male) gender = "female";
  }

  // Method to update name
  bool updateName(String newName, String day, String month, String year) {
    name = newName.capitalizeFirst!.removeAllWhitespace;
    try {
      dateTime = DateTime(int.parse(year), int.parse(month), int.parse(day));
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateEmail(String mail) {
    email = mail;
  }

  // Method to update height
  void updateHeight(String newHeight) {
    height = double.parse(newHeight.removeAllWhitespace);
  }

  // Method to update address
  void updateAddress(String newAddress) {
    address = newAddress;
  }

  void createUser(List<String> imageUrls) {
    String uid = _firebaseAuth.currentUser!.uid;
    UserModel userModel = UserModel(
      name: name,
      dob: dateTime,
      email: email,
      height: height,
      address: address,
      gender: gender,
      imageUrls: imageUrls,
    );
    categoryRepo.createUser(
      'user',
      userModel.toMap(),
      uid,
    );
    getUser();
  }

  void upload(List<XFile> selectedImage) async {
    if (selectedImage.length != 4) return;

    updateEmail(FirebaseAuth.instance.currentUser!.email.toString());
    final List<String> imageUrls = [];
    for (int index = 0; index < 4; index++) {
      String uniqueName =
          DateTime.now().microsecondsSinceEpoch.toString() + index.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImagetoUpload = referenceDirImages.child(uniqueName);
      try {
        await referenceImagetoUpload.putFile(File(selectedImage[index].path));
        String url = await referenceImagetoUpload.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    createUser(imageUrls);
    Get.offAll(
      () => const HomeScreen(),
      transition: Transition.fade,
    );
  }
}
