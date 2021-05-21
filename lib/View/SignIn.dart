import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Controllers/FirebaseService/Firebase.dart';
import 'SignUp.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(child: Image.asset("assets/top1.png")),
              Positioned(child: Image.asset("assets/top1.png")),
              Positioned(child: Image.asset("assets/top2.png")),
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
                        height: 180,
                      ),
                      Text("LOGIN",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff335AE6))),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Email is required !");
                          } else if (!value.contains("@") ||
                              !value.contains(".com")) {
                            return ("Please enter a valid email !");
                          }
                        },
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Password is required !");
                          }
                        },
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => print("forgot"),
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: Color(0xffAEB6D6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await Provider.of<FirebaseServices>(context,
                                      listen: false)
                                  .signInUser(emailController.text,
                                      passController.text, context);
                            } else {
                              return;
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
                                      "LOGIN",
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              )),
                          child: Text(
                            "Don't have an account? Sign up",
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
    );
  }
}
