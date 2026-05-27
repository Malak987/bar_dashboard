import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/flavor_model.dart';
import '../models/paginated_flavors_model.dart';

part 'flavors_web_service.g.dart';

@RestApi()
abstract class FlavorsWebService {
  factory FlavorsWebService(Dio dio, {String baseUrl}) = _FlavorsWebService;

  @GET(ApiConstants.getAllFlavors)
  Future<ApiResponse<PaginatedFlavorsModel>> getAllFlavors();

  @GET('${ApiConstants.getFlavorById}/{id}')
  Future<ApiResponse<FlavorModel>> getFlavorById(@Path('id') String id);

  @POST(ApiConstants.addFlavor)
  @MultiPart()
  Future<ApiResponse<dynamic>> addFlavor({
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'IsAvailable') required String isAvailable,
    @Part(name: 'Image') MultipartFile? image, // optional
  });

  @PUT(ApiConstants.updateFlavor)
  @MultiPart()
  Future<ApiResponse<dynamic>> updateFlavor({
    @Part(name: 'Id') required String id,
    @Part(name: 'NameAr') required String nameAr,
    @Part(name: 'NameEn') required String nameEn,
    @Part(name: 'DescriptionAr') required String descriptionAr,
    @Part(name: 'DescriptionEn') required String descriptionEn,
    @Part(name: 'IsAvailable') required String isAvailable,
    @Part(name: 'Image') MultipartFile? image, // optional
  });

  @DELETE('${ApiConstants.archiveFlavor}/{id}')
  Future<ApiResponse<dynamic>> archiveFlavor(@Path('id') String id);

  @PATCH('${ApiConstants.unArchiveFlavor}/{id}')
  Future<ApiResponse<dynamic>> unArchiveFlavor(@Path('id') String id);
}
