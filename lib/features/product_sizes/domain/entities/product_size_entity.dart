import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_helper.dart';

class ProductSizeEntity extends Equatable {
  final String id;
  final String productId;
  final String nameAr;
  final String nameEn;
  final String? sizeName;
  final String? descriptionAr;
  final String? descriptionEn;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final bool isArchived;
  final double? radius; // 🆕
  final double? height; // 🆕
  final String? serves; // 🆕

  const ProductSizeEntity({
    required this.id,
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    this.sizeName,
    this.descriptionAr,
    this.descriptionEn,
    required this.price,
    this.imageUrl,
    required this.isAvailable,
    required this.isArchived,
    this.radius,
    this.height,
    this.serves,
  });

  String? get fullImageUrl => ImageUrlHelper.buildFullUrl(imageUrl);

  @override
  List<Object?> get props => [
    id,
    productId,
    nameAr,
    nameEn,
    sizeName,
    descriptionAr,
    descriptionEn,
    price,
    imageUrl,
    isAvailable,
    isArchived,
    radius,
    height,
    serves,
  ];
}
