import 'package:fraction/fraction.dart';

/// Adds [MixedFraction] functionalities to [String].
extension MixedFractionString on String {
  /// Checks whether a string contains a valid representation of a mixed fraction
  /// in the format 'a b/c'.
  ///
  ///  * 'a', 'b' and 'c' must be integers;
  ///  * there can be the minus sign only in front of a;
  ///  * there must be exactly one space between the whole part and the fraction.
  bool isMixedFraction() {
    try {
      MixedFraction.fromString(this);
      return true;
    } on MixedFractionException {
      return false;
    }
  }

  /// Converts the given string into a [MixedFraction] object.
  ///
  /// If you want to be sure that this method doesn't throw a [MixedFractionException],
  /// use `isFraction()` before.
  MixedFraction toMixedFraction() => MixedFraction.fromString(this);
}
