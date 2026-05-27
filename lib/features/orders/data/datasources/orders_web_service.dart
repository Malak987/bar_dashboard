import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/order_model.dart';
import '../models/paginated_orders_model.dart';
import '../models/place_order_request_model.dart';
import '../models/update_order_status_request_model.dart';

part 'orders_web_service.g.dart';

@RestApi()
abstract class OrdersWebService {
  factory OrdersWebService(Dio dio, {String baseUrl}) = _OrdersWebService;

  /// 🆕 بنطلب pageSize كبير عشان نجيب كل الأوردرات في request واحد
  @GET(ApiConstants.getMyOrders)
  Future<ApiResponse<PaginatedOrdersModel>> getMyOrders({
    @Query('pageNumber') int pageNumber = 1,
    @Query('pageSize') int pageSize = 1000,
  });

  @GET(ApiConstants.getAllOrders)
  Future<ApiResponse<PaginatedOrdersModel>> getAllOrders({
    @Query('pageNumber') int pageNumber = 1,
    @Query('pageSize') int pageSize = 1000,
  });

  @GET('${ApiConstants.getOrderById}/{id}')
  Future<ApiResponse<OrderModel>> getOrderById(@Path('id') String id);

  @POST(ApiConstants.placeOrder)
  Future<ApiResponse<dynamic>> placeOrder(
      @Body() PlaceOrderRequestModel body,
      );

  @PATCH('${ApiConstants.cancelOrder}/{id}')
  Future<ApiResponse<dynamic>> cancelOrder(@Path('id') String id);

  @PATCH(ApiConstants.updateOrderStatus)
  Future<ApiResponse<dynamic>> updateOrderStatus(
      @Body() UpdateOrderStatusRequestModel body,
      );
}
