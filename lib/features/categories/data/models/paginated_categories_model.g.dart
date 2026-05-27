// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedCategoriesModel _$PaginatedCategoriesModelFromJson(
  Map<String, dynamic> json,
) => PaginatedCategoriesModel(
  categoryModels: (json['items'] as List<dynamic>)
      .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginatedCategoriesModelToJson(
  PaginatedCategoriesModel instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'items': instance.categoryModels.map((e) => e.toJson()).toList(),
};
