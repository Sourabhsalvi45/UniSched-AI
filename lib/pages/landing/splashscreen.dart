import 'dart:async';
import 'package:UniSched/pages/admin/admin_page.dart';
import 'package:UniSched/pages/home/homepage.dart';
import 'package:UniSched/pages/landing/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  Future<void> _checkUserLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading time

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String storedRole = userQuery.docs.first['role'] ?? '';

        // Redirect to respective page based on role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => storedRole == "HOD" ? const AdminPage() : const FacultyHomePage(),
          ),
        );
        return;
      }
    }

    // If no user is found, navigate to the Welcome Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Lottie.asset(
                'assets/animations/Animation1.json',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'UniSched',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
