import 'package:fraction/fraction.dart';

/// Dart representation of a mixed fraction which is composed by the whole part
/// and a proper fraction. A proper fraction is a fraction in which the relation
/// `numerator <= denominator` is true.
///
/// There's the possibility to create an instance of [MixedFraction] either by
/// using one of the constructors or by using the extension methods on [num] and
/// [String].
///
/// ```dart
/// final f = MixedFraction.fromDouble(1.5);
/// final f = MixedFraction.fromString("1 1/2");
/// ```
///
/// is equivalent to
///
/// ```dart
/// final f = 1.5.toMixedFraction();
/// final f = "1 1/2".toMixedFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [MixedFractionException]
/// is thrown.
class MixedFraction implements Comparable<MixedFraction> {
  /// Whole part of the mixed fraction
  late final int whole;

  /// Numerator of the fraction
  late final int numerator;

  /// Denominator of the fraction
  late final int denominator;

  /// Creates an instance of a mixed fraction. If the numerator isn't greater than
  /// the denominator, the values are automatically transformed so that a valid
  /// mixed fraction is created. For example:
  ///
  /// ```dart
  /// final m = MixedFraction(1, 7, 3);
  /// ```
  ///
  /// In this case, the object `m` is built as '3 1/3' rather than '1 7/3' since
  /// the latter format is invalid.
  MixedFraction(
      {required int whole, required int numerator, required int denominator}) {
    // Denominator cannot be zero
    if (denominator == 0) {
      throw MixedFractionException('The denominator cannot be zero');
    }

    // The sign of the fractional part doesn't persist on the fraction itself;
    // the negative sign only applies (by convention) to the whole part
    final sign = Fraction(numerator, denominator).isNegative ? -1 : 1;
    final absNumerator = numerator.abs();
    final absDenominator = denominator.abs();

    // In case the numerator were greater than the denominator, there's the need
    // to transform the fraction and make it proper. The sign whole part may
    // change depending on the sign of the fractional part.
    if (absNumerator > absDenominator) {
      this.whole = (absNumerator ~/ absDenominator + whole) * sign;
      this.numerator = absNumerator % absDenominator;
      this.denominator = absDenominator;
    } else {
      this.whole = whole * sign;
      this.numerator = absNumerator;
      this.denominator = absDenominator;
    }
  }

  /// Creates an instance of a mixed fraction.
  factory MixedFraction.fromFraction(Fraction fraction) =>
    fraction.toMixedFraction();

  /// Creates an instance of a mixed fraction. The input string must be in the
  /// form 'a b/c' with exactly one space between the whole part and the fraction.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'.
  factory MixedFraction.fromString(String value) {
    const errorObj = MixedFractionException("The string must be in the form 'a "
        "b/c' with exactly one space between the whole part and the fraction");

    // Check for the space
    if (!value.contains(' ')) throw errorObj;

    /*
     * The 'parts' array must contain exactly 2 pieces:
     *  > parts[0]: the whole part (an integer)
     *  > parts[1]: the fraction (a string)
     * */
    final parts = value.split(" ");

    if (parts.length != 2) throw errorObj;

    /*
     * At this point the string is made up of 2 "parts" separated by a space. An
     * exception can occur only if the second part is a malformed string (not a
     * fraction)
     * */
    final fraction = Fraction.fromString(parts[1]);

    // Fixing the potential negative signs
    return MixedFraction(
      whole: int.parse(parts[0]),
      numerator: fraction.numerator,
      denominator: fraction.denominator,
    );
  }

  @override

  /// Two mixed fractions are equal if their "cross product" is equal.
  ///
  /// ```dart
  /// final one = Fraction(1, 2);
  /// final two = Fraction(2, 4);
  ///
  /// print(one == two); //true
  /// ```
  ///
  /// The above example returns true because the "cross product" of `one` and
  /// two` is equal (1*4 = 2*2).
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is MixedFraction) {
      final mixedFraction = other;

      return runtimeType == mixedFraction.runtimeType &&
          whole == mixedFraction.whole &&
          toFraction() == mixedFraction.toFraction();
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;

    result = 31 * result + whole.hashCode;
    result = 31 * result + numerator.hashCode;
    result = 31 * result + denominator.hashCode;

    return result;
  }

  @override
  int compareTo(other) {
    if (toDouble() < other.toDouble()) return -1;

    if (toDouble() > other.toDouble()) return 1;

    return 0;
  }

  @override
  String toString() {
    if (_negative) {
      return "-$whole $numerator/$denominator";
    } else {
      return "$whole $numerator/$denominator";
    }
  }

  /// Floating point representation of the mixed fraction.
  double toDouble() {
    if (_negative) {
      return -(whole + numerator / denominator);
    } else {
      return whole + numerator / denominator;
    }
  }

  /// Converts this mixed fraction into a fraction.
  Fraction toFraction() => Fraction.fromMixedFraction(this);

  /// If true, when the fraction is converted into a double or a string the minus
  /// sign has to be applied.
  var _negative = false;

  /// True or false whether the mixed fraction is positive or negative.
  bool get isNegative => _negative;

  /// Reduces this mixed fraction to the lowest terms and returns the results in
  /// a new [MixedFraction] instance.
  MixedFraction reduce() {
    final fractionalPart = Fraction(numerator, denominator).reduce();

    return MixedFraction(
      whole: whole,
      numerator: fractionalPart.numerator,
      denominator: fractionalPart.denominator,
    );
  }

  /// Changes the sign of this mixed fraction and returns the results in a new
  /// [MixedFraction] instance.
  MixedFraction negate() => MixedFraction(
      whole: whole, numerator: numerator * -1, denominator: denominator);
}
