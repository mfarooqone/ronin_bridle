import 'package:clay_rigging_bridle/features/bottom_nav_bar/measurement/measurement_controller.dart';
import 'package:clay_rigging_bridle/features/bottom_nav_bar/setting_screen/setting_screen.dart';
import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

/// Measurement page for rigging bridle calculations
/// Allows users to input measurements and see real-time angle calculations
class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  State<MeasurementPage> createState() =>
      _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final MeasurementController _controller = Get.put(
    MeasurementController(),
  );
  final PreferencesService _preferencesService =
      Get.find<PreferencesService>();
  final GlobalKey<ShowCaseWidgetState> _showcaseKey =
      GlobalKey<ShowCaseWidgetState>();
  final GlobalKey _resetShowcaseKey = GlobalKey();
  final GlobalKey _weightDragShowcaseKey = GlobalKey();
  final GlobalKey _leftBeamDragShowcaseKey = GlobalKey();
  final GlobalKey _rightBeamDragShowcaseKey = GlobalKey();
  final GlobalKey _beamInputShowcaseKey = GlobalKey();
  final GlobalKey _angleShowcaseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scheduleShowcase();
  }

  Future<void> _scheduleShowcase() async {
    final hasSeen =
        await _preferencesService
            .isMeasurementShowcaseSeen();
    if (hasSeen || !mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _preferencesService.setMeasurementShowcaseSeen(true);
      _showcaseKey.currentState?.startShowCase([
        _resetShowcaseKey,
        _weightDragShowcaseKey,
        _leftBeamDragShowcaseKey,
        _rightBeamDragShowcaseKey,
        _beamInputShowcaseKey,
        _angleShowcaseKey,
      ]);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      key: _showcaseKey,
      onFinish: () {
        _preferencesService.setMeasurementShowcaseSeen(
          true,
        );
      },
      builder:
          (context) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Obx(() {
              // Check if we need to convert values based on unit change
              _controller.checkAndConvertValues(
                _controller.getCurrentUnit(),
              );

              // Update display values
              _controller.updateDisplayValues();
              return GestureDetector(
                onTap:
                    () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Showcase(
                                    key: _resetShowcaseKey,
                                    title:
                                        'Reset measurements',
                                    description:
                                        'Tap to clear the current readings and start from zero.',
                                    child: IconButton(
                                      onPressed: () async {
                                        // Reset all values to 0
                                        await _controller
                                            .resetAllValues();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'All values reset to 0',
                                            ),
                                            backgroundColor:
                                                AppColors
                                                    .primaryColor,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color:
                                            AppColors
                                                .primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
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
                                  color:
                                      AppColors
                                          .primaryColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Rigging Bridle Measurement',
                            style: AppTextStyle.titleMedium
                                .copyWith(
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors
                                          .primaryColor,
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
                                      AppAssets
                                          .measurementPage,
                                    ),
                                  ),

                                  // weight drag: adjusts both legs & apex
                                  Positioned(
                                    top: 280,
                                    left: 136,
                                    child: Showcase(
                                      key:
                                          _weightDragShowcaseKey,
                                      title:
                                          'Drag the load',
                                      description:
                                          'Slide the weight to change leg lengths, apex height, and point distance.',
                                      child: GestureDetector(
                                        onVerticalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              -d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleWeightVerticalDrag(
                                                delta,
                                              );
                                        },
                                        onHorizontalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleWeightHorizontalDrag(
                                                delta,
                                              );
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 100,
                                          color:
                                              Colors
                                                  .transparent,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // left beam drag: BEAM distances
                                  Positioned(
                                    top: 60,
                                    left: 0,
                                    child: Showcase(
                                      key:
                                          _leftBeamDragShowcaseKey,
                                      title:
                                          'Adjust left beam',
                                      description:
                                          'Drag here to fine-tune the left beam height and the overall span.',
                                      child: GestureDetector(
                                        onVerticalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              -d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleLeftBeamVerticalDrag(
                                                delta,
                                              );
                                        },
                                        onHorizontalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleLeftBeamHorizontalDrag(
                                                delta,
                                              );
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 60,
                                          color:
                                              Colors
                                                  .transparent,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // right beam drag
                                  Positioned(
                                    top: 60,
                                    right: 0,
                                    child: Showcase(
                                      key:
                                          _rightBeamDragShowcaseKey,
                                      title:
                                          'Adjust right beam',
                                      description:
                                          'Use this handle to change the right-side drop and beam distance.',
                                      child: GestureDetector(
                                        onVerticalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              -d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleRightBeamVerticalDrag(
                                                delta,
                                              );
                                        },
                                        onHorizontalDragUpdate: (
                                          d,
                                        ) {
                                          final delta =
                                              d.primaryDelta! /
                                              50;
                                          _controller
                                              .handleRightBeamHorizontalDrag(
                                                delta,
                                              );
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 60,
                                          color:
                                              Colors
                                                  .transparent,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text inputs / pickers
                                  _inputBox(
                                    top: 72,
                                    left: 145,
                                    display:
                                        _controller
                                            .beamValue
                                            .value,
                                    title: 'Beam Distance',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Beam Distance',
                                          currentValue:
                                              _controller
                                                  .beamDist
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'beamDist',
                                                  v,
                                                );
                                          },
                                        ),
                                    showcaseKey:
                                        _beamInputShowcaseKey,
                                    showcaseTitle:
                                        'Review beam distance',
                                    showcaseDescription:
                                        'Tap any field to enter an exact value or fine-tune with the drag controls.',
                                  ),
                                  _inputBox(
                                    top: 208,
                                    left: 80,
                                    display:
                                        _controller
                                            .leftLegValue
                                            .value,
                                    title: 'Left Leg',
                                    onTap:
                                        () => _showPicker(
                                          title: 'Left Leg',
                                          currentValue:
                                              _controller
                                                  .leftLeg
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'leftLeg',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),
                                  _inputBox(
                                    top: 208,
                                    left: 206,
                                    display:
                                        _controller
                                            .rightLegValue
                                            .value,
                                    title: 'Right Leg',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Right Leg',
                                          currentValue:
                                              _controller
                                                  .rightLeg
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'rightLeg',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),
                                  _inputBox(
                                    top: 258,
                                    left: 5,
                                    display:
                                        _controller
                                            .leftBeamValue
                                            .value,
                                    title: 'Left Beam',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Left Beam Height',
                                          currentValue:
                                              _controller
                                                  .leftDrop
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'leftDrop',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),
                                  _inputBox(
                                    top: 258,
                                    left: 283,
                                    display:
                                        _controller
                                            .rightBeamValue
                                            .value,
                                    title: 'Right Beam',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Right Beam Height',
                                          currentValue:
                                              _controller
                                                  .rightDrop
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'rightDrop',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),
                                  _inputBox(
                                    top: 390,
                                    left: 45,
                                    display:
                                        _controller
                                            .pointDistanceValue
                                            .value,
                                    title: 'Point Distance',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Point Distance',
                                          currentValue:
                                              _controller
                                                  .pointDist
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'pointDist',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),
                                  _inputBox(
                                    top: 464,
                                    left: 141,
                                    display:
                                        _controller
                                            .apexHeightValue
                                            .value,
                                    title: 'Apex Height',
                                    onTap:
                                        () => _showPicker(
                                          title:
                                              'Apex Height',
                                          currentValue:
                                              _controller
                                                  .apexHeight
                                                  .value,
                                          onConfirm: (v) {
                                            _controller
                                                .updateMeasurementValue(
                                                  'apexHeight',
                                                  v,
                                                );
                                          },
                                        ),
                                  ),

                                  // Angle output
                                  _outputBox(
                                    top: 152,
                                    left: 145,
                                    display:
                                        _controller
                                            .angleValue
                                            .value,
                                    showcaseKey:
                                        _angleShowcaseKey,
                                    showcaseTitle:
                                        'Apex angle',
                                    showcaseDescription:
                                        'As you change measurements, the bridle angle updates instantly here.',
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
          ),
    );
  }

  Future<void> _showPicker({
    required String title,
    required double currentValue,
    required ValueChanged<double> onConfirm,
  }) async {
    final inputType = _controller.getCurrentInputType();

    if (inputType == 'Numeric') {
      await _showNumericInput(
        title: title,
        currentValue: currentValue,
        onConfirm: onConfirm,
      );
    } else {
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
    final isImperial =
        _controller.getCurrentUnit() == 'Imperial';

    // For Imperial, convert to feet and inches
    final feetController = TextEditingController(text: '0');
    final inchesController = TextEditingController(
      text: '0',
    );

    // For Metric, keep decimal input
    final controller = TextEditingController(
      text: currentValue.toString(),
    );

    if (isImperial) {
      final measurementService =
          Get.find<MeasurementService>();
      final feetInches = measurementService
          .decimalFeetToFeetInches(currentValue);
      feetController.text = feetInches['feet']!.toString();
      inchesController.text =
          feetInches['inches']!.toString();
    }

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
                minHeight: isImperial ? 350 : 300,
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
                            double value;

                            if (isImperial) {
                              final measurementService =
                                  Get.find<
                                    MeasurementService
                                  >();
                              final feet =
                                  int.tryParse(
                                    feetController.text,
                                  ) ??
                                  0;
                              final inches =
                                  int.tryParse(
                                    inchesController.text,
                                  ) ??
                                  0;
                              value = measurementService
                                  .feetInchesToDecimalFeet(
                                    feet,
                                    inches,
                                  );
                            } else {
                              value =
                                  double.tryParse(
                                    controller.text,
                                  ) ??
                                  0.0;
                            }

                            if (value >= 0) {
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
                                        'Please enter valid positive numbers.',
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
                          isImperial
                              ? 'Enter feet and inches:'
                              : 'Enter value:',
                          style: AppTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            'Unit: ${_controller.getCurrentUnit()}',
                            style: AppTextStyle.bodySmall
                                .copyWith(
                                  color: AppColors
                                      .primaryColor
                                      .withOpacity(0.7),
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isImperial) ...[
                          // Imperial: Feet and inches input
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Feet',
                                      style:
                                          AppTextStyle
                                              .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CupertinoTextField(
                                      controller:
                                          feetController,
                                      keyboardType:
                                          TextInputType
                                              .number,
                                      placeholder: '0',
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          AppTextStyle
                                              .titleMedium,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*$'),
                                        ),
                                      ],
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              AppColors
                                                  .primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(
                                              8,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Inches',
                                      style:
                                          AppTextStyle
                                              .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CupertinoTextField(
                                      controller:
                                          inchesController,
                                      keyboardType:
                                          TextInputType
                                              .number,
                                      placeholder: '0',
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          AppTextStyle
                                              .titleMedium,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*$'),
                                        ),
                                      ],
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              AppColors
                                                  .primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(
                                              8,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Metric: Decimal input
                          CupertinoTextField(
                            controller: controller,
                            keyboardType:
                                TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                            placeholder: '0.00',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.titleMedium,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}$'),
                              ),
                            ],
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    AppColors.primaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final cleanValue = value
                                    .replaceAll(
                                      RegExp(r'[^\d.]'),
                                      '',
                                    );
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
                                  return;
                                }

                                if (parts.length == 2 &&
                                    parts[1].length > 2) {
                                  controller.text =
                                      '${parts[0]}.${parts[1].substring(0, 2)}';
                                  controller.selection =
                                      TextSelection.fromPosition(
                                        TextPosition(
                                          offset:
                                              controller
                                                  .text
                                                  .length,
                                        ),
                                      );
                                  return;
                                }

                                if (controller.text !=
                                    cleanValue) {
                                  controller.text =
                                      cleanValue;
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
                            },
                          ),
                        ],
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
    final isImperial =
        _controller.getCurrentUnit() == 'Imperial';

    if (isImperial) {
      final measurementService =
          Get.find<MeasurementService>();
      final feetInches = measurementService
          .decimalFeetToFeetInches(currentValue);
      int feetIndex = feetInches['feet']!.clamp(0, 200);
      int inchesIndex = feetInches['inches']!.clamp(0, 11);
      final feet = List<int>.generate(201, (i) => i);
      final inches = List<int>.generate(12, (i) => i);

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
                  SizedBox(
                    height: 44,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding:
                              const EdgeInsets.symmetric(
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
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                          child: const Text('Done'),
                          onPressed: () {
                            FocusScope.of(
                              context,
                            ).unfocus();
                            final value = measurementService
                                .feetInchesToDecimalFeet(
                                  feet[feetIndex],
                                  inches[inchesIndex],
                                );
                            onConfirm(value);
                            Navigator.of(ctx).pop();
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
                                  initialItem: feetIndex,
                                ),
                            itemExtent: 32,
                            onSelectedItemChanged:
                                (x) => feetIndex = x,
                            children:
                                feet
                                    .map(
                                      (v) => Center(
                                        child: Text(
                                          '$v ft',
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
                                  initialItem: inchesIndex,
                                ),
                            itemExtent: 32,
                            onSelectedItemChanged:
                                (x) => inchesIndex = x,
                            children:
                                inches
                                    .map(
                                      (v) => Center(
                                        child: Text(
                                          '$v in',
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
      return;
    }

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
    GlobalKey? showcaseKey,
    String? showcaseTitle,
    String? showcaseDescription,
  }) => Positioned(
    top: top,
    left: left,
    child:
        showcaseKey != null
            ? Showcase(
              key: showcaseKey,
              title: showcaseTitle ?? '',
              description: showcaseDescription ?? '',
              child: _InputBoxContent(
                onTap: onTap,
                display: display,
              ),
            )
            : _InputBoxContent(
              onTap: onTap,
              display: display,
            ),
  );

  Widget _outputBox({
    required double top,
    required double left,
    required String display,
    GlobalKey? showcaseKey,
    String? showcaseTitle,
    String? showcaseDescription,
  }) => Positioned(
    top: top,
    left: left,
    child:
        showcaseKey != null
            ? Showcase(
              key: showcaseKey,
              title: showcaseTitle ?? '',
              description: showcaseDescription ?? '',
              child: _OutputBoxContent(display: display),
            )
            : _OutputBoxContent(display: display),
  );
}

class _InputBoxContent extends StatelessWidget {
  const _InputBoxContent({
    required this.onTap,
    required this.display,
  });

  final VoidCallback onTap;
  final String display;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 40,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(display, style: AppTextStyle.bodySmall),
      ),
    );
  }
}

class _OutputBoxContent extends StatelessWidget {
  const _OutputBoxContent({required this.display});

  final String display;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 40,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text(display, style: AppTextStyle.bodySmall),
    );
  }
}
