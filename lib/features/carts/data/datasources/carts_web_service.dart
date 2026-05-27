import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../models/add_to_cart_request_model.dart';
import '../models/cart_model.dart';
import '../models/update_cart_item_request_model.dart';

part 'carts_web_service.g.dart';

@RestApi()
abstract class CartsWebService {
  factory CartsWebService(Dio dio, {String baseUrl}) = _CartsWebService;

  @GET(ApiConstants.getCart)
  Future<ApiResponse<CartModel>> getCart();

  @POST(ApiConstants.addToCart)
  Future<ApiResponse<dynamic>> addToCart(
    @Body() AddToCartRequestModel body,
  );

  @PUT(ApiConstants.updateCartItemQuantity)
  Future<ApiResponse<dynamic>> updateCartItemQuantity(
    @Body() UpdateCartItemRequestModel body,
  );

  @DELETE('${ApiConstants.removeFromCart}/{id}')
  Future<ApiResponse<dynamic>> removeFromCart(@Path('id') String id);

  @DELETE(ApiConstants.clearCart)
  Future<ApiResponse<dynamic>> clearCart();
}
