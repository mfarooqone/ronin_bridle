import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:clay_rigging_bridle/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController _wllController =
      TextEditingController(text: '0');
  final TextEditingController _weightController =
      TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double iconSize = h * 0.05;
    final double labelFont = h * 0.02;
    final double valueFont = h * 0.022;
    final double inputHeight = h * 0.04;
    final double inputWidth = w * 0.3;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: w,
              height: h,
              child: Column(
                children: [
                  // 1) Beam + horizontal arrow + label + arrow + beam
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: h * 0.02,
                    ),
                    child: BeamWidget(
                      iconSize: iconSize,
                      labelFont: labelFont,
                      valueFont: valueFont,
                    ),
                  ),

                  // 2) Four Vertical/Leg pairs
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: List.generate(2, (side) {
                        // side = 0 is left pair, side = 1 right pair
                        return Row(
                          children: [
                            _buildForceColumn(
                              iconAngle:
                                  side == 0 ? 1.5 : 2.0,
                              label: 'Vertical',
                              value: '0.00',
                              iconSize: iconSize,
                              valueFont: valueFont,
                            ),
                            SizedBox(width: w * 0.08),
                            _buildForceColumn(
                              iconAngle: 1.0,
                              label: 'Leg',
                              value: '0.00',
                              iconSize: iconSize,
                              valueFont: valueFont,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  // 3) Weight image + weight arrow + labels + inputs
                  Expanded(
                    child: Column(
                      children: [
                        ///
                        ///
                        ///
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
                        Text(
                          'Weight',
                          style: AppTextStyle.bodySmall,
                        ),
                        SizedBox(height: h * 0.01),

                        PrimaryTextField(
                          controller: _weightController,
                          backgroungColor: AppColors.white,
                          width: inputWidth,
                          height: inputHeight,
                        ),

                        SizedBox(height: h * 0.03),
                        // Steel W.L.L.
                        Text(
                          'Steel W.L.L.',
                          style: AppTextStyle.bodySmall,
                        ),
                        SizedBox(height: h * 0.01),
                        PrimaryTextField(
                          controller: _wllController,
                          backgroungColor: AppColors.white,
                          width: inputWidth,
                          height: inputHeight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForceColumn({
    required double iconAngle,
    required String label,
    required String value,
    required double iconSize,
    required double valueFont,
  }) {
    return Column(
      children: [
        Transform.rotate(
          angle: iconAngle,
          child: Icon(
            Icons.arrow_right_alt,
            size: iconSize,
          ),
        ),
        Text(label, style: AppTextStyle.titleSmall),
        Text(value, style: AppTextStyle.titleSmall),
      ],
    );
  }
}

class BeamWidget extends StatelessWidget {
  const BeamWidget({
    Key? key,

    required this.iconSize,
    required this.labelFont,
    required this.valueFont,
  }) : super(key: key);

  final double iconSize;
  final double labelFont;
  final double valueFont;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final height = size.height;
    return SizedBox(
      child: Row(
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

              Text('0.00', style: AppTextStyle.titleSmall),
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
      ),
    );
  }
}
