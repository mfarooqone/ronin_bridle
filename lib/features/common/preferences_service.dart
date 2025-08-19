import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends GetxController {
  static PreferencesService get to => Get.find();

  // Keys for different types of preferences
  static const String _unitKey = 'selectedUnit';
  static const String _inputTypeKey = 'selectedInputType';
  static const String _beamDistKey = 'beamDist';
  static const String _leftLegKey = 'leftLeg';
  static const String _rightLegKey = 'rightLeg';
  static const String _leftDropKey = 'leftDrop';
  static const String _rightDropKey = 'rightDrop';
  static const String _pointDistKey = 'pointDist';
  static const String _apexHeightKey = 'apexHeight';

  // Default values
  static const String _defaultUnit = 'Metric';
  static const String _defaultInputType = 'Numeric';
  static const double _defaultBeamDist = 2.68;
  static const double _defaultLeftLeg = 1.90;
  static const double _defaultRightLeg = 2.98;
  static const double _defaultLeftDrop = 1.94;
  static const double _defaultRightDrop = 1.47;
  static const double _defaultPointDist = 0.07;
  static const double _defaultApexHeight = 0.00;

  // Measurement settings
  Future<void> saveUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  Future<String> getUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey) ?? _defaultUnit;
  }

  Future<void> saveInputType(String inputType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inputTypeKey, inputType);
  }

  Future<String> getInputType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_inputTypeKey) ??
        _defaultInputType;
  }

  // Measurement values
  Future<void> saveBeamDist(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_beamDistKey, value);
  }

  Future<double> getBeamDist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_beamDistKey) ??
        _defaultBeamDist;
  }

  Future<void> saveLeftLeg(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_leftLegKey, value);
  }

  Future<double> getLeftLeg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_leftLegKey) ?? _defaultLeftLeg;
  }

  Future<void> saveRightLeg(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_rightLegKey, value);
  }

  Future<double> getRightLeg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_rightLegKey) ??
        _defaultRightLeg;
  }

  Future<void> saveLeftDrop(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_leftDropKey, value);
  }

  Future<double> getLeftDrop() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_leftDropKey) ??
        _defaultLeftDrop;
  }

  Future<void> saveRightDrop(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_rightDropKey, value);
  }

  Future<double> getRightDrop() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_rightDropKey) ??
        _defaultRightDrop;
  }

  Future<void> savePointDist(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pointDistKey, value);
  }

  Future<double> getPointDist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_pointDistKey) ??
        _defaultPointDist;
  }

  Future<void> saveApexHeight(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_apexHeightKey, value);
  }

  Future<double> getApexHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_apexHeightKey) ??
        _defaultApexHeight;
  }

  // Save all measurement values at once
  Future<void> saveAllMeasurementValues({
    required double beamDist,
    required double leftLeg,
    required double rightLeg,
    required double leftDrop,
    required double rightDrop,
    required double pointDist,
    required double apexHeight,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setDouble(_beamDistKey, beamDist),
      prefs.setDouble(_leftLegKey, leftLeg),
      prefs.setDouble(_rightLegKey, rightLeg),
      prefs.setDouble(_leftDropKey, leftDrop),
      prefs.setDouble(_rightDropKey, rightDrop),
      prefs.setDouble(_pointDistKey, pointDist),
      prefs.setDouble(_apexHeightKey, apexHeight),
    ]);
  }

  // Load all measurement values at once
  Future<Map<String, double>>
  getAllMeasurementValues() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'beamDist':
          prefs.getDouble(_beamDistKey) ?? _defaultBeamDist,
      'leftLeg':
          prefs.getDouble(_leftLegKey) ?? _defaultLeftLeg,
      'rightLeg':
          prefs.getDouble(_rightLegKey) ?? _defaultRightLeg,
      'leftDrop':
          prefs.getDouble(_leftDropKey) ?? _defaultLeftDrop,
      'rightDrop':
          prefs.getDouble(_rightDropKey) ??
          _defaultRightDrop,
      'pointDist':
          prefs.getDouble(_pointDistKey) ??
          _defaultPointDist,
      'apexHeight':
          prefs.getDouble(_apexHeightKey) ??
          _defaultApexHeight,
    };
  }

  // Clear all preferences (for testing or reset)
  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
