import 'dart:math';

/// Service for calculating triangle angles using the Law of Cosines (SSS method)
class AngleCalculationService {
  static const double _radiansToDegrees = 180.0 / pi;

  /// Calculate angle A using Law of Cosines: cos(A) = (b² + c² - a²) / (2bc)
  /// where a is opposite to angle A, b and c are the other sides
  static double calculateAngleA(
    double sideA,
    double sideB,
    double sideC,
  ) {
    if (!_isValidTriangle(sideA, sideB, sideC)) {
      return 0.0;
    }

    final cosA =
        (sideB * sideB + sideC * sideC - sideA * sideA) /
        (2 * sideB * sideC);
    // Clamp to avoid numerical errors that could cause acos to fail
    final clampedCosA = cosA.clamp(-1.0, 1.0);
    return acos(clampedCosA) * _radiansToDegrees;
  }

  /// Calculate angle B using Law of Cosines: cos(B) = (a² + c² - b²) / (2ac)
  static double calculateAngleB(
    double sideA,
    double sideB,
    double sideC,
  ) {
    if (!_isValidTriangle(sideA, sideB, sideC)) {
      return 0.0;
    }

    final cosB =
        (sideA * sideA + sideC * sideC - sideB * sideB) /
        (2 * sideA * sideC);
    final clampedCosB = cosB.clamp(-1.0, 1.0);
    return acos(clampedCosB) * _radiansToDegrees;
  }

  /// Calculate angle C using Law of Cosines: cos(C) = (a² + b² - c²) / (2ab)
  static double calculateAngleC(
    double sideA,
    double sideB,
    double sideC,
  ) {
    if (!_isValidTriangle(sideA, sideB, sideC)) {
      return 0.0;
    }

    final cosC =
        (sideA * sideA + sideB * sideB - sideC * sideC) /
        (2 * sideA * sideB);
    final clampedCosC = cosC.clamp(-1.0, 1.0);
    return acos(clampedCosC) * _radiansToDegrees;
  }

  /// Calculate all three angles of a triangle given its three sides
  /// Returns a map with angles A, B, C in degrees
  static Map<String, double> calculateAllAngles(
    double sideA,
    double sideB,
    double sideC,
  ) {
    return {
      'A': calculateAngleA(sideA, sideB, sideC),
      'B': calculateAngleB(sideA, sideB, sideC),
      'C': calculateAngleC(sideA, sideB, sideC),
    };
  }

  /// Validate if three sides can form a valid triangle using the triangle inequality theorem
  /// For sides a, b, c: a + b > c, a + c > b, b + c > a
  static bool _isValidTriangle(
    double sideA,
    double sideB,
    double sideC,
  ) {
    if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
      return false;
    }

    return (sideA + sideB > sideC) &&
        (sideA + sideC > sideB) &&
        (sideB + sideC > sideA);
  }

  /// Check if triangle is valid and return validation message
  static String validateTriangle(
    double sideA,
    double sideB,
    double sideC,
  ) {
    if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
      return "All sides must be positive";
    }

    if (sideA + sideB <= sideC) {
      return "Side A + Side B must be greater than Side C";
    }

    if (sideA + sideC <= sideB) {
      return "Side A + Side C must be greater than Side B";
    }

    if (sideB + sideC <= sideA) {
      return "Side B + Side C must be greater than Side A";
    }

    return "Valid triangle";
  }

  /// Format angle in degrees with specified decimal places
  static String formatAngle(
    double angleInDegrees, {
    int decimalPlaces =
        0, // Changed from 1 to 0 for whole numbers
  }) {
    return '${angleInDegrees.round()}°'; // Use round() for whole numbers
  }

  /// Calculate the apex angle for a rigging bridle configuration
  /// This is the angle at the apex point where the two legs meet
  /// In a rigging bridle, this is the angle between the two legs
  static double calculateApexAngle(
    double leftLeg,
    double rightLeg,
    double beamDistance,
  ) {
    // For rigging bridle, the apex angle is the angle between the two legs
    // We calculate this using the Law of Cosines
    // The triangle is formed by: leftLeg, rightLeg, and beamDistance
    // The apex angle is the angle opposite to the beamDistance

    if (!_isValidTriangle(
      leftLeg,
      rightLeg,
      beamDistance,
    )) {
      return 0.0;
    }

    // Using Law of Cosines: cos(C) = (a² + b² - c²) / (2ab)
    // where C is the angle opposite to side c (beamDistance)
    // a = leftLeg, b = rightLeg, c = beamDistance
    final cosC =
        (leftLeg * leftLeg +
            rightLeg * rightLeg -
            beamDistance * beamDistance) /
        (2 * leftLeg * rightLeg);

    // Clamp to avoid numerical errors
    final clampedCosC = cosC.clamp(-1.0, 1.0);
    return acos(clampedCosC) * _radiansToDegrees;
  }

  /// Calculate the angle between left leg and horizontal (beam)
  static double calculateLeftLegAngle(
    double leftLeg,
    double leftDrop,
    double beamDistance,
  ) {
    // This is angle A in triangle formed by leftLeg, leftDrop, and portion of beamDistance
    // We need to calculate the horizontal distance from left beam to apex
    final leftHorizontalDistance =
        beamDistance /
        2; // Assuming symmetric configuration
    return calculateAngleA(
      leftDrop,
      leftLeg,
      leftHorizontalDistance,
    );
  }

  /// Calculate the angle between right leg and horizontal (beam)
  static double calculateRightLegAngle(
    double rightLeg,
    double rightDrop,
    double beamDistance,
  ) {
    // This is angle B in triangle formed by rightLeg, rightDrop, and portion of beamDistance
    final rightHorizontalDistance =
        beamDistance /
        2; // Assuming symmetric configuration
    return calculateAngleB(
      rightDrop,
      rightLeg,
      rightHorizontalDistance,
    );
  }
}
