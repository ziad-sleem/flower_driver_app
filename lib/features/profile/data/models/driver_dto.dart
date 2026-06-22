import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

part 'driver_dto.g.dart';

@JsonSerializable()
class ProfileDriverDto {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "vehicleType")
  final String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  final String? vehicleLicense;
  @JsonKey(name: "NID")
  final String? nid;
  @JsonKey(name: "NIDImg")
  final String? nidImg;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "createdAt")
  final String? createdAt;

  ProfileDriverDto({
    this.id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory ProfileDriverDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDriverDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDriverDtoToJson(this);

  ProfileDriverEntity toEntity() {
    return ProfileDriverEntity(
      id: id,
      country: country,
      firstName: firstName,
      lastName: lastName,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
      nid: nid,
      nidImg: nidImg,
      email: email,
      gender: gender,
      phone: phone,
      photo: photo,
      role: role,
      createdAt: createdAt,
    );
  }
}
