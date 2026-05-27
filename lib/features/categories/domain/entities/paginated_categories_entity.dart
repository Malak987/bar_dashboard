import 'package:equatable/equatable.dart';
import 'category_entity.dart';

class PaginatedCategoriesEntity extends Equatable {
  final List<CategoryEntity> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedCategoriesEntity({
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
