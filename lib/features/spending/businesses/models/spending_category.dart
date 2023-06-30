import 'package:json_annotation/json_annotation.dart';
part 'spending_category.g.dart';

@JsonSerializable()
class SpendingCategory {
  final String? id;
  final String? name;
  final String? description;

  SpendingCategory({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpendingCategory.fromJson(Map<String, dynamic> json) =>
      _$SpendingCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SpendingCategoryToJson(this);
}
