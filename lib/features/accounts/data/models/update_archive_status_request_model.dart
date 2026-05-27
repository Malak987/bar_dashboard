import 'package:json_annotation/json_annotation.dart';

part 'update_archive_status_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateArchiveStatusRequestModel {
  final String userId;
  final bool isArchived;

  /// 🆕 اختياري - لما الـ Backend يدعم سبب الحظر
  final String? reason;

  UpdateArchiveStatusRequestModel({
    required this.userId,
    required this.isArchived,
    this.reason,
  });

  Map<String, dynamic> toJson() =>
      _$UpdateArchiveStatusRequestModelToJson(this);

  factory UpdateArchiveStatusRequestModel.fromJson(
      Map<String, dynamic> json) =>
      _$UpdateArchiveStatusRequestModelFromJson(json);
}
