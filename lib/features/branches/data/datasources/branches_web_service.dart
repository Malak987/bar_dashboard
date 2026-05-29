import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/branch_model.dart';
import '../models/paginated_branches_model.dart';

class BranchesWebService {
  final Dio _dio;

  BranchesWebService(this._dio, {String? baseUrl});

  Future<ApiResponse<PaginatedBranchesModel>> getAllBranches({
    int pageNumber = 1,
    int pageSize = 1000,
  }) async {
    final response = await _dio.get(
      ApiConstants.getAllBranches,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    return ApiResponse<PaginatedBranchesModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PaginatedBranchesModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<BranchModel>> getBranchById(String id) async {
    final response = await _dio.get('${ApiConstants.getBranchById}/$id');

    return ApiResponse<BranchModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => BranchModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> addBranch({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    final response = await _dio.post(
      ApiConstants.addBranch,
      data: {
        'nameAr': nameAr,
        'nameEn': nameEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'phone': phone,
        'addressAr': addressAr,
        'addressEn': addressEn,
      },
    );

    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }

  Future<ApiResponse<dynamic>> updateBranch({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    final response = await _dio.put(
      ApiConstants.updateBranch,
      data: {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'phone': phone,
        'addressAr': addressAr,
        'addressEn': addressEn,
      },
    );

    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }

  Future<ApiResponse<dynamic>> archiveBranch(String id) async {
    final response = await _dio.delete('${ApiConstants.archiveBranch}/$id');
    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }

  Future<ApiResponse<dynamic>> unArchiveBranch(String id) async {
    final response = await _dio.patch('${ApiConstants.unArchiveBranch}/$id');
    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }
}
