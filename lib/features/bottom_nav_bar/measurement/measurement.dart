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
  double beamDist = 1.11;
  double leftLeg = 1.11;
  double rightLeg = 0.00;
  double leftDrop = 1.11;
  double rightDrop = 1.11;
  double pointDist = 1.11;
  double apexHeight = 0.00;
  double loadValue = 0.0;

  String beamValue = '';
  String leftLegValue = '';
  String rightLegValue = '';
  String leftBeamValue = '';
  String rightBeamValue = '';
  String pointDistanceValue = '';
  String apexHeightValue = '';
  String angleValue = '';
  String loadDisplay = '';

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

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

                        /* -------------------------------------------------------------------------- */
                        /*                                   weight                                   */
                        /* -------------------------------------------------------------------------- */
                        Positioned(
                          top: 280,
                          left: 136,
                          child: GestureDetector(
                            onVerticalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  -details.primaryDelta! /
                                  50;
                              setState(() {
                                leftLeg = (leftLeg + delta)
                                    .clamp(0.0, 99.99);
                                rightLeg = (rightLeg +
                                        delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  details.primaryDelta! /
                                  50;
                              setState(() {
                                leftLeg = (leftLeg + delta)
                                    .clamp(0.0, 99.99);
                                rightLeg = (rightLeg +
                                        delta)
                                    .clamp(0.0, 99.99);
                                pointDist = (pointDist +
                                        delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 100,
                              color: Colors.green
                                  .withOpacity(0.3),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),

                        ///
                        /// left beam change (drag to change leftDrop & leftLeg vertically,
                        /// rightLeg & beamDist horizontally)
                        ///
                        Positioned(
                          top: 60,
                          left: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  -details.primaryDelta! /
                                  50;
                              setState(() {
                                leftDrop = (leftDrop +
                                        delta)
                                    .clamp(0.0, 99.99);
                                leftLeg = (leftLeg + delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  details.primaryDelta! /
                                  50;
                              setState(() {
                                rightLeg = (rightLeg +
                                        delta)
                                    .clamp(0.0, 99.99);
                                beamDist = (beamDist +
                                        delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 60,
                              color: Colors.green
                                  .withOpacity(0.3),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),

                        ///
                        /// right beam change (drag to change rightDrop & rightLeg vertically,
                        /// leftLeg & beamDist horizontally)
                        ///
                        Positioned(
                          top: 60,
                          right: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  -details.primaryDelta! /
                                  50;
                              setState(() {
                                rightDrop = (rightDrop +
                                        delta)
                                    .clamp(0.0, 99.99);
                                rightLeg = (rightLeg +
                                        delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (
                              details,
                            ) {
                              double delta =
                                  details.primaryDelta! /
                                  50;
                              setState(() {
                                leftLeg = (leftLeg + delta)
                                    .clamp(0.0, 99.99);
                                beamDist = (beamDist +
                                        delta)
                                    .clamp(0.0, 99.99);
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 60,
                              color: Colors.green
                                  .withOpacity(0.3),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),

                        _inputBox(
                          top: 72,
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
                          top: 208,
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
                          top: 208,
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
                          top: 258,
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
                          top: 258,
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
                          top: 390,
                          left: 45,
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
                          top: 464,
                          left: 141,
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

                        _outputBox(
                          top: 152,
                          left: 145,
                          display: angleValue,
                        ),

                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomPaint(
                                size: const Size(80, 80),
                                painter: BridleLoadPainter(
                                  beamDist: beamDist,
                                  leftLeg: leftLeg,
                                  rightLeg: rightLeg,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loadDisplay,
                                style: AppTextStyle
                                    .bodySmall
                                    .copyWith(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
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

  void _recalculate() {
    final a = leftLeg;
    final b = rightLeg;
    final c = beamDist;

    // 1. Angle at apex (law of cosines)
    final cosA =
        ((a * a) + (b * b) - (c * c)) / (2 * a * b);
    final angleRad = math.acos(cosA.clamp(-1.0, 1.0));
    final angleDeg = angleRad * 180 / math.pi;

    // 2. Geometry to find apex Y using circle intersection
    final xL = -c / 2;
    final xR = c / 2;
    final d = (xR - xL).abs();

    final a2 = (a * a - b * b + d * d) / (2 * d);
    final h = math.sqrt(
      (a * a - a2 * a2).clamp(0.0, double.infinity),
    );

    final averageDrop = (leftDrop + rightDrop) / 2;
    apexHeight = (averageDrop - h).clamp(
      0.0,
      double.infinity,
    );

    setState(() {
      beamValue = beamDist.toStringAsFixed(2);
      leftLegValue = leftLeg.toStringAsFixed(2);
      rightLegValue = rightLeg.toStringAsFixed(2);
      leftBeamValue = leftDrop.toStringAsFixed(2);
      rightBeamValue = rightDrop.toStringAsFixed(2);
      pointDistanceValue = pointDist.toStringAsFixed(2);
      apexHeightValue = apexHeight.toStringAsFixed(2);
      angleValue = '${angleDeg.toStringAsFixed(0)}°';
      loadValue = ((leftLeg + rightLeg + pointDist) * 10)
          .clamp(0.0, 9999.0);
      loadDisplay = loadValue.toStringAsFixed(1);
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
        color: Colors.red.withOpacity(0.3),
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
      color: Colors.green.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(display, style: AppTextStyle.bodySmall),
    ),
  );
}

class BridleLoadPainter extends CustomPainter {
  final double beamDist;
  final double leftLeg;
  final double rightLeg;

  BridleLoadPainter({
    required this.beamDist,
    required this.leftLeg,
    required this.rightLeg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final redPaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
    final shacklePaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = 80.0 / ((leftLeg + rightLeg) / 2 + 1);
    final halfBeam = beamDist / 2;

    final leftX = centerX - halfBeam * scale;
    final rightX = centerX + halfBeam * scale;
    final avgLeg = (leftLeg + rightLeg) / 2;
    final topY = centerY - avgLeg * scale;
    final shackleY = centerY;

    canvas.drawLine(
      Offset(leftX, topY),
      Offset(centerX, shackleY),
      redPaint,
    );
    canvas.drawLine(
      Offset(rightX, topY),
      Offset(centerX, shackleY),
      redPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, shackleY + 5),
        width: 20,
        height: 20,
      ),
      math.pi,
      math.pi,
      false,
      shacklePaint,
    );

    canvas.drawLine(
      Offset(centerX, shackleY + 15),
      Offset(centerX, size.height),
      shacklePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant BridleLoadPainter oldDelegate,
  ) {
    return beamDist != oldDelegate.beamDist ||
        leftLeg != oldDelegate.leftLeg ||
        rightLeg != oldDelegate.rightLeg;
  }
}
