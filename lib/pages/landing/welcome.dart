import 'package:UniSched/pages/aboutus/aboutTeam.dart';
import 'package:UniSched/pages/landing/login.dart';
import 'package:UniSched/pages/landing/register.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart'hide Image;
import 'dart:ui';



class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            // Background Image
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              left: 100,
              bottom: 100,
              child: Image.asset(
                "assets/Backgrounds/Spline.png",
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            const RiveAnimation.asset(
              "assets/RiveAssets/shapes.riv",
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'UniSched',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lilitaOne(
                          fontSize: 52.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 900),
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'An intelligent timetable maker that uses machine learning to dynamically create and optimize schedules.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 1100),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.lightGreenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.transparent, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: FadeInUp(
                            delay: const Duration(milliseconds: 1100),
                            duration: const Duration(milliseconds: 1200),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1100),
                      duration: const Duration(milliseconds: 1200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 800),
                child: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutTeam(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}