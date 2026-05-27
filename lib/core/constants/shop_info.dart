/// 🏪 معلومات المحل والفروع
///
/// ⚠️ ملاحظة: دلوقتي البيانات constants
/// لما الـ Backend يوفر GET /api/Branches endpoint، هنحوّل لـ API
class ShopInfo {
  // ═══════════════ بيانات عامة عن البراند ═══════════════
  static const String brandNameAr = 'بار';
  static const String brandNameEn = 'BAR';
  static const String brandTagline = 'Dessert & Chocolate';
  static const String brandSlogan = 'Happiness You Deserve';
  static const String socialMedia = '@bar.dessert.chocolate';

  // ⚠️ أرقام مؤقتة - يرجى تعديلها لاحقاً
  static const String taxNumber = '000-000-000';
  static const String commercialRegister = 'CR-0000-0000';
  static const String website = '';
  static const String email = '';

  // ═══════════════ الفروع ═══════════════
  static const List<BranchInfo> branches = [
    BranchInfo(
      id: 'homeyat',
      nameAr: 'بار - فرع الحميات',
      nameEn: 'Bar - Homeyat Branch',
      addressAr: 'شارع التحرير، بجوار مطعم التكية - سوهاج',
      addressEn: 'Tahrir Street, Next to Al-Takeya Restaurant - Sohag',
      phones: ['01288227173', '01010701175'],
      whatsapp: '01288227173',
      socialMedia: 'bar dessert & chocolate',
    ),
    BranchInfo(
      id: 'gomhorya',
      nameAr: 'بار - فرع الجمهورية',
      nameEn: 'Bar - Gomhorya Branch',
      addressAr:
      'شارع محمد عبد الحليم، متفرع من شارع الجمهورية، ناصية الشارع - محل الجلوي للمفروشات',
      addressEn: 'Mohamed Abdel Halim St., Off Gomhorya St. - Sohag',
      phones: ['01094992825'],
      whatsapp: '01094992825',
      socialMedia: 'Bar dessert & chocolate',
    ),
  ];

  /// الفرع الافتراضي (لو ما حددناش فرع من الـ order)
  static BranchInfo get defaultBranch => branches.first;

  /// البحث عن فرع باستخدام الـ id/name
  static BranchInfo? findBranchById(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final b in branches) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// البحث باسم الفرع (matching جزئي)
  static BranchInfo? findBranchByName(String? name) {
    if (name == null || name.isEmpty) return null;
    final lower = name.toLowerCase();
    for (final b in branches) {
      if (b.nameAr.contains(name) ||
          b.nameEn.toLowerCase().contains(lower) ||
          lower.contains(b.id)) {
        return b;
      }
    }
    return null;
  }

  /// إرجاع فرع من order (يحاول من branchId أولاً، ثم من branchName)
  static BranchInfo branchFromOrder({
    String? branchId,
    String? branchName,
  }) {
    return findBranchById(branchId) ??
        findBranchByName(branchName) ??
        defaultBranch;
  }
}

/// 🏪 بيانات فرع
class BranchInfo {
  final String id;
  final String nameAr;
  final String nameEn;
  final String addressAr;
  final String addressEn;
  final List<String> phones;
  final String whatsapp;
  final String socialMedia;

  const BranchInfo({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.addressAr,
    required this.addressEn,
    required this.phones,
    required this.whatsapp,
    required this.socialMedia,
  });

  /// عرض الأرقام مفصولة بـ /
  String get phonesDisplay => phones.join(' / ');
}