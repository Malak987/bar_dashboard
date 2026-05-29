import '../../domain/entities/paginated_branches_entity.dart';
import 'branch_model.dart';

class PaginatedBranchesModel extends PaginatedBranchesEntity {
  final List<BranchModel> branchModels;

  const PaginatedBranchesModel({
    required this.branchModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: branchModels);

  factory PaginatedBranchesModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? const []);
    return PaginatedBranchesModel(
      branchModels: itemsJson
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? itemsJson.length,
      hasPreviousPage: json['hasPreviousPage'] == true,
      hasNextPage: json['hasNextPage'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': branchModels.map((e) => e.toJson()).toList(),
        'pageNumber': pageNumber,
        'totalPages': totalPages,
        'totalCount': totalCount,
        'hasPreviousPage': hasPreviousPage,
        'hasNextPage': hasNextPage,
      };
}
