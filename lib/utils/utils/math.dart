import 'dart:math' as math;

double getDoubleMax(Iterable<double> _array) {
  return _array.reduce(math.max);
}

double getDoubleMin(Iterable<double> _array) {
  return _array.reduce(math.min);
}
