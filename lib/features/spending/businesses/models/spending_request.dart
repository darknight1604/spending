import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/converters/date_time_converter.dart';
part 'spending_request.g.dart';

@JsonSerializable()
class SpendingRequest {
  int cost;
  String? categoryId;
  String? categoryName;
  String? note;

  @TimestampConverter()
  DateTime? createdDate;
  String? otherCategory;
  String? id;
  bool? isDeleted;

  SpendingRequest({
    required this.cost,
    this.id,
    this.categoryId,
    this.note,
    this.otherCategory,
    this.categoryName,
    this.createdDate,
    this.isDeleted = false,
  });

  factory SpendingRequest.fromJson(Map<String, dynamic> json) =>
      _$SpendingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SpendingRequestToJson(this);
}
