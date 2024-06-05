// write a extension to remove time from DateTime in dart
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime removeTime() {
    return DateTime(year, month, day);
  }

  DateTime addDate(int? count) {
    if (count == null) return DateTime(year, month, day + 1);
    return DateTime(year, month, day + count);
  }

  DateTime subtractDate(int? count) {
    if (count == null) return DateTime(year, month, day - 1);
    return DateTime(year, month, day - count);
  }

  String to24HourString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  DateTime parseDate(DateTime lastDate) {
    if (_isSameOrNextDay(this, lastDate)) {
      return add(const Duration(days: 1));
    }

    return this;
  }

  bool _isSameOrNextDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime2.isAfter(dateTime1) ||
        dateTime2.isAtSameMomentAs(dateTime1);
  }

  double toDouble() {
    return hour + (minute / 60);
  }
}

extension ToString on double {
  String toStringWithMaxPrecision({int? maxDigits}) {
    if (round() == this) {
      return round().toString();
    } else {
      if (maxDigits == null) {
        return toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      } else {
        return toStringAsFixed(maxDigits)
            .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      }
    }
  }
}

extension NumToString on num {
  String toStringWithMaxPrecision({int? maxDigits}) {
    if (round() == this) {
      return round().toString();
    } else {
      if (maxDigits == null) {
        return toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      } else {
        return toStringAsFixed(maxDigits)
            .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      }
    }
  }
}

extension CommaFormattors on num {
  String toCommaFormat() {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    ).format(this);
  }
}
