import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:track_app/Model/Driver.dart';
import 'package:track_app/View/HomePage.dart';
import 'package:track_app/View/SignIn.dart';

class FirebaseServices with ChangeNotifier {
  List<Driver> allDrivers = [];
  bool isLoading = false;
  bool trackingStatus = false;
  String userType = "";
  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  void showErrorDiaglog(String title, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                // ignore: deprecated_member_use
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
      var x = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        if (e.toString().contains("The password is invalid"))
          showErrorDiaglog("Sign in Failed", "Wrong password", context);
        else if (e.toString().contains(
            "There is no user record corresponding to this identifier"))
          showErrorDiaglog("Sign in Failed", "Invalid email", context);
      });
      print(x.user!.uid);

      var d = await FirebaseFirestore.instance
          .collection("users")
          .doc(x.user!.uid)
          .get();
      print(d.exists);
      if (d.exists) {
        print("exists");
        userType = "user";
      } else {
        userType = "driver";
      }

      isLoading = false;
      notifyListeners();
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } catch (e) {
      print(e);
    }
  }

  removeAssignedDrivers(String driverID) {
    try {
      print("deleting driver now");
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("mydrivers")
          .doc(driverID)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  startTracking() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    trackingStatus = !trackingStatus;
    print(trackingStatus);
    notifyListeners();

    Timer.periodic(Duration(seconds: 30), (timer) {
      print(timer.isActive);
      if (!trackingStatus) {
        timer.cancel();
      }
      FirebaseFirestore.instance.collection("drivers").doc(user!.uid).update(
          {"latitude": position.latitude, "longitude": position.longitude});
    });
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            )));
  }

  assignDriver(String driverID) {
    try {
      print(
          "assigning driver now .. ${FirebaseAuth.instance.currentUser!.uid}.");
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("mydrivers")
          .doc(driverID)
          .set({"driverId": driverID});
    } catch (e) {
      print(e);
    }
  }

  updateDriverStatus(
      String driverID, bool status, BuildContext context, bool undo) {
    FirebaseFirestore.instance
        .collection("drivers")
        .doc(driverID)
        .update({"available": status})
        .then((value) => undo ? print("undo") : Navigator.pop(context))
        .then((value) {
          if (!undo) {
            assignDriver(driverID);
          } else if (undo) {
            removeAssignedDrivers(driverID);
          }
        });
  }

  Stream<QuerySnapshot> getDrivers() {
    try {
      return FirebaseFirestore.instance.collection("drivers").snapshots();
    } catch (e) {
      print(e);
    }
    throw (e);
  }

  Future<void> signUpUser(
      String username,
      String userEmail,
      String userPassword,
      String userImage,
      BuildContext context,
      String phone,
      int userTypee) async {
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
      if (userTypee == 0) //user//
      {
        print("filling user");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set({
              "username": username.trim(),
              "email": userEmail.trim(),
              "phone": phone,
              "userImage": userImage,
              "status": "online",
            })
            .then((value) =>
                _auth.currentUser!.updateProfile(displayName: username))
            .then((value) async {
              var d = await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.user!.uid)
                  .get();
              print(d.exists);
              if (d.exists) {
                print("exists");
                userType = "user";
              } else {
                userType = "driver";
              }
            })
            .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                )));
      } else if (userTypee == 1) {
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
          "available": true,
          "latitude": position.latitude,
          "longitude": position.longitude,
        }).then((value) => _auth.currentUser!
                    .updateProfile(displayName: username)
                    .then((value) async {
                  var d = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.user!.uid)
                      .get();
                  print(d.exists);
                  if (d.exists) {
                    print("exists");
                    userType = "user";
                  } else {
                    userType = "driver";
                  }
                }).then((value) => Navigator.pushReplacement(
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
