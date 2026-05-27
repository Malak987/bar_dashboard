// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedProductsModel _$PaginatedProductsModelFromJson(
  Map<String, dynamic> json,
) => PaginatedProductsModel(
  productModels: (json['items'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginatedProductsModelToJson(
  PaginatedProductsModel instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'items': instance.productModels.map((e) => e.toJson()).toList(),
};
