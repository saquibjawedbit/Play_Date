import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_dates/Screens/Quiz/match_screen.dart';
import 'package:play_dates/Utlis/Buttons/flat_btn.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/Utlis/Paints/profile_painter.dart';
import 'package:play_dates/Utlis/Widgets/custom_dialog_box.dart';
import 'package:play_dates/Utlis/Widgets/nav_bar.dart';
import 'dart:io';

import 'package:play_dates/controllers/user_controller.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final List<XFile> _selectedImage = [];
  final UserController userController = Get.find();
  final selectedIndex = 0;

  void uploadImage() async {
    userController.upload(_selectedImage, onBoard: false);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomDialogBox(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedText(
              text: "Save your changes!",
              fontSize: min(31, 31.sp),
              textColor: const Color.fromARGB(255, 255, 208, 0),
              borderColor: Colors.black,
              offset: const Offset(2, 5),
              height: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "You have unsaved changes.\nDo you want to continue?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: FittedBox(
                child: Row(
                  children: [
                    FlatBtn(
                      onTap: uploadImage,
                      text: "YES",
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    FlatBtn(
                      onTap: () {
                        Get.back();
                      },
                      text: "NO",
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        padding:
            const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 255, 204),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        onPressed: _showDialog,
        child: const Icon(
          Icons.done,
          color: Colors.black,
        ),
      ),
      body: CustomPaint(
        painter: ProfilePainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 50,
              right: 42,
              top: 80,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppTitle(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Wanna change you photoes?",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                ),
                Text(
                  "Yes you can bbg, flaunt your way through.",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color.fromARGB(255, 74, 74, 74),
                        letterSpacing: 2,
                      ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 40,
                    childAspectRatio: 2 / 2.5,
                    children: [
                      for (int i = 0; i < 4; i++)
                        InkWell(
                          onTap: () {
                            _pickImagesFromGallery(i);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bColor,
                              borderRadius: BorderRadius.circular(12),
                              image: (i < _selectedImage.length)
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_selectedImage[i].path),
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color.fromARGB(255, 162, 165, 0),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 0),
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
