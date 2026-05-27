import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Wrapper موحد لكل الـ responses من الـ backend
/// {
///   "message": "...",
///   "data": {...} | null,
///   "isSucceeded": true/false,
///   "timestamp": "..."
/// }
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final String? message;
  final T? data;
  final bool isSucceeded;
  final String? timestamp;

  ApiResponse({
    this.message,
    this.data,
    required this.isSucceeded,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
