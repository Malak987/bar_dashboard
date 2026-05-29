import 'package:flutter/material.dart';

class AppStrings {
  final String languageCode;

  const AppStrings._(this.languageCode);

  factory AppStrings.of(BuildContext context) {
    return AppStrings._(Localizations.localeOf(context).languageCode);
  }

  bool get isArabic => languageCode == 'ar';

  String get appTitle => isArabic ? 'BAR Sweets - لوحة التحكم' : 'BAR Sweets - Dashboard';
  String get dashboard => isArabic ? 'لوحة التحكم' : 'Dashboard';
  String get dashboardSubtitle => isArabic ? 'إدارة شاملة لمتابعة العمل' : 'Full business control panel';

  String get products => isArabic ? 'المنتجات' : 'Products';
  String get categories => isArabic ? 'الفئات' : 'Categories';
  String get flavors => isArabic ? 'النكهات' : 'Flavors';
  String get inventory => isArabic ? 'المخزون' : 'Inventory';
  String get customers => isArabic ? 'العملاء' : 'Customers';
  String get employees => isArabic ? 'الموظفين' : 'Employees';
  String get coupons => isArabic ? 'الكوبونات' : 'Coupons';
  String get reports => isArabic ? 'التقارير' : 'Reports';
  String get analytics => isArabic ? 'التحليلات' : 'Analytics';
  String get branches => isArabic ? 'الفروع' : 'Branches';
  String get notifications => isArabic ? 'الإشعارات' : 'Notifications';
  String get activityLog => isArabic ? 'سجل النشاط' : 'Activity Log';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get orders => isArabic ? 'الطلبات' : 'Orders';
  String get comingSoon => isArabic ? 'قريباً' : 'Coming Soon';

  String get searchHint => isArabic ? 'بحث...' : 'Search...';
  String get allBranches => isArabic ? 'كل الفروع' : 'All Branches';
  String get closed => isArabic ? 'مغلق' : 'Closed';
  String get open => isArabic ? 'مفتوح' : 'Open';

  String get lastNotifications => isArabic ? 'آخر الإشعارات' : 'Latest Notifications';
  String get noNotifications => isArabic ? 'لا توجد إشعارات حالياً' : 'No notifications yet';
  String get readAll => isArabic ? 'قراءة الكل' : 'Read all';
  String get openNotificationsPage =>
      isArabic ? 'فتح صفحة الإشعارات' : 'Open notifications page';

  String get userMenu => isArabic ? 'قائمة المستخدم' : 'User menu';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Logout';
  String get owner => isArabic ? 'مالك' : 'Owner';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get arabic => 'العربية';
  String get english => 'English';

  String get testNotificationSound =>
      isArabic ? 'اختبار صوت الإشعار' : 'Test notification sound';
  String get testNotificationSoundSubtitle => isArabic
      ? 'اختبر التنبيه الحالي للتأكد من أن الصوت مناسب'
      : 'Test the current alert sound';
  String get test => isArabic ? 'اختبار' : 'Test';

  String get settingsNotificationsTitle =>
      isArabic ? 'الإشعارات والتنبيهات' : 'Notifications & Alerts';
  String get settingsLiveUpdatesTitle =>
      isArabic ? 'التحديثات الحية' : 'Live Updates';
  String get settingsBehaviorTitle =>
      isArabic ? 'السلوك العام' : 'General Behavior';
  String get settingsSecurityTitle =>
      isArabic ? 'الأمان والجلسة' : 'Security & Session';
  String get settingsSystemInfoTitle =>
      isArabic ? 'معلومات النظام' : 'System Information';

  String get soundEnabledTitle =>
      isArabic ? 'تشغيل صوت الإشعارات' : 'Enable notification sound';
  String get soundEnabledSubtitle => isArabic
      ? 'تشغيل صوت قوي عند وصول طلبات أونلاين جديدة'
      : 'Play a strong alert when new online orders arrive';

  String get pushEnabledTitle =>
      isArabic ? 'تفعيل التنبيهات المباشرة' : 'Enable live notifications';
  String get pushEnabledSubtitle => isArabic
      ? 'عرض التنبيهات في صفحة الإشعارات وإضافتها تلقائياً'
      : 'Show alerts in the notifications page automatically';

  String get autoRefreshTitle =>
      isArabic ? 'التحديث التلقائي' : 'Auto refresh';
  String get autoRefreshSubtitle => isArabic
      ? 'تحديث الطلبات والتنبيهات في الخلفية كل عدة ثوانٍ'
      : 'Refresh orders and alerts in background every few seconds';

  String get analyticsRealtimeTitle =>
      isArabic ? 'تحليلات لحظية' : 'Realtime analytics';
  String get analyticsRealtimeSubtitle => isArabic
      ? 'تحديث الرسوم والتحليلات في الصفحات التحليلية باستمرار'
      : 'Keep analytics and charts updated continuously';

  String get showClosedBranchesTitle =>
      isArabic ? 'عرض الفروع المغلقة' : 'Show closed branches';
  String get showClosedBranchesSubtitle => isArabic
      ? 'إبقاء الفروع المغلقة ظاهرة في القوائم وعدم إخفائها'
      : 'Keep closed branches visible in lists';

  String get confirmationsTitle =>
      isArabic ? 'تأكيد الإجراءات الحساسة' : 'Confirm sensitive actions';
  String get confirmationsSubtitle => isArabic
      ? 'إظهار رسائل تأكيد عند الأرشفة أو التعديل أو الإلغاء'
      : 'Show confirmation dialogs for archive, edit, or cancel actions';

  String get compactModeTitle =>
      isArabic ? 'وضع عرض مضغوط' : 'Compact mode';
  String get compactModeSubtitle => isArabic
      ? 'تقليل المسافات والهوامش في القوائم والبطاقات'
      : 'Reduce spacing and margins in cards and lists';

  String get securityLevelTitle =>
      isArabic ? 'مستوى الأمان' : 'Security level';
  String get securityLevelSubtitle => isArabic
      ? 'يتم حالياً الاعتماد على توكن الجلسة المخزن محلياً. يمكن لاحقاً إضافة 2FA وقوائم صلاحيات أوسع.'
      : 'The app currently relies on local session tokens. 2FA and richer permissions can be added later.';

  String get appVersion => isArabic ? 'نسخة اللوحة' : 'App version';
  String get systemStatus => isArabic ? 'حالة النظام' : 'System status';
  String get systemReady => isArabic ? 'جاهز للتشغيل' : 'Ready';

  String get notificationsCountLabel =>
      isArabic ? 'غير مقروء' : 'Unread';
  String get activityLabel => isArabic ? 'سجل النشاط' : 'Activity Log';
}