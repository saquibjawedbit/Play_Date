import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //Google Sign In
  signInWithGoogle() async {
    //begin inetracting sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for users
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> checkInstallationId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? installationId = prefs.getString('installation_id');

    if (installationId == null) {
      // New installation, force logout
      await FirebaseAuth.instance.signOut();
      // Generate and store new installation ID
      String newInstallationId = UniqueKey().toString();
      await prefs.setString('installation_id', newInstallationId);
    }
  }
}
