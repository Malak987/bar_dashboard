import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String phone;
  final String addressAr;
  final String addressEn;
  final bool isArchived;

  const BranchEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.phone,
    required this.addressAr,
    required this.addressEn,
    required this.isArchived,
  });

  bool get isOpen => !isArchived;

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        descriptionAr,
        descriptionEn,
        phone,
        addressAr,
        addressEn,
        isArchived,
      ];
}
