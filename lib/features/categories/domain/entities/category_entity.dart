import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_helper.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? imageUrl;
  final bool isArchived;
  final int productsCount;

  const CategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.imageUrl,
    required this.isArchived,
    required this.productsCount,
  });

  /// URL كامل جاهز للاستخدام في Image.network
  String? get fullImageUrl => ImageUrlHelper.buildFullUrl(imageUrl);

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        descriptionAr,
        descriptionEn,
        imageUrl,
        isArchived,
        productsCount,
      ];
}
