import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:track_app/View/HomePage.dart';
import 'package:track_app/View/SignIn.dart';

import 'Controllers/FirebaseService/Firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseServices(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
            home: MyHomePage(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.almaraiTextTheme(
                Theme.of(context).textTheme,
              ),
            ));
      },
    );
  }
}
