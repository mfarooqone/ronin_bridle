import 'dart:math';

import 'package:clay_rigging_bridle/features/bottom_nav_bar/setting_screen/setting_screen.dart';
import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:clay_rigging_bridle/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController _weightController =
      TextEditingController(text: '0');
  final TextEditingController _wllController =
      TextEditingController(text: '0');
  final PreferencesService _preferencesService =
      Get.find<PreferencesService>();
  final GlobalKey<ShowCaseWidgetState> _showcaseKey =
      GlobalKey<ShowCaseWidgetState>();
  final GlobalKey _infoShowcaseKey = GlobalKey();
  final GlobalKey _beamForceShowcaseKey = GlobalKey();
  final GlobalKey _forceSummaryShowcaseKey = GlobalKey();
  final GlobalKey _wllShowcaseKey = GlobalKey();
  final GlobalKey _weightShowcaseKey = GlobalKey();

  // Force calculation results
  double _leftVertical = 0;
  double _leftLeg = 0;
  double _rightLeg = 0;
  double _rightVertical = 0;
  double _horizontal = 0;
  double _wllValue = 0;
  bool _isExceeded = false;

  /// Calculate forces based on weight and WLL (Working Load Limit)
  void _calculateForces() {
    final weight =
        double.tryParse(_weightController.text) ?? 0;
    final wll = double.tryParse(_wllController.text) ?? 0;

    // Validate inputs
    if (weight < 0 || wll < 0) {
      _resetForces();
      return;
    }

    // Calculate forces using rigging bridle physics
    final vertical =
        weight / 2; // Each leg carries half the weight
    final horizontal =
        weight * 0.3; // Horizontal force component
    final legTension = sqrt(
      vertical * vertical + horizontal * horizontal,
    );
    final exceeded = legTension > wll;

    setState(() {
      _wllValue = wll;
      _leftVertical = vertical;
      _rightVertical = vertical;
      _horizontal = horizontal;
      _leftLeg = legTension;
      _rightLeg = legTension;
      _isExceeded = exceeded;
    });
  }

  /// Reset all force values to zero
  void _resetForces() {
    setState(() {
      _wllValue = 0;
      _leftVertical = 0;
      _rightVertical = 0;
      _horizontal = 0;
      _leftLeg = 0;
      _rightLeg = 0;
      _isExceeded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleShowcase();
  }

  Future<void> _scheduleShowcase() async {
    final hasSeen =
        await _preferencesService.isWeightShowcaseSeen();
    if (hasSeen || !mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _preferencesService.setWeightShowcaseSeen(true);
      _showcaseKey.currentState?.startShowCase([
        _infoShowcaseKey,
        _beamForceShowcaseKey,
        _forceSummaryShowcaseKey,
        _wllShowcaseKey,
        _weightShowcaseKey,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final iconSize = h * 0.05;
    final inputHeight = h * 0.08;
    final inputWidth = w * 0.26;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ShowCaseWidget(
        key: _showcaseKey,
        onFinish: () {
          _preferencesService.setWeightShowcaseSeen(true);
        },
        builder:
            (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Showcase(
                            key: _infoShowcaseKey,
                            title: 'Need a refresher?',
                            description:
                                'Tap the info icon any time to review how the weight calculations work.',
                            child: IconButton(
                              onPressed: () {
                                showPreferencesDialog(
                                  context: context,
                                  title: "Weights",
                                  body:
                                      'In this window all the various loads within the bridle & beams are shown, to change the weight in the apex, tap the text field.',
                                );
                              },
                              icon: Icon(
                                Icons.info_outline,
                                color:
                                    AppColors.primaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Showcase(
                          key: _beamForceShowcaseKey,
                          title: 'Monitor horizontal force',
                          description:
                              'The beam diagram updates live to show the horizontal force between guards.',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: h * 0.02,
                            ),
                            child: BeamWidget(
                              iconSize: iconSize,
                              horizontalForce: _horizontal,
                            ),
                          ),
                        ),
                        Showcase(
                          key: _forceSummaryShowcaseKey,
                          title: 'Track each leg',
                          description:
                              'These arrows display vertical and leg loads so you can compare against the WLL.',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.05,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                _buildForce(
                                  1.5,
                                  'Vertical',
                                  _leftVertical,
                                  iconSize,
                                ),
                                _buildForce(
                                  1.0,
                                  'Leg',
                                  _leftLeg,
                                  iconSize,
                                  _leftLeg > _wllValue,
                                ),
                                SizedBox(width: w * 0.08),
                                _buildForce(
                                  2.0,
                                  'Leg',
                                  _rightLeg,
                                  iconSize,
                                  _rightLeg > _wllValue,
                                ),
                                _buildForce(
                                  1.5,
                                  'Vertical',
                                  _rightVertical,
                                  iconSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isExceeded) ...[
                          SizedBox(height: h * 0.02),
                          Text(
                            'Steel W.L.L. Exceeded!',
                            style: AppTextStyle.titleSmall
                                .copyWith(
                                  color: AppColors.red,
                                ),
                          ),
                        ],
                        SizedBox(height: h * 0.02),

                        // Input controls section
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 1,
                                  child: Icon(
                                    Icons.arrow_right_alt,
                                    size: iconSize,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 2,
                                  child: Icon(
                                    Icons.arrow_right_alt,
                                    size: iconSize,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              AppAssets.weightImage,
                              width: w * 0.25,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: h * 0.02),

                            const Icon(
                              Icons.arrow_downward,
                              size: 32,
                            ),
                            SizedBox(height: h * 0.01),

                            // Input fields for weight and WLL
                            Row(
                              children: [
                                Showcase(
                                  key: _wllShowcaseKey,
                                  title: 'Set your limit',
                                  description:
                                      'Enter the steel working load limit so overloads are flagged automatically.',
                                  child: Column(
                                    children: [
                                      Text(
                                        'Steel W.L.L.',
                                        style:
                                            AppTextStyle
                                                .bodySmall,
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      SizedBox(
                                        width: inputWidth,
                                        height: inputHeight,
                                        child: PrimaryTextField(
                                          controller:
                                              _wllController,
                                          onChanged: (
                                            value,
                                          ) {
                                            setState(() {
                                              _calculateForces();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: w * 0.05),

                                // Weight input field
                                Showcase(
                                  key: _weightShowcaseKey,
                                  title: 'Adjust load',
                                  description:
                                      'Update the apex weight here to see forces recalculate instantly.',
                                  child: Column(
                                    children: [
                                      Text(
                                        'Weight',
                                        style:
                                            AppTextStyle
                                                .bodySmall,
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      SizedBox(
                                        width: inputWidth,
                                        height: inputHeight,
                                        child: PrimaryTextField(
                                          controller:
                                              _weightController,
                                          onChanged: (
                                            value,
                                          ) {
                                            setState(() {
                                              _calculateForces();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  /// Build a force display widget with arrow and value
  /// [angle] - rotation angle for the arrow icon
  /// [label] - text label for the force type
  /// [value] - force value to display
  /// [iconSize] - size of the arrow icon
  /// [isOverload] - whether this force exceeds the WLL
  Widget _buildForce(
    double angle,
    String label,
    double value,
    double iconSize, [
    bool isOverload = false,
  ]) {
    final textColor =
        isOverload ? AppColors.red : AppColors.black;
    return Column(
      children: [
        Transform.rotate(
          angle: angle,
          child: Icon(
            Icons.arrow_right_alt,
            size: iconSize,
            color: isOverload ? AppColors.red : null,
          ),
        ),
        Text(
          label,
          style: AppTextStyle.titleSmall.copyWith(
            color: textColor,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: AppTextStyle.titleSmall.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}

/// Widget displaying the beam with horizontal force visualization
class BeamWidget extends StatelessWidget {
  const BeamWidget({
    Key? key,
    required this.iconSize,
    required this.horizontalForce,
  }) : super(key: key);

  /// Size of the arrow icons
  final double iconSize;

  /// Horizontal force value to display
  final double horizontalForce;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          AppAssets.rightGuard,
          width: height * 0.1,
          height: height * 0.1,
          fit: BoxFit.contain,
        ),
        Icon(Icons.arrow_right_alt, size: iconSize),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Horizontal\nForce',
              style: AppTextStyle.titleSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              horizontalForce.toStringAsFixed(2),
              style: AppTextStyle.titleSmall,
            ),
          ],
        ),
        Transform.rotate(
          angle: 3.1416,
          child: Icon(
            Icons.arrow_right_alt,
            size: iconSize,
          ),
        ),
        Image.asset(
          AppAssets.leftGuard,
          width: height * 0.1,
          height: height * 0.1,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
