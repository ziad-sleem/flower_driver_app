import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

class EditProfileParams {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const EditProfileParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}

@JsonSerializable()
class EditProfileJsonRequest {
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phone')
  final String phone;

  const EditProfileJsonRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory EditProfileJsonRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileJsonRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileJsonRequestToJson(this);
}
