// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_flavors_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlavorWithExtraPriceModel _$FlavorWithExtraPriceModelFromJson(
  Map<String, dynamic> json,
) => FlavorWithExtraPriceModel(
  flavorId: json['flavorId'] as String,
  extraPrice: (json['extraPrice'] as num).toDouble(),
);

Map<String, dynamic> _$FlavorWithExtraPriceModelToJson(
  FlavorWithExtraPriceModel instance,
) => <String, dynamic>{
  'flavorId': instance.flavorId,
  'extraPrice': instance.extraPrice,
};

AssignFlavorsRequestModel _$AssignFlavorsRequestModelFromJson(
  Map<String, dynamic> json,
) => AssignFlavorsRequestModel(
  productId: json['productId'] as String,
  flavors: (json['flavors'] as List<dynamic>)
      .map((e) => FlavorWithExtraPriceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AssignFlavorsRequestModelToJson(
  AssignFlavorsRequestModel instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'flavors': instance.flavors.map((e) => e.toJson()).toList(),
};
