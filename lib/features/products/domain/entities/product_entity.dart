import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_helper.dart';

class ProductSizeMiniEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? sizeName;
  final double price;
  final String? imageUrl;

  const ProductSizeMiniEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.sizeName,
    required this.price,
    this.imageUrl,
  });

  String? get fullImageUrl => ImageUrlHelper.buildFullUrl(imageUrl);

  @override
  List<Object?> get props => [id, nameAr, nameEn, sizeName, price, imageUrl];
}

/// 🆕 ضفت extraPrice للنكهات داخل المنتج
class ProductFlavorMiniEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;
  final double extraPrice;

  const ProductFlavorMiniEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.imageUrl,
    this.extraPrice = 0,
  });

  String? get fullImageUrl => ImageUrlHelper.buildFullUrl(imageUrl);

  @override
  List<Object?> get props =>
      [id, nameAr, nameEn, imageUrl, extraPrice];
}

class ProductEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? imageUrl;
  final double basePrice;
  final bool isFeatured;
  final bool isBestSeller;
  final bool isActive;
  final bool isArchived;
  final bool isCustomizable; // 🆕
  final String categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final List<ProductSizeMiniEntity> sizes;
  final List<ProductFlavorMiniEntity> flavors;

  const ProductEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.imageUrl,
    required this.basePrice,
    required this.isFeatured,
    required this.isBestSeller,
    required this.isActive,
    required this.isArchived,
    this.isCustomizable = false,
    required this.categoryId,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.sizes,
    required this.flavors,
  });

  String? get fullImageUrl => ImageUrlHelper.buildFullUrl(imageUrl);

  /// أقل سعر بين الأحجام (لو فيه أحجام)
  double get effectivePrice {
    if (sizes.isEmpty) return basePrice;
    return sizes
        .map((s) => s.price)
        .reduce((a, b) => a < b ? a : b);
  }

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    descriptionAr,
    descriptionEn,
    imageUrl,
    basePrice,
    isFeatured,
    isBestSeller,
    isActive,
    isArchived,
    isCustomizable,
    categoryId,
    categoryNameAr,
    categoryNameEn,
    sizes,
    flavors,
  ];
}
