import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Controllers/FirebaseService/Firebase.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String email = "";

  String password = "";

  String name = "";

  String phone = "";

  var _radioValue = 0;

  _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(child: Image.asset("assets/top1.png")),
                Positioned(child: Image.asset("assets/top2.png")),
                Positioned(
                    right: 0,
                    top: 30,
                    child: Image.asset(
                      "assets/main.png",
                      width: 140,
                      height: 140,
                    )),
                Positioned(
                    right: 0,
                    top: 30,
                    child: Image.asset(
                      "assets/main.png",
                      width: 140,
                      height: 140,
                    )),
                Positioned(
                  child: Image.asset(
                    "assets/bottom1.png",
                  ),
                  bottom: 0,
                  left: 0,
                ),
                Positioned(
                  child: Image.asset(
                    "assets/bottom2.png",
                  ),
                  bottom: 0,
                  right: 0,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text("REGISTER",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff335AE6))),
                        SizedBox(
                          height: 5,
                        ),
                        registerFormField(
                          label: "Email",
                          obsecure: false,
                        ),
                        SizedBox(height: 5),
                        registerFormField(
                          label: "Phone Number",
                          obsecure: false,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        registerFormField(
                          label: "Username",
                          obsecure: false,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        registerFormField(
                          label: "Password",
                          obsecure: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sign up as ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Text(
                                  "User",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: _radioValue == 0
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                Radio<int>(
                                  value: 0,
                                  activeColor: Color(0xff335AE6),
                                  groupValue: _radioValue,
                                  onChanged: (int? value) {
                                    _handleRadioValueChange(value!);
                                    print(_radioValue);
                                  },
                                ),
                                Text(
                                  "Driver",
                                  style: TextStyle(
                                    color: _radioValue == 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                Radio<int>(
                                  activeColor: Color(0xff335AE6),
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: (int? value) {
                                    _handleRadioValueChange(value!);
                                    print(_radioValue);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 33,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              _formKey.currentState!.save();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                Provider.of<FirebaseServices>(context,
                                        listen: false)
                                    .signUpUser(name, email, password, context,
                                        phone, _radioValue);
                              }
                            },
                            child: Container(
                              width: 185,
                              height: 45,
                              child: Center(
                                child: Provider.of<FirebaseServices>(context)
                                        .isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        "SIGN UP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xffF78A24),
                                    Color(0xffF6A629)
                                  ]),
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Already have an account? Sign in",
                              style: TextStyle(
                                  color: Color(0xff7189C1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerFormField({
    required String label,
    required bool obsecure,
  }) {
    return TextFormField(
      validator: (value) {
        if (label == "Username") {
          if (value!.isEmpty) {
            return ("Username is required !");
          } else if (value.length < 3) {
            return ("Minimum username length is 3");
          }
        }
        if (label == "Phone Number") {
          if (value!.isEmpty) {
            return "Phone Number is required !";
          }
        }
        if (label == "Email") {
          if (value!.isEmpty) {
            return ("Email is required !");
          } else if (!value.contains("@") || !value.contains(".com")) {
            return ("Please enter a valid email !");
          }
        }
        if (label == "Password") {
          if (value!.isEmpty) {
            return ("Password is required !");
          } else if (value.length < 5) {
            return ("Password is too short minimun is 5");
          }
        }
      },
      obscureText: obsecure,
      onSaved: (newValue) {
        if (label == "Username") {
          name = newValue!.trim();
        } else if (label == "Email") {
          email = newValue!.trim();
        } else if (label == "Password") {
          password = newValue!.trim();
        } else if (label == "Phone Number") {
          phone = newValue!.trim();
        }
      },
      keyboardType: label == "Phone Number"
          ? TextInputType.phone
          : label == "Email"
              ? TextInputType.emailAddress
              : TextInputType.multiline,
      style: TextStyle(fontSize: 19, height: 1.5),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffF78A24)),
        ),
      ),
    );
  }
}
