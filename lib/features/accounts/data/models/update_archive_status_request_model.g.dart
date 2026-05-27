// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_archive_status_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateArchiveStatusRequestModel _$UpdateArchiveStatusRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateArchiveStatusRequestModel(
  userId: json['userId'] as String,
  isArchived: json['isArchived'] as bool,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$UpdateArchiveStatusRequestModelToJson(
  UpdateArchiveStatusRequestModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'isArchived': instance.isArchived,
  'reason': ?instance.reason,
};
