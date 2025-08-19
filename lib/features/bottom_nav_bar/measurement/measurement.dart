import 'package:clay_rigging_bridle/features/bottom_nav_bar/setting_screen/setting_screen.dart';
import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
///
/// lft right right legs will be
/// it should be only
/// if it is in Imp then it will be in pound
/// /// if it is in metric then other page and otherwise other page
/// ti souult 20ft to  200 ft
///

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  State<MeasurementPage> createState() =>
      _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final MeasurementService _measurementService = Get.put(
    MeasurementService(),
  );

  // Store values in meters (base unit)
  double beamDist = 2.68; // Default values in meters
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() {
        // Set display values directly
        beamValue = _measurementService.formatDistance(
          beamDist,
        );
        leftLegValue = _measurementService.formatDistance(
          leftLeg,
        );
        rightLegValue = _measurementService.formatDistance(
          rightLeg,
        );
        leftBeamValue = _measurementService.formatDistance(
          leftDrop,
        );
        rightBeamValue = _measurementService.formatDistance(
          rightDrop,
        );
        pointDistanceValue = _measurementService
            .formatDistance(pointDist);
        apexHeightValue = _measurementService
            .formatDistance(apexHeight);
        angleValue = '0°';
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
                      style: AppTextStyle.titleMedium
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                    ),

                    // Input method indicator
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryColor
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Input: ${_measurementService.selectedInputType.value}',
                          style: AppTextStyle.bodySmall
                              .copyWith(
                                color:
                                    AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
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
                                    onConfirm: (v) {
                                      beamDist = v;
                                      setState(() {});
                                    },
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
                                    onConfirm: (v) {
                                      leftLeg = v;
                                      setState(() {});
                                    },
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
                                    onConfirm: (v) {
                                      rightLeg = v;
                                      setState(() {});
                                    },
                                  ),
                            ),
                            _inputBox(
                              top: 258,
                              left: 5,
                              display: leftBeamValue,
                              title: 'Left Beam',
                              onTap:
                                  () => _showPicker(
                                    title:
                                        'Left Beam Height',
                                    currentValue: leftDrop,
                                    onConfirm: (v) {
                                      leftDrop = v;
                                      setState(() {});
                                    },
                                  ),
                            ),
                            _inputBox(
                              top: 258,
                              left: 283,
                              display: rightBeamValue,
                              title: 'Right Beam',
                              onTap:
                                  () => _showPicker(
                                    title:
                                        'Right Beam Height',
                                    currentValue: rightDrop,
                                    onConfirm: (v) {
                                      rightDrop = v;
                                      setState(() {});
                                    },
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
                                    onConfirm: (v) {
                                      pointDist = v;
                                      setState(() {});
                                    },
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
                                    currentValue:
                                        apexHeight,
                                    onConfirm: (v) {
                                      apexHeight = v;
                                      setState(() {});
                                    },
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
      }),
    );
  }

  Future<void> _showPicker({
    required String title,
    required double currentValue,
    required ValueChanged<double> onConfirm,
  }) async {
    // Check the input type setting
    final inputType =
        _measurementService.selectedInputType.value;

    if (inputType == 'Numeric') {
      // Show numeric keyboard input
      await _showNumericInput(
        title: title,
        currentValue: currentValue,
        onConfirm: (value) {
          onConfirm(value);
          setState(() {});
        },
      );
    } else {
      // Show CupertinoPicker for Dials input
      await _showCupertinoPicker(
        title: title,
        currentValue: currentValue,
        onConfirm: onConfirm,
      );
    }
  }

  Future<void> _showNumericInput({
    required String title,
    required double currentValue,
    required ValueChanged<double> onConfirm,
  }) async {
    final TextEditingController controller =
        TextEditingController(
          text: currentValue.toString(),
        );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(ctx).size.height * 0.6,
                minHeight: 300,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        2,
                      ),
                    ),
                  ),
                  Container(
                    height: 44,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(
                              context,
                            ).unfocus();
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color:
                                    CupertinoColors
                                        .systemBlue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          title,
                          style: AppTextStyle.titleSmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(
                              context,
                            ).unfocus();
                            final value = double.tryParse(
                              controller.text,
                            );
                            if (value != null &&
                                value >= 0) {
                              onConfirm(value);
                              Navigator.of(ctx).pop();
                            } else {
                              showCupertinoDialog(
                                context: ctx,
                                builder:
                                    (
                                      context,
                                    ) => CupertinoAlertDialog(
                                      title: const Text(
                                        'Invalid Input',
                                      ),
                                      content: const Text(
                                        'Please enter a valid positive number.',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text(
                                            'OK',
                                          ),
                                          onPressed:
                                              () =>
                                                  Navigator.of(
                                                    context,
                                                  ).pop(),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color:
                                    CupertinoColors
                                        .systemBlue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Enter value:',
                          style: AppTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            'Unit: ${_measurementService.getDistanceUnit()}',
                            style: AppTextStyle.bodySmall
                                .copyWith(
                                  color: AppColors
                                      .primaryColor
                                      .withOpacity(0.7),
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CupertinoTextField(
                          controller: controller,
                          keyboardType:
                              TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                          placeholder: '0.00',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleMedium,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryColor,
                            ),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              // Allow numbers, one decimal point, and up to 2 decimal places
                              final regex = RegExp(
                                r'^\d*\.?\d{0,2}$',
                              );
                              if (!regex.hasMatch(value)) {
                                // Remove invalid characters but keep valid decimal input
                                final cleanValue = value
                                    .replaceAll(
                                      RegExp(r'[^\d.]'),
                                      '',
                                    );
                                // Ensure only one decimal point
                                final parts = cleanValue
                                    .split('.');
                                if (parts.length > 2) {
                                  controller.text =
                                      '${parts[0]}.${parts.sublist(1).join('')}';
                                  controller.selection =
                                      TextSelection.fromPosition(
                                        TextPosition(
                                          offset:
                                              controller
                                                  .text
                                                  .length,
                                        ),
                                      );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _showCupertinoPicker({
    required String title,
    required double currentValue,
    required ValueChanged<double> onConfirm,
  }) async {
    final ints = List<int>.generate(
      201,
      (i) => i,
    ); // 0 to 200
    final tenths = List<int>.generate(10, (i) => i);
    final hunds = List<int>.generate(10, (i) => i);

    int i0 = currentValue.floor().clamp(0, 200);
    int i1 = ((currentValue * 10).floor() % 10);
    int i2 = ((currentValue * 100).floor() % 10);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(ctx).size.height * 0.6,
              minHeight: 300,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
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
                          FocusScope.of(context).unfocus();
                          final raw =
                              ints[i0] +
                              tenths[i1] / 10 +
                              hunds[i2] / 100;
                          onConfirm(raw);
                          Navigator.of(ctx).pop();
                          setState(() {});
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
                                        v.toString(),
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
