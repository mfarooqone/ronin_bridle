import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:get/get.dart';

class MeasurementController extends GetxController {
  final MeasurementService _measurementService =
      Get.find<MeasurementService>();
  final PreferencesService _preferencesService =
      Get.find<PreferencesService>();

  // Observable measurement values
  final RxDouble beamDist = 0.00.obs;
  final RxDouble leftLeg = 0.00.obs;
  final RxDouble rightLeg = 0.00.obs;
  final RxDouble leftDrop = 0.00.obs;
  final RxDouble rightDrop = 0.00.obs;
  final RxDouble pointDist = 0.00.obs;
  final RxDouble apexHeight = 0.00.obs;

  // Observable display values
  final RxString beamValue = ''.obs;
  final RxString leftLegValue = ''.obs;
  final RxString rightLegValue = ''.obs;
  final RxString leftBeamValue = ''.obs;
  final RxString rightBeamValue = ''.obs;
  final RxString pointDistanceValue = ''.obs;
  final RxString apexHeightValue = ''.obs;
  final RxString angleValue = '0°'.obs;

  // Track the last unit to detect changes
  String? _lastUnit;

  @override
  void onInit() {
    super.onInit();
    // Initialize the last unit to current unit
    _lastUnit = _measurementService.getMeasurementUnit();
    // Load saved measurement values
    _loadMeasurementValues();
  }

  // Helper function to ensure values are non-negative
  double _clampNonNegative(double value) {
    return value.clamp(0.0, double.infinity);
  }

  // Check and convert values when unit changes
  void checkAndConvertValues(String currentUnit) {
    if (_lastUnit != null && _lastUnit != currentUnit) {
      print(
        'Unit changed from $_lastUnit to $currentUnit - converting values',
      );
      _convertValuesToNewUnit(currentUnit);
    }
    _lastUnit = currentUnit;
  }

  // Convert all values when unit changes
  void _convertValuesToNewUnit(String newUnit) {
    final oldUnit = _lastUnit;

    print('Converting values from $oldUnit to $newUnit');
    print(
      'Before conversion - beamDist: ${beamDist.value}, leftLeg: ${leftLeg.value}',
    );

    if (newUnit == 'Imperial') {
      // Convert from meters to feet
      beamDist.value = beamDist.value * 3.28084;
      leftLeg.value = leftLeg.value * 3.28084;
      rightLeg.value = rightLeg.value * 3.28084;
      leftDrop.value = leftDrop.value * 3.28084;
      rightDrop.value = rightDrop.value * 3.28084;
      pointDist.value = pointDist.value * 3.28084;
      apexHeight.value = apexHeight.value * 3.28084;
    } else {
      // Convert from feet to meters
      beamDist.value = beamDist.value * 0.3048;
      leftLeg.value = leftLeg.value * 0.3048;
      rightLeg.value = rightLeg.value * 0.3048;
      leftDrop.value = leftDrop.value * 0.3048;
      rightDrop.value = rightDrop.value * 0.3048;
      pointDist.value = pointDist.value * 0.3048;
      apexHeight.value = apexHeight.value * 0.3048;
    }

    print(
      'After conversion - beamDist: ${beamDist.value}, leftLeg: ${leftLeg.value}',
    );

    // Save the converted values
    _saveMeasurementValues();
  }

  // Update display values
  void updateDisplayValues() {
    beamValue.value = _measurementService.formatDistance(
      beamDist.value,
    );
    leftLegValue.value = _measurementService.formatDistance(
      leftLeg.value,
    );
    rightLegValue.value = _measurementService
        .formatDistance(rightLeg.value);
    leftBeamValue.value = _measurementService
        .formatDistance(leftDrop.value);
    rightBeamValue.value = _measurementService
        .formatDistance(rightDrop.value);
    pointDistanceValue.value = _measurementService
        .formatDistance(pointDist.value);
    apexHeightValue.value = _measurementService
        .formatDistance(apexHeight.value);
    angleValue.value = '0°';
  }

  // Update individual measurement value
  void updateMeasurementValue(String key, double value) {
    switch (key) {
      case 'beamDist':
        beamDist.value = value;
        break;
      case 'leftLeg':
        leftLeg.value = value;
        break;
      case 'rightLeg':
        rightLeg.value = value;
        break;
      case 'leftDrop':
        leftDrop.value = value;
        break;
      case 'rightDrop':
        rightDrop.value = value;
        break;
      case 'pointDist':
        pointDist.value = value;
        break;
      case 'apexHeight':
        apexHeight.value = value;
        break;
    }
    // Save the updated value
    _saveMeasurementValues();
  }

  // Update multiple measurement values (for drag operations)
  void updateMultipleValues(Map<String, double> updates) {
    updates.forEach((key, value) {
      updateMeasurementValue(key, value);
    });
  }

  // Handle weight drag updates
  void handleWeightVerticalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'leftLeg': leftLeg.value + clampedDelta,
      'rightLeg': rightLeg.value + clampedDelta,
      'apexHeight': apexHeight.value + clampedDelta,
    });
  }

  void handleWeightHorizontalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'leftLeg': leftLeg.value + clampedDelta,
      'rightLeg': rightLeg.value + clampedDelta,
      'pointDist': pointDist.value + clampedDelta,
    });
  }

  // Handle left beam drag updates
  void handleLeftBeamVerticalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'leftDrop': leftDrop.value + clampedDelta,
      'leftLeg': leftLeg.value + clampedDelta,
    });
  }

  void handleLeftBeamHorizontalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'beamDist': beamDist.value + clampedDelta,
      'leftLeg': leftLeg.value + clampedDelta,
    });
  }

  // Handle right beam drag updates
  void handleRightBeamVerticalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'rightDrop': rightDrop.value + clampedDelta,
      'rightLeg': rightLeg.value + clampedDelta,
    });
  }

  void handleRightBeamHorizontalDrag(double delta) {
    final clampedDelta = _clampNonNegative(delta);
    updateMultipleValues({
      'beamDist': beamDist.value + clampedDelta,
      'rightLeg': rightLeg.value + clampedDelta,
    });
  }

  // Save measurement values to preferences
  Future<void> _saveMeasurementValues() async {
    await _preferencesService.saveAllMeasurementValues(
      beamDist: beamDist.value,
      leftLeg: leftLeg.value,
      rightLeg: rightLeg.value,
      leftDrop: leftDrop.value,
      rightDrop: rightDrop.value,
      pointDist: pointDist.value,
      apexHeight: apexHeight.value,
    );
  }

  // Load measurement values from preferences
  Future<void> _loadMeasurementValues() async {
    final values =
        await _preferencesService.getAllMeasurementValues();

    beamDist.value = values['beamDist']!;
    leftLeg.value = values['leftLeg']!;
    rightLeg.value = values['rightLeg']!;
    leftDrop.value = values['leftDrop']!;
    rightDrop.value = values['rightDrop']!;
    pointDist.value = values['pointDist']!;
    apexHeight.value = values['apexHeight']!;

    // Update display values after loading
    updateDisplayValues();
  }

  // Get current measurement values for picker
  Map<String, double> getCurrentValues() {
    return {
      'beamDist': beamDist.value,
      'leftLeg': leftLeg.value,
      'rightLeg': rightLeg.value,
      'leftDrop': leftDrop.value,
      'rightDrop': rightDrop.value,
      'pointDist': pointDist.value,
      'apexHeight': apexHeight.value,
    };
  }

  // Get current input type
  String getCurrentInputType() {
    return _measurementService.selectedInputType.value;
  }

  // Get current unit
  String getCurrentUnit() {
    return _measurementService.selectedUnit.value;
  }
}
