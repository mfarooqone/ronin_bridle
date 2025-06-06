import 'package:clay_rigging_bridle/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      Get.offAll(() => const BottomNavBarScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.all(width * 0.1),
          child: Image.asset(AppAssets.splash, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
