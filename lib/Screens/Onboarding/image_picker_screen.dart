import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:play_dates/Screens/home_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';

import 'package:play_dates/controllers/user_controller.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final List<XFile> _selectedImage = [];
  final UserController userController = Get.find();
  bool _isLoading = false;

  void uploadImage() async {
    if (_selectedImage.length != 4) return;

    setState(() {
      _isLoading = true;
    });
    userController
        .updateEmail(FirebaseAuth.instance.currentUser!.email.toString());
    final List<String> imageUrls = [];
    for (int index = 0; index < 4; index++) {
      String uniqueName =
          DateTime.now().microsecondsSinceEpoch.toString() + index.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImagetoUpload = referenceDirImages.child(uniqueName);
      try {
        await referenceImagetoUpload.putFile(File(_selectedImage[index].path));
        String url = await referenceImagetoUpload.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        setState(() {
          _isLoading = false;
          return;
        });
      }
    }

    userController.createUser(imageUrls);
    Get.offAll(
      () => HomeScreen(),
      transition: Transition.fade,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = userController.name;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: sbColor,
          shape: const CircleBorder(),
          onPressed: uploadImage,
          child: const Icon(Icons.arrow_forward_ios_sharp),
        ),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: Colors.white,
                  size: 100,
                ),
              )
            : Stack(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: IndicatorLinear(percent: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 100,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time to reveal yourself $name.",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Add 4 photos of yours, and don`t hesitate, everybody is made for somebody right?",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 40,
                              children: [
                                for (int i = 0; i < 4; i++)
                                  InkWell(
                                    onTap: () {
                                      _pickImagesFromGallery(i);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        image: (i < _selectedImage.length)
                                            ? DecorationImage(
                                                image: FileImage(File(
                                                    _selectedImage[i].path)),
                                                fit: BoxFit.fill,
                                              )
                                            : null,
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future _pickImagesFromGallery(int index) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(limit: 4);
    if (images.isNotEmpty) {
      setState(() {
        for (int i = index;
            i < (index + 4) && (i - index) < images.length;
            i++) {
          if ((i % 4) < _selectedImage.length) {
            _selectedImage[i % 4] = images[i - index];
          } else {
            _selectedImage.add(images[i - index]);
          }
        }
      });
    }
  }
}
