import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String formatDDMMYYYYHHMMSS() {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(this);
  }

  String formatHHMMSSDDMMYYYY() {
    return DateFormat("hh:mm:ss yyyy-MM-dd").format(this);
  }

  String formatDDMMYYYY() {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String formatYYYYMMPlain() {
    return DateFormat("yyyyMM").format(this);
  }

  /// Compare two days by yyyy-mm-dd
  ///
  bool isEqualByYYYYMMDD(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  String get monthTitle {
    switch (month) {
      case DateTime.january:
        return tr(LocaleKeys.common_month_january);
      case DateTime.february:
        return tr(LocaleKeys.common_month_february);
      case DateTime.march:
        return tr(LocaleKeys.common_month_march);
      case DateTime.april:
        return tr(LocaleKeys.common_month_april);
      case DateTime.may:
        return tr(LocaleKeys.common_month_may);
      case DateTime.june:
        return tr(LocaleKeys.common_month_june);
      case DateTime.july:
        return tr(LocaleKeys.common_month_july);
      case DateTime.august:
        return tr(LocaleKeys.common_month_august);
      case DateTime.september:
        return tr(LocaleKeys.common_month_september);
      case DateTime.october:
        return tr(LocaleKeys.common_month_october);
      case DateTime.november:
        return tr(LocaleKeys.common_month_november);
      default:
        return tr(LocaleKeys.common_month_december);
    }
  }

  DateTime get beginOfDate {
    return DateTime(year, month, day);
  }

  DateTime get endOfDate {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
}
