import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends GetxController {
  String? user;
  SessionManager() {
    // Obtain shared preferences.
    //loadData();
  }

  void loadData() async {
    print("loading data");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? nuser = prefs.getString('user');
    user = nuser;
    print(user);
  }
}
