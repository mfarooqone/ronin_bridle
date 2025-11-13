import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_labels.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:clay_rigging_bridle/widgets/app_logo.dart';
import 'package:clay_rigging_bridle/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import 'available_hardware.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() =>
      _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final MeasurementService _measurementService = Get.put(
    MeasurementService(),
  );
  final PreferencesService _preferencesService =
      Get.find<PreferencesService>();
  final GlobalKey<ShowCaseWidgetState> _showcaseKey =
      GlobalKey<ShowCaseWidgetState>();
  final GlobalKey _infoShowcaseKey = GlobalKey();
  final GlobalKey _unitShowcaseKey = GlobalKey();
  final GlobalKey _inputShowcaseKey = GlobalKey();
  final GlobalKey _hardwareShowcaseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scheduleShowcase();
  }

  Future<void> _scheduleShowcase() async {
    final hasSeen =
        await _preferencesService.isSettingsShowcaseSeen();
    if (hasSeen || !mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _preferencesService.setSettingsShowcaseSeen(true);
      _showcaseKey.currentState?.startShowCase([
        _infoShowcaseKey,
        _unitShowcaseKey,
        _inputShowcaseKey,
        _hardwareShowcaseKey,
      ]);
    });
  }

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

    return ShowCaseWidget(
      key: _showcaseKey,
      onFinish: () {
        _preferencesService.setSettingsShowcaseSeen(true);
      },
      builder: (context) => Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Showcase(
                    key: _infoShowcaseKey,
                    title: 'Need help?',
                    description:
                        'Tap the info icon to learn more about measurement preferences and hardware.',
                    child: IconButton(
                      onPressed: () {
                        showPreferencesDialog(
                          context: context,
                          title: "Preferences",
                          body:
                              'Choose to work in imperial or metric and tap the available '
                              'hardware button to change your hardware.',
                        );
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
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

                Showcase(
                  key: _unitShowcaseKey,
                  title: 'Choose your unit',
                  description:
                      'Switch between Metric and Imperial to control how all measurements are displayed.',
                  child: SizedBox(
                    width: segmentWidth,
                    height: segmentHeight,
                    child: Obx(
                      () => CupertinoSegmentedControl<String>(
                        children: measurementOptions,
                        groupValue:
                            _measurementService
                                .selectedUnit
                                .value,
                        borderColor: AppColors.primaryColor,
                        selectedColor: AppColors.primaryColor,
                        unselectedColor: AppColors.white,
                        pressedColor: AppColors.primaryColor
                            .withOpacity(0.2),
                        onValueChanged: (value) {
                          _measurementService
                              .setMeasurementUnit(value);
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),

                Text(
                  'Input',
                  style: AppTextStyle.titleMedium,
                ),
                SizedBox(height: height * 0.01),

                Showcase(
                  key: _inputShowcaseKey,
                  title: 'Pick an input style',
                  description:
                      'Numeric gives you text fields, while Dials will use pickers for values.',
                  child: SizedBox(
                    width: segmentWidth,
                    height: segmentHeight,
                    child: Obx(
                      () => CupertinoSegmentedControl<String>(
                        children: inputOptions,
                        groupValue:
                            _measurementService
                                .selectedInputType
                                .value,
                        borderColor: AppColors.primaryColor,
                        selectedColor: AppColors.primaryColor,
                        unselectedColor: AppColors.white,
                        pressedColor: AppColors.primaryColor
                            .withOpacity(0.2),
                        onValueChanged: (value) {
                          _measurementService.setInputType(
                            value,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),

                ///
                ///
                ///
                Showcase(
                  key: _hardwareShowcaseKey,
                  title: 'Update hardware',
                  description:
                      'Review and toggle baskets, steels, decks, and more from the hardware list.',
                  child: PrimaryButton(
                    title: "Available Hardware",
                    onPressed: () {
                      Get.to(() => AvailableHardwareScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showPreferencesDialog({
  required BuildContext context,
  required String title,
  required String body,
}) {
  showCupertinoDialog(
    context: context,
    builder:
        (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(body, textAlign: TextAlign.center),
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
