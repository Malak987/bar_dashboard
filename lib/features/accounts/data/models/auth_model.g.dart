// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  token: json['token'] as String,
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'token': instance.token,
  'expiresAt': instance.expiresAt,
};
