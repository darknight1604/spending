import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeConverter();
  @override
  DateTime? fromJson(dynamic json) {
    if (json is! Timestamp? && json is! String?) return null;
    if (json is Timestamp?) {
      return json?.toDate();
    }
    if (StringUtil.isNullOrEmpty(json)) return null;
    return DateTime.parse(json!);
  }

  @override
  dynamic toJson(DateTime? object) {
    return object == null ? null : Timestamp.fromDate(object);
  }
}

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();
  @override
  DateTime? fromJson(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }

  @override
  Timestamp? toJson(DateTime? object) {
    return object == null ? null : Timestamp.fromDate(object);
  }
}
