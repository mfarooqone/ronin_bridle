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
  double beamDist = 2.68;
  double leftLeg = 1.90;
  double rightLeg = 2.98;
  double leftDrop = 1.94;
  double rightDrop = 1.47;
  double pointDist = 0.07;
  double apexHeight = 0.00;

  String beamValue = '';
  String leftLegValue = '';
  String rightLegValue = '';
  String leftBeamValue = '';
  String rightBeamValue = '';
  String pointDistanceValue = '';
  String apexHeightValue = '';
  String angleValue = '';

  // Helper to keep values non-negative
  double _nn(double v) => v.clamp(0.0, double.infinity);

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  @override
  Widget build(BuildContext context) {
    // ensure UI always in sync
    _recalculate();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      showPreferencesDialog(
                        context: context,
                        title: "Measurements",
                        body:
                            'Drag beams or the weight to adjust values. Tap a field to enter numbers directly.',
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
                Text(
                  'Rigging Bridle Measurement',
                  style: AppTextStyle.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),

                Text(
                  "Let’s start exploring with us in just\nfew steps away",
                  style: AppTextStyle.titleSmall,
                  textAlign: TextAlign.center,
                ),

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

                        // weight drag: adjusts both legs & apex
                        Positioned(
                          top: 280,
                          left: 136,
                          child: GestureDetector(
                            onVerticalDragUpdate: (d) {
                              final delta =
                                  -d.primaryDelta! / 50;
                              setState(() {
                                leftLeg = _nn(
                                  leftLeg + delta,
                                );
                                rightLeg = _nn(
                                  rightLeg + delta,
                                );
                                apexHeight = _nn(
                                  apexHeight + delta,
                                );
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (d) {
                              final delta =
                                  d.primaryDelta! / 50;
                              setState(() {
                                leftLeg = _nn(
                                  leftLeg + delta,
                                );
                                rightLeg = _nn(
                                  rightLeg + delta,
                                );
                                pointDist = _nn(
                                  pointDist + delta,
                                );
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 100,
                              color: Colors.transparent,
                            ),
                          ),
                        ),

                        // left beam drag: BEAM distances
                        Positioned(
                          top: 60,
                          left: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: (d) {
                              final delta =
                                  -d.primaryDelta! / 50;
                              setState(() {
                                leftDrop = _nn(
                                  leftDrop + delta,
                                );
                                leftLeg = _nn(
                                  leftLeg + delta,
                                );
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (d) {
                              final delta =
                                  d.primaryDelta! / 50;
                              setState(() {
                                beamDist = _nn(
                                  beamDist + delta,
                                );
                                leftLeg = _nn(
                                  leftLeg + delta,
                                );
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 60,
                              color: Colors.transparent,
                            ),
                          ),
                        ),

                        // right beam drag
                        Positioned(
                          top: 60,
                          right: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: (d) {
                              final delta =
                                  -d.primaryDelta! / 50;
                              setState(() {
                                rightDrop = _nn(
                                  rightDrop + delta,
                                );
                                rightLeg = _nn(
                                  rightLeg + delta,
                                );
                              });
                              _recalculate();
                            },
                            onHorizontalDragUpdate: (d) {
                              final delta =
                                  d.primaryDelta! / 50;
                              setState(() {
                                beamDist = _nn(
                                  beamDist + delta,
                                );
                                rightLeg = _nn(
                                  rightLeg + delta,
                                );
                              });
                              _recalculate();
                            },
                            child: Container(
                              width: 90,
                              height: 60,
                              color: Colors.transparent,
                            ),
                          ),
                        ),

                        // Text inputs / pickers
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
                                    (v) =>
                                        beamDist = _nn(v),
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
                                    (v) => leftLeg = _nn(v),
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
                                    (v) =>
                                        rightLeg = _nn(v),
                              ),
                        ),
                        _inputBox(
                          top: 258,
                          left: 5,
                          display: leftBeamValue,
                          title: 'Left Beam',
                          onTap:
                              () => _showPicker(
                                title: 'Left Beam Height',
                                currentValue: leftDrop,
                                onConfirm:
                                    (v) =>
                                        leftDrop = _nn(v),
                              ),
                        ),
                        _inputBox(
                          top: 258,
                          left: 283,
                          display: rightBeamValue,
                          title: 'Right Beam',
                          onTap:
                              () => _showPicker(
                                title: 'Right Beam Height',
                                currentValue: rightDrop,
                                onConfirm:
                                    (v) =>
                                        rightDrop = _nn(v),
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
                                    (v) =>
                                        pointDist = _nn(v),
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
                                    (v) =>
                                        apexHeight = _nn(v),
                                skipRecalc: true,
                              ),
                        ),

                        // Angle output
                        _outputBox(
                          top: 152,
                          left: 145,
                          display: angleValue,
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
    );
  }

  void _recalculate() {
    final half = beamDist / 2;
    final dxL = half + pointDist;
    final dxR = half - pointDist;
    final dyL = leftDrop - apexHeight;
    final dyR = rightDrop - apexHeight;
    final dot = dxL * dxR + dyL * dyR;
    final denom = leftDrop * rightDrop;
    String ang;
    if (denom <= 0) {
      ang = '–';
    } else {
      final cosA = (dot / denom).clamp(-1.0, 1.0);
      final rad = math.acos(cosA);
      ang = '${(rad * 180 / math.pi).toStringAsFixed(0)}°';
    }

    setState(() {
      beamValue = beamDist.toStringAsFixed(2);
      leftLegValue = leftLeg.toStringAsFixed(2);
      rightLegValue = rightLeg.toStringAsFixed(2);
      leftBeamValue = leftDrop.toStringAsFixed(2);
      rightBeamValue = rightDrop.toStringAsFixed(2);
      pointDistanceValue = pointDist.toStringAsFixed(2);
      apexHeightValue = apexHeight.toStringAsFixed(2);
      angleValue = ang;
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

    int i0 = currentValue.floor().clamp(0, 99);
    int i1 = ((currentValue * 10).floor() % 10);
    int i2 = ((currentValue * 100).floor() % 10);

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
                          final raw =
                              ints[i0] +
                              tenths[i1] / 10 +
                              hunds[i2] / 100;
                          final val = _nn(raw);
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
                              (x) => i0 = x,
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
                              (x) => i1 = x,
                          children:
                              tenths
                                  .map(
                                    (v) => Center(
                                      child: Text('.$v'),
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
                              (x) => i2 = x,
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
        color: Colors.transparent,
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
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text(display, style: AppTextStyle.bodySmall),
    ),
  );
}

class ShacklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, centerY + 5),
        width: 20,
        height: 20,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(centerX, centerY + 15),
      Offset(centerX, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      false;
}

enum BridleLegSide { left, right }

class SingleLegPainter extends CustomPainter {
  final BridleLegSide side;
  final double beamDist;
  final double legLength;

  SingleLegPainter({
    required this.side,
    required this.beamDist,
    required this.legLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = 80.0 / (legLength + 1);
    final halfBeam = beamDist / 2;

    final topY = centerY - legLength * scale;
    final shackleY = centerY;
    final x =
        side == BridleLegSide.left
            ? centerX - halfBeam * scale
            : centerX + halfBeam * scale;

    canvas.drawLine(
      Offset(x, topY),
      Offset(centerX, shackleY),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant SingleLegPainter oldDelegate,
  ) =>
      oldDelegate.legLength != legLength ||
      oldDelegate.beamDist != beamDist ||
      oldDelegate.side != side;
}
