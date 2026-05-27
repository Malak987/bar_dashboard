import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_helper.dart';

class OrderItemFlavorEntity extends Equatable {
  final String flavorId;
  final String? flavorNameAr; // 🔧 nullable
  final String? flavorNameEn; // 🔧 nullable

  const OrderItemFlavorEntity({
    required this.flavorId,
    this.flavorNameAr,
    this.flavorNameEn,
  });

  @override
  List<Object?> get props => [flavorId, flavorNameAr, flavorNameEn];
}

class OrderItemEntity extends Equatable {
  final String id;
  final String? productId; // 🔧 nullable
  final String? productNameAr; // 🔧 nullable (المنتج ممكن يكون اتمسح)
  final String? productNameEn; // 🔧 nullable
  final String? productImageUrl;
  final String? sizeId;
  final String? sizeName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? note;
  final List<OrderItemFlavorEntity> flavors;

  const OrderItemEntity({
    required this.id,
    this.productId,
    this.productNameAr,
    this.productNameEn,
    this.productImageUrl,
    this.sizeId,
    this.sizeName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.note,
    required this.flavors,
  });

  String? get fullProductImageUrl =>
      ImageUrlHelper.buildFullUrl(productImageUrl);

  /// اسم آمن للعرض (لو المنتج اتمسح)
  String get safeProductNameAr =>
      productNameAr ?? '⚠️ منتج محذوف';

  String get safeProductNameEn =>
      productNameEn ?? '⚠️ Deleted product';

  @override
  List<Object?> get props => [
    id,
    productId,
    productNameAr,
    productNameEn,
    productImageUrl,
    sizeId,
    sizeName,
    quantity,
    unitPrice,
    totalPrice,
    note,
    flavors,
  ];
}
