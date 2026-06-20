// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_meta_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleMetaDataDto _$VehicleMetaDataDtoFromJson(Map<String, dynamic> json) =>
    VehicleMetaDataDto(
      currentPage: (json['currentPage'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VehicleMetaDataDtoToJson(VehicleMetaDataDto instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'limit': instance.limit,
      'totalItems': instance.totalItems,
    };
