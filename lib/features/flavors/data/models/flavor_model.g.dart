// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flavor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlavorModel _$FlavorModelFromJson(Map<String, dynamic> json) => FlavorModel(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  descriptionAr: json['descriptionAr'] as String,
  descriptionEn: json['descriptionEn'] as String,
  imageUrl: json['imageUrl'] as String?,
  isAvailable: json['isAvailable'] as bool,
  isArchived: json['isArchived'] as bool,
);

Map<String, dynamic> _$FlavorModelToJson(FlavorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'descriptionAr': instance.descriptionAr,
      'descriptionEn': instance.descriptionEn,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'isArchived': instance.isArchived,
    };
