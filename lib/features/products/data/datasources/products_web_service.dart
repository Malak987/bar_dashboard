import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/assign_flavors_request_model.dart';
import '../models/paginated_products_model.dart';
import '../models/product_model.dart';

part 'products_web_service.g.dart';

@RestApi()
abstract class ProductsWebService {
  factory ProductsWebService(Dio dio, {String baseUrl}) = _ProductsWebService;

  @GET(ApiConstants.getAllProducts)
  Future<ApiResponse<PaginatedProductsModel>> getAllProducts({
    @Query('pageNumber') int pageNumber = 1,
    @Query('pageSize') int pageSize = 1000,
  });

  @GET('${ApiConstants.getProductById}/{id}')
  Future<ApiResponse<ProductModel>> getProductById(@Path('id') String id);

  /// 🆕 AddProduct بالحقول الجديدة (BasePrice + IsCustomizable + SizeName)
  /// ⚠️ شيلت IsActive لأنه مش في الـ Add الجديد
  @POST(ApiConstants.addProduct)
  @MultiPart()
  Future<ApiResponse<dynamic>> addProduct({
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'SizeName') required String sizeName,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'BasePrice') required String basePrice,
    @Part(name: 'IsFeatured') required String isFeatured,
    @Part(name: 'IsBestSeller') required String isBestSeller,
    @Part(name: 'IsCustomizable') required String isCustomizable,
    @Part(name: 'CategoryId') required String categoryId,
    @Part(name: 'Image') MultipartFile? image,
  });

  @PUT(ApiConstants.updateProduct)
  @MultiPart()
  Future<ApiResponse<dynamic>> updateProduct({
    @Part(name: 'Id') required String id,
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'SizeName') required String sizeName,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'BasePrice') required String basePrice,
    @Part(name: 'IsFeatured') required String isFeatured,
    @Part(name: 'IsBestSeller') required String isBestSeller,
    @Part(name: 'IsCustomizable') required String isCustomizable,
    @Part(name: 'CategoryId') required String categoryId,
    @Part(name: 'Image') MultipartFile? image,
  });

  @DELETE('${ApiConstants.archiveProduct}/{id}')
  Future<ApiResponse<dynamic>> archiveProduct(@Path('id') String id);

  @PATCH('${ApiConstants.unArchiveProduct}/{id}')
  Future<ApiResponse<dynamic>> unArchiveProduct(@Path('id') String id);

  /// 🆕 الـ body الجديد بـ extraPrice
  @POST(ApiConstants.assignFlavorsToProduct)
  Future<ApiResponse<dynamic>> assignFlavorsToProduct(
      @Body() AssignFlavorsRequestModel body,
      );
}
