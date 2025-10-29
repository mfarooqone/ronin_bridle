import 'package:clay_rigging_bridle/features/common/preferences_service.dart';
import 'package:get/get.dart';

class MeasurementService extends GetxController {
  static MeasurementService get to => Get.find();

  final RxString selectedUnit = 'Metric'.obs;
  final RxString selectedInputType = 'Numeric'.obs;

  static const double feetToMeters = 0.3048;
  static const double metersToFeet = 3.28084;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  // Save all preferences
  Future<void> _savePreferences() async {
    final preferencesService =
        Get.find<PreferencesService>();
    await preferencesService.saveUnit(selectedUnit.value);
    await preferencesService.saveInputType(
      selectedInputType.value,
    );
  }

  // Load all preferences
  Future<void> _loadPreferences() async {
    final preferencesService =
        Get.find<PreferencesService>();
    selectedUnit.value = await preferencesService.getUnit();
    selectedInputType.value =
        await preferencesService.getInputType();
  }

  double convertDistance(double valueInMeters) {
    if (selectedUnit.value == 'Imperial') {
      return valueInMeters * metersToFeet;
    }
    return valueInMeters;
  }

  double convertDistanceFromImperial(double valueInFeet) {
    if (selectedUnit.value == 'Metric') {
      return valueInFeet * feetToMeters;
    }
    return valueInFeet;
  }

  String getDistanceUnit() {
    return selectedUnit.value == 'Imperial' ? 'ft' : 'm';
  }

  String formatDistance(double value) {
    final unit = getDistanceUnit();

    if (selectedUnit.value == 'Imperial') {
      // Convert decimal feet to feet and inches
      final feet = value.floor();
      final inches = ((value - feet) * 12).round();

      if (inches == 0) {
        return '$feet${unit}';
      } else {
        return '$feet${unit} ${inches}in';
      }
    }

    return '${value.toStringAsFixed(2)} $unit';
  }

  // Convert feet and inches to decimal feet
  double feetInchesToDecimalFeet(int feet, int inches) {
    return feet + (inches / 12.0);
  }

  // Convert decimal feet to feet and inches
  Map<String, int> decimalFeetToFeetInches(double value) {
    final feet = value.floor();
    final inches = ((value - feet) * 12).round();
    return {'feet': feet, 'inches': inches};
  }

  void setMeasurementUnit(String unit) {
    selectedUnit.value = unit;
    _savePreferences(); // Save automatically when unit changes
  }

  String getMeasurementUnit() {
    return selectedUnit.value;
  }

  void setInputType(String inputType) {
    selectedInputType.value = inputType;
    _savePreferences(); // Save automatically when input type changes
  }

  String getInputType() {
    return selectedInputType.value;
  }
}
