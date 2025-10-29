import 'package:clay_rigging_bridle/features/common/angle_calculation_service.dart';
import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:get/get.dart';

class MeasurementController extends GetxController {
  final MeasurementService _measurementService =
      Get.find<MeasurementService>();
  final PreferencesService _preferencesService =
      Get.find<PreferencesService>();

  // Observable measurement values - Hardcoded for testing
  final RxDouble beamDist = 0.00.obs; // Beam Distance
  final RxDouble leftLeg = 0.00.obs; // Left Leg
  final RxDouble rightLeg = 0.00.obs; // Right Leg
  final RxDouble leftDrop = 0.00.obs; // Left Beam Height
  final RxDouble rightDrop = 0.00.obs; // Right Beam Height
  final RxDouble pointDist = 0.00.obs; // Point Distance
  final RxDouble apexHeight = 0.00.obs; // Apex Height

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

    // Using hardcoded values - skip loading from preferences
    // _loadMeasurementValues();

    // Update display values with hardcoded values
    updateDisplayValues();
  }

  /// TEMPORARY: Clear all values for testing
  /// Remove this method after testing
  // Future<void> _clearAllValuesForTesting() async {
  //   await _preferencesService.resetAllMeasurementValues();
  // }

  // Helper function to ensure values are non-negative
  double _clampNonNegative(double value) {
    return value.clamp(0.0, double.infinity);
  }

  // Check and convert values when unit changes
  void checkAndConvertValues(String currentUnit) {
    if (_lastUnit != null && _lastUnit != currentUnit) {
      _convertValuesToNewUnit(currentUnit);
    }
    _lastUnit = currentUnit;
  }

  // Convert all values when unit changes
  void _convertValuesToNewUnit(String newUnit) {
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

    // Calculate the apex angle using Law of Cosines (SSS method)
    angleValue.value = _calculateApexAngle();
  }

  /// Calculate the apex angle using Law of Cosines
  /// For a rigging bridle, this is the angle at the apex where the two legs meet
  String _calculateApexAngle() {
    // Check if we have valid measurements for angle calculation
    if (leftLeg.value <= 0 ||
        rightLeg.value <= 0 ||
        beamDist.value <= 0) {
      return '0°';
    }

    // Calculate the apex angle using the triangle formed by:
    // - leftLeg (side a)
    // - rightLeg (side b)
    // - beamDistance (side c)
    final apexAngle =
        AngleCalculationService.calculateApexAngle(
          leftLeg.value,
          rightLeg.value,
          beamDist.value,
        );

    // Validate the triangle
    final validation =
        AngleCalculationService.validateTriangle(
          leftLeg.value,
          rightLeg.value,
          beamDist.value,
        );

    if (validation != "Valid triangle") {
      return 'Invalid';
    }

    return AngleCalculationService.formatAngle(apexAngle);
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

    // Update display values including angle calculation
    updateDisplayValues();

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

  // // Load measurement values from preferences
  // Future<void> _loadMeasurementValues() async {
  //   final values =
  //       await _preferencesService.getAllMeasurementValues();

  //   beamDist.value = values['beamDist']!;
  //   leftLeg.value = values['leftLeg']!;
  //   rightLeg.value = values['rightLeg']!;
  //   leftDrop.value = values['leftDrop']!;
  //   rightDrop.value = values['rightDrop']!;
  //   pointDist.value = values['pointDist']!;
  //   apexHeight.value = values['apexHeight']!;

  //   // Update display values after loading
  //   updateDisplayValues();
  // }

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

  /// Get detailed angle information for the rigging bridle configuration
  Map<String, String> getAngleInformation() {
    if (leftLeg.value <= 0 ||
        rightLeg.value <= 0 ||
        beamDist.value <= 0) {
      return {
        'apexAngle': '0°',
        'leftLegAngle': '0°',
        'rightLegAngle': '0°',
        'validation': 'Invalid measurements',
      };
    }

    final apexAngle =
        AngleCalculationService.calculateApexAngle(
          leftLeg.value,
          rightLeg.value,
          beamDist.value,
        );

    final leftLegAngle =
        AngleCalculationService.calculateLeftLegAngle(
          leftLeg.value,
          leftDrop.value,
          beamDist.value,
        );

    final rightLegAngle =
        AngleCalculationService.calculateRightLegAngle(
          rightLeg.value,
          rightDrop.value,
          beamDist.value,
        );

    final validation =
        AngleCalculationService.validateTriangle(
          leftLeg.value,
          rightLeg.value,
          beamDist.value,
        );

    return {
      'apexAngle': AngleCalculationService.formatAngle(
        apexAngle,
      ),
      'leftLegAngle': AngleCalculationService.formatAngle(
        leftLegAngle,
      ),
      'rightLegAngle': AngleCalculationService.formatAngle(
        rightLegAngle,
      ),
      'validation': validation,
    };
  }

  /// Check if the current configuration forms a valid triangle
  bool isValidConfiguration() {
    if (leftLeg.value <= 0 ||
        rightLeg.value <= 0 ||
        beamDist.value <= 0) {
      return false;
    }

    final validation =
        AngleCalculationService.validateTriangle(
          leftLeg.value,
          rightLeg.value,
          beamDist.value,
        );

    return validation == "Valid triangle";
  }

  /// Reset all measurement values to 0 (for testing)
  Future<void> resetAllValues() async {
    beamDist.value = 0.0;
    leftLeg.value = 0.0;
    rightLeg.value = 0.0;
    leftDrop.value = 0.0;
    rightDrop.value = 0.0;
    pointDist.value = 0.0;
    apexHeight.value = 0.0;

    // Update display values
    updateDisplayValues();

    // Save the reset values
    await _saveMeasurementValues();
  }

  /// Set test values for angle calculation testing
  void setTestValues({
    double beamDistance = 35.80,
    double leftLegLength = 91.34,
    double rightLegLength = 91.87,
    double leftBeamHeight = 97.60,
    double rightBeamHeight = 97.69,
    double pointDistance = 16.78,
    double apexHeightValue = 7.81,
  }) {
    beamDist.value = beamDistance;
    leftLeg.value = leftLegLength;
    rightLeg.value = rightLegLength;
    leftDrop.value = leftBeamHeight;
    rightDrop.value = rightBeamHeight;
    pointDist.value = pointDistance;
    apexHeight.value = apexHeightValue;

    // Update display values
    updateDisplayValues();
  }
}
