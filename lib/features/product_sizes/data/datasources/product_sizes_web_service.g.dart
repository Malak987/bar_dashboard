// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sizes_web_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _ProductSizesWebService implements ProductSizesWebService {
  _ProductSizesWebService(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<List<ProductSizeModel>>> getProductSizes(
    String productId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<ProductSizeModel>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/ProductSizes/GetProductSizes/${productId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<ProductSizeModel>> _value;
    try {
      _value = ApiResponse<List<ProductSizeModel>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<ProductSizeModel>(
                    (i) => ProductSizeModel.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<dynamic>> addProductSize({
    required String productId,
    required String nameAr,
    required String nameEn,
    required String sizeName,
    required String descriptionAr,
    required String descriptionEn,
    required String price,
    required String isAvailable,
    required String radius,
    required String height,
    required String serves,
    MultipartFile? image,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('ProductId', productId));
    _data.fields.add(MapEntry('NameAr', nameAr));
    _data.fields.add(MapEntry('NameEn', nameEn));
    _data.fields.add(MapEntry('SizeName', sizeName));
    _data.fields.add(MapEntry('DescriptionAr', descriptionAr));
    _data.fields.add(MapEntry('DescriptionEn', descriptionEn));
    _data.fields.add(MapEntry('Price', price));
    _data.fields.add(MapEntry('IsAvailable', isAvailable));
    _data.fields.add(MapEntry('Radius', radius));
    _data.fields.add(MapEntry('Height', height));
    _data.fields.add(MapEntry('Serves', serves));
    if (image != null) {
      _data.files.add(MapEntry('Image', image));
    }
    final _options = _setStreamType<ApiResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/ProductSizes/AddProductSize',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<dynamic> _value;
    try {
      _value = ApiResponse<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<dynamic>> updateProductSize({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String price,
    required String isAvailable,
    required String radius,
    required String height,
    required String serves,
    MultipartFile? image,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('Id', id));
    _data.fields.add(MapEntry('NameAr', nameAr));
    _data.fields.add(MapEntry('NameEn', nameEn));
    _data.fields.add(MapEntry('DescriptionAr', descriptionAr));
    _data.fields.add(MapEntry('DescriptionEn', descriptionEn));
    _data.fields.add(MapEntry('Price', price));
    _data.fields.add(MapEntry('IsAvailable', isAvailable));
    _data.fields.add(MapEntry('Radius', radius));
    _data.fields.add(MapEntry('Height', height));
    _data.fields.add(MapEntry('Serves', serves));
    if (image != null) {
      _data.files.add(MapEntry('Image', image));
    }
    final _options = _setStreamType<ApiResponse<dynamic>>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/ProductSizes/UpdateProductSize',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<dynamic> _value;
    try {
      _value = ApiResponse<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<dynamic>> archiveProductSize(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<dynamic>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/ProductSizes/ArchiveProductSize/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<dynamic> _value;
    try {
      _value = ApiResponse<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
