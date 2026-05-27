import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_users_entity.dart';
import 'user_model.dart';

part 'paginated_users_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedUsersModel extends PaginatedUsersEntity {
  @JsonKey(name: 'items')
  final List<UserModel> userModels;

  const PaginatedUsersModel({
    required this.userModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: userModels);

  factory PaginatedUsersModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedUsersModelToJson(this);
}
