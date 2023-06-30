import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? accessToken;
  String? displayName;
  String? email;
  String? photoUrl;

  User({
    this.email,
    this.displayName,
    this.accessToken,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
