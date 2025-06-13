import 'dart:math' as math;

import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);
  @override
  State<MeasurementPage> createState() =>
      _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  String beamValue = "13";
  String angleValue = "13";
  String leftLegValue = "12";
  String rightLegValue = "12";
  String leftBeamValue = "12";
  String rightBeamValue = "12";
  String pointDistanceValue = "12";
  String apexHeightValue = "12";

  void calculateMeasurements({
    required double beamDist,
    required double leftDrop,
    required double rightDrop,
    required double pointDist,
  }) {
    final halfSpan = beamDist / 2.0;

    // 1. leg lengths
    final leftLeg = math.sqrt(
      halfSpan * halfSpan + leftDrop * leftDrop,
    );
    final rightLeg = math.sqrt(
      halfSpan * halfSpan + rightDrop * rightDrop,
    );

    // 2. apex‐to‐shackle height
    final apexHeight =
        math.min(leftDrop, rightDrop) - pointDist;

    // 3. apex angle (in radians → degrees)
    final cosApex =
        (leftLeg * leftLeg +
            rightLeg * rightLeg -
            beamDist * beamDist) /
        (2 * leftLeg * rightLeg);
    final apexAngleRad = math.acos(
      cosApex.clamp(-1.0, 1.0),
    );
    final apexAngleDeg = apexAngleRad * 180 / math.pi;

    setState(() {
      beamValue = beamDist.toStringAsFixed(2);
      leftBeamValue = leftDrop.toStringAsFixed(2);
      rightBeamValue = rightDrop.toStringAsFixed(2);
      pointDistanceValue = pointDist.toStringAsFixed(2);

      leftLegValue = leftLeg.toStringAsFixed(2);
      rightLegValue = rightLeg.toStringAsFixed(2);
      apexHeightValue = apexHeight.toStringAsFixed(2);
      angleValue = apexAngleDeg.toStringAsFixed(
        1,
      ); // one decimal
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Rigging Bridle Measurement',
                      style: AppTextStyle.titleMedium
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Let’s start exploring with us in just\nfew steps away",
                      style: AppTextStyle.titleSmall,
                      textAlign: TextAlign.center,
                    ),

                    // ── diagram & inputs ──
                    Center(
                      child: Container(
                        width: 360,
                        height: 600,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppAssets.measurementPage,
                              ),
                            ),

                            // beam distance
                            Positioned(
                              top: 78,
                              left: 145,
                              child: GestureDetector(
                                onTap: () {
                                  //open value picker
                                },
                                child: Container(
                                  width: 72,
                                  height: 40,
                                  color: Colors.red
                                      .withValues(
                                        alpha: 0.3,
                                      ),
                                  child: Text(
                                    beamValue,
                                    style:
                                        AppTextStyle
                                            .bodySmall,
                                  ),
                                ),
                              ),
                            ),
                            // Angle
                            Positioned(
                              top: 158,
                              left: 145,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  angleValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // left leg
                            Positioned(
                              top: 215,
                              left: 80,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  leftLegValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // right leg
                            Positioned(
                              top: 215,
                              left: 206,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  rightLegValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // left beam height
                            Positioned(
                              top: 263,
                              left: 5,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  leftBeamValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // right beam height
                            Positioned(
                              top: 263,
                              left: 283,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  rightBeamValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // point distance
                            Positioned(
                              top: 416,
                              left: 65,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  pointDistanceValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
                                ),
                              ),
                            ),
                            // Apex height
                            Positioned(
                              top: 473,
                              left: 148,
                              child: Container(
                                width: 72,
                                height: 40,
                                color: Colors.red
                                    .withValues(alpha: 0.3),
                                child: Text(
                                  apexHeightValue,
                                  style:
                                      AppTextStyle
                                          .bodySmall,
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
          ),
        ],
      ),
    );
  }
}
