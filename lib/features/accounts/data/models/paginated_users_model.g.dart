// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedUsersModel _$PaginatedUsersModelFromJson(Map<String, dynamic> json) =>
    PaginatedUsersModel(
      userModels: (json['items'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      hasPreviousPage: json['hasPreviousPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
    );

Map<String, dynamic> _$PaginatedUsersModelToJson(
  PaginatedUsersModel instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'items': instance.userModels.map((e) => e.toJson()).toList(),
};
