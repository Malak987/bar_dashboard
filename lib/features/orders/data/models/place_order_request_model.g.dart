// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOrderRequestModel _$PlaceOrderRequestModelFromJson(
  Map<String, dynamic> json,
) => PlaceOrderRequestModel(
  address: json['address'] as String,
  note: json['note'] as String?,
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
);

Map<String, dynamic> _$PlaceOrderRequestModelToJson(
  PlaceOrderRequestModel instance,
) => <String, dynamic>{
  'address': instance.address,
  'note': instance.note,
  'deliveryFee': instance.deliveryFee,
};
