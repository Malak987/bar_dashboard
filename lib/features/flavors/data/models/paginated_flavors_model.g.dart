// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_flavors_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedFlavorsModel _$PaginatedFlavorsModelFromJson(
  Map<String, dynamic> json,
) => PaginatedFlavorsModel(
  flavorModels: (json['items'] as List<dynamic>)
      .map((e) => FlavorModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginatedFlavorsModelToJson(
  PaginatedFlavorsModel instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'items': instance.flavorModels.map((e) => e.toJson()).toList(),
};
