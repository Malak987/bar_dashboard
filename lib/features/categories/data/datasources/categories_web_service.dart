import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/category_model.dart';
import '../models/paginated_categories_model.dart';

part 'categories_web_service.g.dart';

@RestApi()
abstract class CategoriesWebService {
  factory CategoriesWebService(Dio dio, {String baseUrl}) =
  _CategoriesWebService;

  @GET(ApiConstants.getAllCategories)
  Future<ApiResponse<PaginatedCategoriesModel>> getAllCategories({
    @Query('pageNumber') int pageNumber = 1,
    @Query('pageSize') int pageSize = 1000,
  });

  @GET('${ApiConstants.getCategoryById}/{id}')
  Future<ApiResponse<CategoryModel>> getCategoryById(@Path('id') String id);

  @POST(ApiConstants.addCategory)
  @MultiPart()
  Future<ApiResponse<dynamic>> addCategory({
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'Image') required MultipartFile image,
  });

  @PUT(ApiConstants.updateCategory)
  @MultiPart()
  Future<ApiResponse<dynamic>> updateCategory({
    @Part(name: 'Id') required String id,
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'Image') MultipartFile? image,
  });

  @DELETE('${ApiConstants.archiveCategory}/{id}')
  Future<ApiResponse<dynamic>> archiveCategory(@Path('id') String id);

  @PATCH('${ApiConstants.unArchiveCategory}/{id}')
  Future<ApiResponse<dynamic>> unArchiveCategory(@Path('id') String id);
}
