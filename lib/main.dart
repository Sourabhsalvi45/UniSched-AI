import 'dart:io';
import 'package:UniSched/pages/landing/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase Core for initializing Firebase
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCNbnJx7dZ_gv5fdTaTwP5I-MHtlZBiRlo",
      projectId: "unisched-37e30",
      storageBucket: "unisched-37e30.appspot.com",
      messagingSenderId: "458852895217",
      appId: "1:458852895217:android:5f2497821d3ea4155b1c50",
    ),
  )
      : await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: true, // Set to false in production
  );

  await Firebase.initializeApp(); // Initialize Firebase before app start
  runApp(const UniSched());
}

class UniSched extends StatelessWidget {
  const UniSched({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Rubik',  // Set Rubik as the default font
          primaryColor: const Color(0xFF835DF1),  // Example primary color
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          ),
        ),
        home: const SplashScreen(), // Set SplashScreen as the initial screen
      ),
    );
  }
}
