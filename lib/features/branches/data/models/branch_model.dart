import '../../domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    required super.phone,
    required super.addressAr,
    required super.addressEn,
    required super.isArchived,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: (json['id'] ?? '').toString(),
        nameAr: (json['nameAr'] ?? '').toString(),
        nameEn: (json['nameEn'] ?? '').toString(),
        descriptionAr: (json['descriptionAr'] ?? '').toString(),
        descriptionEn: (json['descriptionEn'] ?? '').toString(),
        phone: (json['phone'] ?? '').toString(),
        addressAr: (json['addressAr'] ?? '').toString(),
        addressEn: (json['addressEn'] ?? '').toString(),
        isArchived: json['isArchived'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'phone': phone,
        'addressAr': addressAr,
        'addressEn': addressEn,
        'isArchived': isArchived,
      };
}
