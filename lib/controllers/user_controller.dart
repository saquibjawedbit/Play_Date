import 'package:get/get.dart';
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

  void updateGender(bool male) {
    if (!male) gender = "female";
  }

  // Method to update name
  bool updateName(String newName, String day, String month, String year) {
    name = newName.capitalizeFirst!.removeAllWhitespace;
    try {
      dateTime = DateTime(int.parse(year), int.parse(month), int.parse(day));
      print(dateTime);
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
    UserModel userModel = UserModel(
        name: name,
        dob: dateTime,
        email: email,
        height: height,
        address: address,
        gender: gender,
        imageUrls: imageUrls);
    categoryRepo.createCategories('user', userModel.toMap());
  }
}
