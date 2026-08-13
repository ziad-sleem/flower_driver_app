import 'package:json_annotation/json_annotation.dart';

import 'package:tracking_app/features/orders/domain/entities/pagination_entity.dart'
    as entity;

part 'pagination_dto.g.dart';

@JsonSerializable()
class PaginationDto {
  @JsonKey(name: "currentPage")
  int? currentPage;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "totalItems")
  int? totalItems;
  @JsonKey(name: "limit")
  int? limit;

  PaginationDto({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationDtoToJson(this);

  entity.PaginationOrderEntity toEntity() => entity.PaginationOrderEntity(
    currentPage: currentPage,
    totalPages: totalPages,
    totalItems: totalItems,
    limit: limit,
  );
}
