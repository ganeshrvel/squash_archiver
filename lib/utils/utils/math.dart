import 'dart:math' as math;

/// Returns the maximum value from the given iterable of [double] values.
///
/// [getDoubleMax] takes an [Iterable] of [double] values as input and returns
/// the maximum value present in the collection.
///
/// - [_array]: An iterable of [double] values for which the maximum value needs to be found.
///
/// Example:
/// ```dart
/// final list = [2.5, 3.1, 1.8, 5.0, 4.2];
/// final max = getDoubleMax(list); // Result: 5.0
/// ```
double getDoubleMax(Iterable<double> _array) {
  return _array.reduce(math.max);
}

/// Returns the minimum value from the given iterable of [double] values.
///
/// [getDoubleMin] takes an [Iterable] of [double] values as input and returns
/// the minimum value present in the collection.
///
/// - [_array]: An iterable of [double] values for which the minimum value needs to be found.
///
/// Example:
/// ```dart
/// final list = [2.5, 3.1, 1.8, 5.0, 4.2];
/// final min = getDoubleMin(list); // Result: 1.8
/// ```
double getDoubleMin(Iterable<double> _array) {
  return _array.reduce(math.min);
}

/// Checks if the given [value] is within the specified range defined by [min] and [max].
///
/// [isWithinRange] function checks if a given numeric [value] is within the specified
/// range defined by [min] and [max].
///
/// - [value]: The numeric value that needs to be checked.
/// - [min]: The minimum value of the range (inclusive).
/// - [max]: The maximum value of the range (inclusive or exclusive based on [inclusiveOfMax]).
///   This parameter is optional and can be set to `null`.
/// - [inclusiveOfMax]: An optional boolean flag indicating whether the [max] value is considered
///   part of the range (default is `true`).
///
/// Returns `true` if [value] is within the specified range; otherwise, returns `false`.
///
/// Example:
/// ```dart
/// final value = 10;
/// final min = 5;
/// final max = 15;
/// final withinRange = isWithinRange(value: value, min: min, max: max); // Result: true
/// ```
bool isWithinRange<T extends num>({
  required T value,
  required T min,
  required T max,
  bool inclusiveOfMax = true,
}) {
  if (inclusiveOfMax) {
    return value >= min && value <= max;
  }

  return value >= min && value < max;
}

/// Coerces the given [value] to be within the specified range defined by [min] and optional [max].
///
/// [coerceIn] function restricts a numeric [value] to be within the specified range
/// defined by [min] and optional [max].
///
/// - [value]: The numeric value that needs to be coerced within the range.
/// - [min]: The minimum value of the range.
/// - [max]: The maximum value of the range.
///   This parameter is optional and can be set to `null`.
///
/// Returns the coerced value, ensuring it lies within the specified range.
///
/// Example:
/// ```dart
/// final value = 25;
/// final min = 10;
/// final max = 20;
/// final coercedValue = coerceIn(value: value, min: min, max: max); // Result: 20
/// ```
T coerceIn<T extends num>({
  required T value,
  required T min,
  required T? max,
}) {
  if (value < min) return min;
  if (max != null && value > max) return math.max(min, max);
  return value;
}
