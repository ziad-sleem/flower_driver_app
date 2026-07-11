import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/users_entity.dart';

part 'users_dto.g.dart';

@JsonSerializable()
class UsersDto {
  @JsonKey(name: "_id")
  final String? id;

  final String? firstName;
  final String? lastName;
  final String? email;

  UsersDto({this.id, this.firstName, this.lastName, this.email});

  factory UsersDto.fromJson(Map<String, dynamic> json) =>
      _$UsersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UsersDtoToJson(this);

  UsersEntity toEntity() => UsersEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
  );
}
