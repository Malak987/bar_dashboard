import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/auth_model.dart';
import '../models/auth_request_model.dart';
import '../models/paginated_users_model.dart';
import '../models/update_archive_status_request_model.dart';
import '../models/user_model.dart';

part 'accounts_web_service.g.dart';

@RestApi()
abstract class AccountsWebService {
  factory AccountsWebService(Dio dio, {String baseUrl}) = _AccountsWebService;

  @POST(ApiConstants.registerAdmin)
  Future<ApiResponse<dynamic>> registerAdmin(
      @Body() AuthRequestModel body,
      );

  @POST(ApiConstants.adminLogin)
  Future<ApiResponse<AuthModel>> adminLogin(
      @Body() AuthRequestModel body,
      );

  @GET(ApiConstants.getAllUsers)
  Future<ApiResponse<PaginatedUsersModel>> getAllUsers();

  @GET('${ApiConstants.getUserById}/{id}')
  Future<ApiResponse<UserModel>> getUserById(@Path('id') String id);

  /// حظر / فك حظر العميل
  @PUT(ApiConstants.updateUserArchiveStatus)
  Future<ApiResponse<dynamic>> updateUserArchiveStatus(
      @Body() UpdateArchiveStatusRequestModel body,
      );
}
