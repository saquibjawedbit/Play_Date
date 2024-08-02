import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Screens/Onboarding/loading_screen.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/controllers/service/cache_manager.dart';
import 'package:play_dates/main.dart';

class UserController extends GetxController {
  var name = '';
  var height = 0.0;
  var address = '';
  var currentIndex = 0.obs;
  String email = '';
  DateTime dateTime = DateTime.now();
  var gender = "male";
  var loading = true.obs;

  UserModel? user;
  Stream<List<ContactModel>>? contacts;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getUser() async {
    String id = FirebaseAuth.instance.currentUser!.uid.toString();
    UserModel? data = await categoryRepo.fetchUser(id: id);
    if (data != null) user = data;
    loading.value = false;
    //addFriend();
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

  void updateUser(List<String> imageUrls) async {
    String uid = _firebaseAuth.currentUser!.uid;
    UserModel userModel = UserModel(
      name: user!.name,
      dob: user!.dob,
      email: user!.email,
      height: user!.height,
      address: user!.address,
      gender: user!.gender,
      imageUrls: imageUrls,
    );
    categoryRepo.createUser(
      'user',
      userModel.toMap(),
      uid,
    );
    getUser();
    await CustomCacheManager.instance.emptyCache();
  }

  void upload(List<XFile> selectedImage, {bool onBoard = true}) async {
    if (selectedImage.isEmpty) return;
    if (selectedImage.length != 4 && onBoard) return;

    Get.offAll(
      () => const LoadingScreen(),
      transition: Transition.fade,
      duration: const Duration(seconds: 1),
    );

    updateEmail(FirebaseAuth.instance.currentUser!.email.toString());
    final List<String> imageUrls = [];
    for (int index = 0; index < 4; index++) {
      if (index < selectedImage.length) {
        String uniqueName =
            _firebaseAuth.currentUser!.uid.toString() + index.toString();
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
      } else {
        imageUrls.add(user!.imageUrls[index]);
      }
    }
    if (onBoard) {
      createUser(imageUrls);
    } else {
      updateUser(imageUrls);
    }
    Get.offAll(
      () => const HomeScreen(),
      transition: Transition.fade,
    );
  }
}
