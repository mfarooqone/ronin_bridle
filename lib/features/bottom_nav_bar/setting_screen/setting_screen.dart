import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_labels.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:clay_rigging_bridle/widgets/app_logo.dart';
import 'package:clay_rigging_bridle/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'available_hardware.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() =>
      _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedMeasurement = 'Metric';
  String _selectedInput = 'Numeric';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // These multipliers can be adjusted as needed:
    final double segmentWidth = width * 0.6;
    final double segmentHeight = height * 0.07;

    final Map<String, Widget> measurementOptions = {
      'Metric': Center(child: Text('Metric')),
      'Imperial': Center(child: Text('Imperial')),
    };

    final Map<String, Widget> inputOptions = {
      'Numeric': Center(child: Text('Numeric')),
      'Dials': Center(child: Text('Dials')),
    };

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    _showPreferencesDialog(context);
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),

              ///
              AppLogo(height: height * 0.2),
              Text(
                AppLabels.appName,
                style: AppTextStyle.headlineMedium,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Measurements',
                style: AppTextStyle.titleMedium,
              ),
              SizedBox(height: height * 0.01),

              SizedBox(
                width: segmentWidth,
                height: segmentHeight,
                child: CupertinoSegmentedControl<String>(
                  children: measurementOptions,
                  groupValue: _selectedMeasurement,
                  borderColor: AppColors.primaryColor,
                  selectedColor: AppColors.primaryColor,
                  unselectedColor: AppColors.white,
                  pressedColor: AppColors.primaryColor
                      .withOpacity(0.2),
                  onValueChanged: (value) {
                    setState(() {
                      _selectedMeasurement = value;
                    });
                  },
                ),
              ),

              SizedBox(height: height * 0.01),

              Text(
                'Input',
                style: AppTextStyle.titleMedium,
              ),
              SizedBox(height: height * 0.01),

              SizedBox(
                width: segmentWidth,
                height: segmentHeight,
                child: CupertinoSegmentedControl<String>(
                  children: inputOptions,
                  groupValue: _selectedInput,
                  borderColor: AppColors.primaryColor,
                  selectedColor: AppColors.primaryColor,
                  unselectedColor: AppColors.white,
                  pressedColor: AppColors.primaryColor
                      .withOpacity(0.2),
                  onValueChanged: (value) {
                    setState(() {
                      _selectedInput = value;
                    });
                  },
                ),
              ),
              SizedBox(height: height * 0.05),

              ///
              ///
              ///
              PrimaryButton(
                title: "Available Hardware",
                onPressed: () {
                  Get.to(() => AvailableHardwareScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreferencesDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (ctx) => CupertinoAlertDialog(
            title: const Text('Preferences'),
            content: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Choose to work in imperial or metric and tap the available '
                'hardware button to change your hardware.',
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                isDefaultAction: true,
                child: Text(
                  'Ok',
                  style: AppTextStyle.titleLarge,
                ),
              ),
            ],
          ),
    );
  }
}
