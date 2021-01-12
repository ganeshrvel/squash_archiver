import 'package:intl/intl.dart';
import 'package:squash_archiver/constants/app_default_values.dart';

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime normalizedDate(DateTime value) {
  return DateTime.utc(value.year, value.month, value.day, 12);
}

String appDateFormat(DateTime date) {
  final formatter = DateFormat(AppDefaultValues.DEFAULT_DATE_TIME_FORMAT);

  return formatter.format(date);
}

String appDateFormatFromString(String value) {
  final _date = DateTime.parse(value);
  final formatter = DateFormat(AppDefaultValues.DEFAULT_DATE_TIME_FORMAT);

  return formatter.format(_date);
}
