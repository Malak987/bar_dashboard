import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/product_size_model.dart';

part 'product_sizes_web_service.g.dart';

@RestApi()
abstract class ProductSizesWebService {
  factory ProductSizesWebService(Dio dio, {String baseUrl}) =
  _ProductSizesWebService;

  @GET('${ApiConstants.getProductSizes}/{productId}')
  Future<ApiResponse<List<ProductSizeModel>>> getProductSizes(
      @Path('productId') String productId,
      );

  @POST(ApiConstants.addProductSize)
  @MultiPart()
  Future<ApiResponse<dynamic>> addProductSize({
    @Part(name: 'ProductId') required String productId,
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'SizeName') required String sizeName,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'Price') required String price,
    @Part(name: 'IsAvailable') required String isAvailable,
    @Part(name: 'Radius') required String radius,
    @Part(name: 'Height') required String height,
    @Part(name: 'Serves') required String serves,
    @Part(name: 'Image') MultipartFile? image,
  });

  @PUT(ApiConstants.updateProductSize)
  @MultiPart()
  Future<ApiResponse<dynamic>> updateProductSize({
    @Part(name: 'Id') required String id,
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'Price') required String price,
    @Part(name: 'IsAvailable') required String isAvailable,
    @Part(name: 'Radius') required String radius,
    @Part(name: 'Height') required String height,
    @Part(name: 'Serves') required String serves,
    @Part(name: 'Image') MultipartFile? image,
  });

  @DELETE('${ApiConstants.archiveProductSize}/{id}')
  Future<ApiResponse<dynamic>> archiveProductSize(@Path('id') String id);
}
