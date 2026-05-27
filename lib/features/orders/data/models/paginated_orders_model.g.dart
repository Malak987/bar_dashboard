// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedOrdersModel _$PaginatedOrdersModelFromJson(
  Map<String, dynamic> json,
) => PaginatedOrdersModel(
  orderModels: (json['items'] as List<dynamic>)
      .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginatedOrdersModelToJson(
  PaginatedOrdersModel instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'items': instance.orderModels.map((e) => e.toJson()).toList(),
};
