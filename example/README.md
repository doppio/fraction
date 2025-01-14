You can create an instance of `Fraction` using one of its constructors.

 - Basic: it just requires the numerator and/or the denominator.

   ```dart
   final frac = Fraction(3, 5); // 3/5
   final frac = Fraction(3, 1); // 3
   ```

 - String: pass the fraction as a string but it has to be well-formed otherwise an exception is
   thrown.

   ```dart
   final frac1 = Fraction.fromString("2/4"); // 2/4
   final frac2 = Fraction.fromString("-2/4"); // -2/4
   final frac3 = Fraction.fromString("2/-4"); // Error
   final frac4 = Fraction.fromString("-2"); // -2/1
   ```

 - double: represents a double as a fraction. Note that irrational numbers cannot be converted into
   a fraction by definition; the constructor has the `precision` parameter which decides how precise
   the representation has to be.

   ```dart
   final frac1 = Fraction.fromDouble(1.5); // 3/2
   final frac2 = Fraction.fromString(-8.5); // -17/2
   final frac3 = Fraction.fromString(math.pi); // 208341/66317
   final frac4 = Fraction.fromString(math.pi, 1.0E-4); // 333/106
   ```

   The constant `pi` cannot be represented as a fraction because it's an irrational number. The constructor considers only `precison` decimal digits to create a fraction. With rational numbers instead you don't have problems.

Thanks to extension methods you can also create a `Fraction` object "on the fly" by calling the `toFraction()` method on a number or a string.

```dart
final f1 = 5.toFraction(); // 5/1
final f2 = 1.5.toFraction(); // 3/2
final f3 = "6/5".toFraction(); // 6/5
```

You can easily sum, subtract, multiply and divide fractions thanks to the operators:

```dart
final f1 = Fraction(5, 7);
final f2 = Fraction(1, 5);

final sum = f1 + f2; // -> 5/7 + 1/5
final sub = f1 - f2; // -> 5/7 - 1/5
final mul = f1 * f2; // -> 5/7 * 1/5
final div = f1 / f2; // -> 5/7 / 1/5
```

The method `reduce()` reduces the fraction to the lowest terms.

```dart
final fraction = Fraction.fromString("12/20");  // 12/20
final reduced = fraction.reduce();              // 3/5
```

Two fractions are equal if their "cross product" is equal. For example `1/2` and `3/6` are said to be
equivalent because `1*6 = 3*2` (and in fact `3/6` is the same as `1/2`). The API is very wide:

```dart
final fraction1 = Fraction(10, 2).toDouble();  // 5.0
final fraction2 = Fraction(10, 2).inverse();   // 2/10
final fraction3 = Fraction(1, 15).isWhole;     // false

final sum = fraction1 + fraction3; // 76/15
```

## Working with mixed fractions

A mixed fraction is made up of a whole part and a proper fraction (a fraction in which numerator <= denominator). It's easy to build a `MixedFraction` object:

```dart
final f1 = MixedFraction(3, 4, 7);
final f2 = MixedFraction.fromDouble(1.5);
final f3 = MixedFraction.fromString("1 1/2");
```

There is also the possibility to initialize a `MixedFraction` using extension methods:

```dart
final f1 = "1 1/2".toMixedFraction();
```

If you try to create an instance in which the numerator is greater than the denominator, a `MixedFractionException` is thrown.