import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track_app/View/HomePage.dart';

class FirebaseServices with ChangeNotifier {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  void showErrorDiaglog(String title, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    isLoading = false;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Future<void> signInUser(
      String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        if (e.toString().contains("The password is invalid"))
          showErrorDiaglog("Sign in Failed", "Wrong password", context);
        else if (e.toString().contains(
            "There is no user record corresponding to this identifier"))
          showErrorDiaglog("Sign in Failed", "Invalid email", context);
      });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUpUser(
      String username,
      String userEmail,
      String userPassword,
      BuildContext context,
      String phone,
      int userType) async {
    try {
      isLoading = true;
      notifyListeners();
      final UserCredential user = await _auth
          .createUserWithEmailAndPassword(
              email: userEmail.trim(), password: userPassword.trim())
          .catchError((e) {
        if (e.toString().contains("already in use by another account"))
          showErrorDiaglog("Register Failed",
              "The email address is already in use", context);
        else
          showErrorDiaglog("Register Failed",
              "Something went wrong please try again later", context);
      });
      if (userType == 0) //user//
      {
        print("filling user");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set({
              "username": username.trim(),
              "email": userEmail.trim(),
              "phone": phone,
              "status": "online",
            })
            .then((value) =>
                _auth.currentUser!.updateProfile(displayName: username))
            .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                )));
      } else if (userType == 1) {
        print("filling driver");
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(user.user!.uid)
            .set({
          "username": username.trim(),
          "email": userEmail.trim(),
          "phone": phone,
          "status": "online",
          "latitude": position.latitude,
          "longitude": position.longitude,
        }).then((value) => _auth.currentUser!
                .updateProfile(displayName: username)
                .then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ))));
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
