import 'package:get/get.dart';

class MeasurementService extends GetxController {
  static MeasurementService get to => Get.find();

  final RxString selectedUnit = 'Metric'.obs;

  static const double feetToMeters = 0.3048;
  static const double metersToFeet = 3.28084;

  @override
  void onInit() {
    super.onInit();
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
    return '${value.toStringAsFixed(2)} $unit';
  }

  void setMeasurementUnit(String unit) {
    selectedUnit.value = unit;
  }

  String getMeasurementUnit() {
    return selectedUnit.value;
  }
}
