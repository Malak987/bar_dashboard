import 'package:equatable/equatable.dart';
import 'product_entity.dart';

class PaginatedProductsEntity extends Equatable {
  final List<ProductEntity> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedProductsEntity({
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
