import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class PaginatedUsersEntity extends Equatable {
  final List<UserEntity> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedUsersEntity({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
        items,
        pageNumber,
        totalPages,
        totalCount,
        hasPreviousPage,
        hasNextPage,
      ];
}
