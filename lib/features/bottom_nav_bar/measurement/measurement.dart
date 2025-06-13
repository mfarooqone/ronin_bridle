import 'dart:math' as math;

import 'package:clay_rigging_bridle/features/bottom_nav_bar/setting_screen/setting_screen.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);
  @override
  State<MeasurementPage> createState() =>
      _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  // ── Raw inputs ──
  // double beamDist = 1.11;
  // double leftLeg = 0.98;
  // double rightLeg = 0.98;
  // double leftDrop = 1.11;
  // double rightDrop = 1.11;
  // double pointDist = 0.55;
  // double apexHeight = 0.00;
  double beamDist = 0;
  double leftLeg = 0;
  double rightLeg = 0;
  double leftDrop = 0;
  double rightDrop = 0;
  double pointDist = 0;
  double apexHeight = 0;

  // ── Display strings ──
  String beamValue = '';
  String leftLegValue = '';
  String rightLegValue = '';
  String leftBeamValue = '';
  String rightBeamValue = '';
  String pointDistanceValue = '';
  String apexHeightValue = '';
  String angleValue = '';

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    // ── 1) compute vertical component of each leg ──
    final halfSpan = beamDist / 2.0;
    final vertL = math.sqrt(
      math.max(
        0.0,
        leftLeg * leftLeg - halfSpan * halfSpan,
      ),
    );
    final vertR = math.sqrt(
      math.max(
        0.0,
        rightLeg * rightLeg - halfSpan * halfSpan,
      ),
    );

    // ── 2) how far below each beam the hook sits ──
    final hookDownL = leftDrop - vertL;
    final hookDownR = rightDrop - vertR;

    // ── 3) choose the smaller (most conservative) side ──
    apexHeight = math.min(hookDownL, hookDownR);

    // ── 4) law of cosines for the apex angle ──
    final rawCos =
        (leftLeg * leftLeg +
            rightLeg * rightLeg -
            beamDist * beamDist) /
        (2 * leftLeg * rightLeg);
    final cosA = rawCos.clamp(-1.0, 1.0);
    final rad = math.acos(cosA);
    final deg = rad * 180 / math.pi;

    // ── 5) update all displayed strings ──
    setState(() {
      beamValue = beamDist.toStringAsFixed(2);
      leftLegValue = leftLeg.toStringAsFixed(2);
      rightLegValue = rightLeg.toStringAsFixed(2);
      leftBeamValue = leftDrop.toStringAsFixed(2);
      rightBeamValue = rightDrop.toStringAsFixed(2);
      pointDistanceValue = pointDist.toStringAsFixed(2);
      apexHeightValue = apexHeight.toStringAsFixed(2);
      angleValue = '${deg.toStringAsFixed(0)}°';
    });
  }

  Future<void> _showPicker({
    required String title,
    required double currentValue,
    required ValueChanged<double> onConfirm,
    bool skipRecalc = false,
  }) async {
    final ints = List<int>.generate(100, (i) => i);
    final tenths = List<int>.generate(10, (i) => i);
    final hunds = List<int>.generate(10, (i) => i);

    int i0 = ints
        .indexWhere((v) => v == currentValue.floor())
        .clamp(0, 99);
    int i1 = ((currentValue * 10).floor() % 10).clamp(0, 9);
    int i2 = ((currentValue * 100).floor() % 10).clamp(
      0,
      9,
    );

    await showCupertinoModalPopup(
      context: context,
      builder:
          (ctx) => Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                // toolbar
                SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: const Text('Cancel'),
                        onPressed:
                            () => Navigator.of(ctx).pop(),
                      ),
                      Text(
                        title,
                        style: AppTextStyle.titleSmall,
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: const Text('Done'),
                        onPressed: () {
                          final val =
                              ints[i0] +
                              tenths[i1] / 10 +
                              hunds[i2] / 100;
                          onConfirm(val);
                          Navigator.of(ctx).pop();
                          if (!skipRecalc) _recalculate();
                        },
                      ),
                    ],
                  ),
                ),

                // three‐column picker
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController:
                              FixedExtentScrollController(
                                initialItem: i0,
                              ),
                          itemExtent: 32,
                          onSelectedItemChanged:
                              (x) => i0 = x.clamp(0, 99),
                          children:
                              ints
                                  .map(
                                    (v) => Center(
                                      child: Text(
                                        v
                                            .toString()
                                            .padLeft(
                                              2,
                                              '0',
                                            ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController:
                              FixedExtentScrollController(
                                initialItem: i1,
                              ),
                          itemExtent: 32,
                          onSelectedItemChanged:
                              (x) => i1 = x.clamp(0, 9),
                          children:
                              tenths
                                  .map(
                                    (v) => Center(
                                      child: Text('.${v}'),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController:
                              FixedExtentScrollController(
                                initialItem: i2,
                              ),
                          itemExtent: 32,
                          onSelectedItemChanged:
                              (x) => i2 = x.clamp(0, 9),
                          children:
                              hunds
                                  .map(
                                    (v) => Center(
                                      child: Text(
                                        v.toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _inputBox({
    required double top,
    required double left,
    required String display,
    required String title,
    required VoidCallback onTap,
  }) => Positioned(
    top: top,
    left: left,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 40,
        // color: Colors.red.withOpacity(0.3),
        alignment: Alignment.center,
        child: Text(display, style: AppTextStyle.bodySmall),
      ),
    ),
  );

  Widget _outputBox({
    required double top,
    required double left,
    required String display,
  }) => Positioned(
    top: top,
    left: left,
    child: Container(
      width: 72,
      height: 40,
      // color: Colors.green.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(display, style: AppTextStyle.bodySmall),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Rigging Bridle Measurement',
                  style: AppTextStyle.titleMedium.copyWith(
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
                const SizedBox(height: 20),
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

                        // Inputs
                        _inputBox(
                          top: 78,
                          left: 145,
                          display: beamValue,
                          title: 'Beam Distance',
                          onTap:
                              () => _showPicker(
                                title: 'Beam Distance',
                                currentValue: beamDist,
                                onConfirm:
                                    (v) => beamDist = v,
                              ),
                        ),
                        _inputBox(
                          top: 214,
                          left: 80,
                          display: leftLegValue,
                          title: 'Left Leg',
                          onTap:
                              () => _showPicker(
                                title: 'Left Leg',
                                currentValue: leftLeg,
                                onConfirm:
                                    (v) => leftLeg = v,
                              ),
                        ),
                        _inputBox(
                          top: 214,
                          left: 206,
                          display: rightLegValue,
                          title: 'Right Leg',
                          onTap:
                              () => _showPicker(
                                title: 'Right Leg',
                                currentValue: rightLeg,
                                onConfirm:
                                    (v) => rightLeg = v,
                              ),
                        ),
                        _inputBox(
                          top: 263,
                          left: 5,
                          display: leftBeamValue,
                          title: 'Beam Height',
                          onTap:
                              () => _showPicker(
                                title: 'Beam Height',
                                currentValue: leftDrop,
                                onConfirm:
                                    (v) => leftDrop = v,
                              ),
                        ),
                        _inputBox(
                          top: 263,
                          left: 283,
                          display: rightBeamValue,
                          title: 'Beam Height',
                          onTap:
                              () => _showPicker(
                                title: 'Beam Height',
                                currentValue: rightDrop,
                                onConfirm:
                                    (v) => rightDrop = v,
                              ),
                        ),
                        _inputBox(
                          top: 416,
                          left: 65,
                          display: pointDistanceValue,
                          title: 'Point Distance',
                          onTap:
                              () => _showPicker(
                                title: 'Point Distance',
                                currentValue: pointDist,
                                onConfirm:
                                    (v) => pointDist = v,
                              ),
                        ),
                        _inputBox(
                          top: 474,
                          left: 147,
                          display: apexHeightValue,
                          title: 'Apex Height',
                          onTap:
                              () => _showPicker(
                                title: 'Apex Height',
                                currentValue: apexHeight,
                                onConfirm:
                                    (v) => apexHeight = v,
                                skipRecalc: true,
                              ),
                        ),

                        // Output (angle)
                        _outputBox(
                          top: 158,
                          left: 145,
                          display: angleValue,
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      showPreferencesDialog(
                        context: context,
                        title: "Measurements",
                        body:
                            'Both beams and the shackle are touch sensitive and you can drag them in any direction to fine tune your measurements. Tap one of the text fields to enter your values directly.',
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
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
