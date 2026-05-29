import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BAR Sweets - Dashboard'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dashboardShellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full business control panel'**
  String get dashboardShellSubtitle;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @flavors.
  ///
  /// In en, this message translates to:
  /// **'Flavors'**
  String get flavors;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get allBranches;

  /// No description provided for @branchClosedLabel.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get branchClosedLabel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @userMenu.
  ///
  /// In en, this message translates to:
  /// **'User menu'**
  String get userMenu;

  /// No description provided for @openNotificationsPage.
  ///
  /// In en, this message translates to:
  /// **'Open notifications page'**
  String get openNotificationsPage;

  /// No description provided for @lastNotifications.
  ///
  /// In en, this message translates to:
  /// **'Latest notifications'**
  String get lastNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @latestActivity.
  ///
  /// In en, this message translates to:
  /// **'Latest activity'**
  String get latestActivity;

  /// No description provided for @openActivityPage.
  ///
  /// In en, this message translates to:
  /// **'Open activity log'**
  String get openActivityPage;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivity;

  /// No description provided for @headerWelcome.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get headerWelcome;

  /// No description provided for @headerLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get headerLive;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control alerts, updates, language, and system behavior'**
  String get settingsPageSubtitle;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionLiveUpdates.
  ///
  /// In en, this message translates to:
  /// **'Live Updates'**
  String get settingsSectionLiveUpdates;

  /// No description provided for @settingsSectionBehavior.
  ///
  /// In en, this message translates to:
  /// **'General Behavior'**
  String get settingsSectionBehavior;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Session'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsSectionSystem.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get settingsSectionSystem;

  /// No description provided for @soundEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable notification sound'**
  String get soundEnabledTitle;

  /// No description provided for @soundEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play a strong alert when new online orders arrive'**
  String get soundEnabledSubtitle;

  /// No description provided for @pushEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable live notifications'**
  String get pushEnabledTitle;

  /// No description provided for @pushEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add new alerts directly to the notifications center'**
  String get pushEnabledSubtitle;

  /// No description provided for @testNotificationSound.
  ///
  /// In en, this message translates to:
  /// **'Test notification sound'**
  String get testNotificationSound;

  /// No description provided for @testNotificationSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play the current notification sound to verify output'**
  String get testNotificationSoundSubtitle;

  /// No description provided for @testButton.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testButton;

  /// No description provided for @autoRefreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto refresh'**
  String get autoRefreshTitle;

  /// No description provided for @autoRefreshSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh orders and alerts in background every few seconds'**
  String get autoRefreshSubtitle;

  /// No description provided for @analyticsRealtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Realtime analytics'**
  String get analyticsRealtimeTitle;

  /// No description provided for @analyticsRealtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep analytics and charts updated continuously'**
  String get analyticsRealtimeSubtitle;

  /// No description provided for @showClosedBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Show closed branches'**
  String get showClosedBranchesTitle;

  /// No description provided for @showClosedBranchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep closed branches visible in lists and selectors'**
  String get showClosedBranchesSubtitle;

  /// No description provided for @confirmationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm sensitive actions'**
  String get confirmationsTitle;

  /// No description provided for @confirmationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialogs for archive, edit, and cancel operations'**
  String get confirmationsSubtitle;

  /// No description provided for @compactModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Compact mode'**
  String get compactModeTitle;

  /// No description provided for @compactModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce spacing and margins across cards and lists'**
  String get compactModeSubtitle;

  /// No description provided for @securityLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Security level'**
  String get securityLevelTitle;

  /// No description provided for @securityLevelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The dashboard currently relies on local session token storage. 2FA and richer permissions can be added later.'**
  String get securityLevelSubtitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get systemStatus;

  /// No description provided for @systemReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get systemReady;

  /// No description provided for @notificationSoundTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound test'**
  String get notificationSoundTestTitle;

  /// No description provided for @notificationSoundTestBody.
  ///
  /// In en, this message translates to:
  /// **'Notification sound played successfully.'**
  String get notificationSoundTestBody;

  /// No description provided for @notificationSoundTestLog.
  ///
  /// In en, this message translates to:
  /// **'Notification sound was tested from settings page.'**
  String get notificationSoundTestLog;

  /// No description provided for @goToNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get goToNotifications;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get goToSettings;

  /// No description provided for @goToActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get goToActivity;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadCount;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @ordersPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage customer orders'**
  String get ordersPageSubtitle;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get totalLabel;

  /// No description provided for @inProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get inProgressLabel;

  /// No description provided for @refreshingLabel.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshingLabel;

  /// No description provided for @liveLabel.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveLabel;

  /// No description provided for @ordersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by order number, customer, or address...'**
  String get ordersSearchHint;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @selectOrderToView.
  ///
  /// In en, this message translates to:
  /// **'Select an order to view its details'**
  String get selectOrderToView;

  /// No description provided for @noMatchingResults.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get noMatchingResults;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @noOrdersForSelectedBranch.
  ///
  /// In en, this message translates to:
  /// **'No orders for the selected branch, or current orders are not linked to a branch by the backend.'**
  String get noOrdersForSelectedBranch;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @singleNewOrderArrived.
  ///
  /// In en, this message translates to:
  /// **'🎉 A new order has arrived!'**
  String get singleNewOrderArrived;

  /// No description provided for @multipleNewOrdersArrived.
  ///
  /// In en, this message translates to:
  /// **'🎉 {count} new orders have arrived!'**
  String multipleNewOrdersArrived(int count);

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersYet;

  /// No description provided for @noCustomersForSelectedBranch.
  ///
  /// In en, this message translates to:
  /// **'No customers have orders in the selected branch, or current orders are not linked to a branch.'**
  String get noCustomersForSelectedBranch;

  /// No description provided for @noCustomersInSelectedBranch.
  ///
  /// In en, this message translates to:
  /// **'No customers in the selected branch'**
  String get noCustomersInSelectedBranch;

  /// No description provided for @selectCustomerFromList.
  ///
  /// In en, this message translates to:
  /// **'Select a customer from the list'**
  String get selectCustomerFromList;

  /// No description provided for @viewDetailsAndStats.
  ///
  /// In en, this message translates to:
  /// **'To view customer details and statistics'**
  String get viewDetailsAndStats;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @branchesPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage branches and operating status'**
  String get branchesPageSubtitle;

  /// No description provided for @openBranchesShortLabel.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get openBranchesShortLabel;

  /// No description provided for @closedBranchesShortLabel.
  ///
  /// In en, this message translates to:
  /// **'closed'**
  String get closedBranchesShortLabel;

  /// No description provided for @newBranch.
  ///
  /// In en, this message translates to:
  /// **'New branch'**
  String get newBranch;

  /// No description provided for @branchesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by branch name, phone, or address...'**
  String get branchesSearchHint;

  /// No description provided for @allBranchesFilter.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranchesFilter;

  /// No description provided for @openBranchesFilter.
  ///
  /// In en, this message translates to:
  /// **'Open branches'**
  String get openBranchesFilter;

  /// No description provided for @closedBranchesFilter.
  ///
  /// In en, this message translates to:
  /// **'Closed branches'**
  String get closedBranchesFilter;

  /// No description provided for @branchArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Close branch'**
  String get branchArchiveTitle;

  /// No description provided for @branchArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to close branch \"{branchName}\"? It will remain visible in the list but marked as closed.'**
  String branchArchiveMessage(String branchName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @closeBranch.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeBranch;

  /// No description provided for @noBranchesYet.
  ///
  /// In en, this message translates to:
  /// **'No branches yet'**
  String get noBranchesYet;

  /// No description provided for @noClosedBranches.
  ///
  /// In en, this message translates to:
  /// **'No closed branches'**
  String get noClosedBranches;

  /// No description provided for @noMatchingBranches.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get noMatchingBranches;

  /// No description provided for @addNewBranch.
  ///
  /// In en, this message translates to:
  /// **'Add new branch'**
  String get addNewBranch;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @savePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get savePdf;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @invoiceActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print, save, or share the invoice'**
  String get invoiceActionsSubtitle;

  /// No description provided for @orderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get orderStatusTitle;

  /// No description provided for @customerData.
  ///
  /// In en, this message translates to:
  /// **'Customer data'**
  String get customerData;

  /// No description provided for @customerDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer information for this order'**
  String get customerDataSubtitle;

  /// No description provided for @customerId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get customerId;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @withGps.
  ///
  /// In en, this message translates to:
  /// **'With GPS coordinates'**
  String get withGps;

  /// No description provided for @noAddressEntered.
  ///
  /// In en, this message translates to:
  /// **'No address entered'**
  String get noAddressEntered;

  /// No description provided for @accurateCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Accurate coordinates'**
  String get accurateCoordinates;

  /// No description provided for @openGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openGoogleMaps;

  /// No description provided for @preparationBranch.
  ///
  /// In en, this message translates to:
  /// **'Preparation branch'**
  String get preparationBranch;

  /// No description provided for @preparationBranchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The branch responsible for this order'**
  String get preparationBranchSubtitle;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Ordered items'**
  String get orderItems;

  /// No description provided for @productsAndPieces.
  ///
  /// In en, this message translates to:
  /// **'{products} products / {pieces} pieces'**
  String productsAndPieces(int products, int pieces);

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get deliveryFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @finalTotal.
  ///
  /// In en, this message translates to:
  /// **'Final total'**
  String get finalTotal;

  /// No description provided for @totals.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get totals;

  /// No description provided for @totalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amount summary'**
  String get totalsSubtitle;

  /// No description provided for @customerNotes.
  ///
  /// In en, this message translates to:
  /// **'Customer notes'**
  String get customerNotes;

  /// No description provided for @specialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special instructions for the order'**
  String get specialInstructions;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @noPhoneRegistered.
  ///
  /// In en, this message translates to:
  /// **'No phone number registered'**
  String get noPhoneRegistered;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @noAddressRegistered.
  ///
  /// In en, this message translates to:
  /// **'No address registered'**
  String get noAddressRegistered;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @totalOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get totalOrdersLabel;

  /// No description provided for @totalPurchase.
  ///
  /// In en, this message translates to:
  /// **'Total spending'**
  String get totalPurchase;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @averageOrder.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get averageOrder;

  /// No description provided for @lastOrder.
  ///
  /// In en, this message translates to:
  /// **'Last order'**
  String get lastOrder;

  /// No description provided for @latestOrders.
  ///
  /// In en, this message translates to:
  /// **'Latest {count} orders'**
  String latestOrders(int count);

  /// No description provided for @noPreviousOrders.
  ///
  /// In en, this message translates to:
  /// **'No previous orders'**
  String get noPreviousOrders;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block customer'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock customer'**
  String get unblockUser;

  /// No description provided for @updatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updatingLabel;

  /// No description provided for @customerBlockedInfo.
  ///
  /// In en, this message translates to:
  /// **'This customer is blocked from placing new orders.'**
  String get customerBlockedInfo;

  /// No description provided for @suspiciousCancellationRate.
  ///
  /// In en, this message translates to:
  /// **'⚠️ High cancellation rate: {rate}% of orders'**
  String suspiciousCancellationRate(String rate);

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @latestOrderPrefix.
  ///
  /// In en, this message translates to:
  /// **'Last order: '**
  String get latestOrderPrefix;

  /// No description provided for @phoneDisabled.
  ///
  /// In en, this message translates to:
  /// **'Phone disabled'**
  String get phoneDisabled;

  /// No description provided for @branchStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get branchStatusOpen;

  /// No description provided for @branchStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get branchStatusClosed;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @reopenBranch.
  ///
  /// In en, this message translates to:
  /// **'Re-open branch'**
  String get reopenBranch;

  /// No description provided for @pauseBranch.
  ///
  /// In en, this message translates to:
  /// **'Close branch'**
  String get pauseBranch;

  /// No description provided for @branchFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit branch'**
  String get branchFormEditTitle;

  /// No description provided for @branchFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new branch'**
  String get branchFormAddTitle;

  /// No description provided for @branchNameAr.
  ///
  /// In en, this message translates to:
  /// **'Branch name in Arabic *'**
  String get branchNameAr;

  /// No description provided for @branchNameEn.
  ///
  /// In en, this message translates to:
  /// **'Branch Name (English) *'**
  String get branchNameEn;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number *'**
  String get phoneRequired;

  /// No description provided for @addressAr.
  ///
  /// In en, this message translates to:
  /// **'Address in Arabic *'**
  String get addressAr;

  /// No description provided for @addressEn.
  ///
  /// In en, this message translates to:
  /// **'Address (English) *'**
  String get addressEn;

  /// No description provided for @descriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description in Arabic *'**
  String get descriptionAr;

  /// No description provided for @descriptionEn.
  ///
  /// In en, this message translates to:
  /// **'Description (English) *'**
  String get descriptionEn;

  /// No description provided for @branchCloseInfo.
  ///
  /// In en, this message translates to:
  /// **'Closing a branch does not remove it from the list; it remains visible as closed.'**
  String get branchCloseInfo;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @addingBranch.
  ///
  /// In en, this message translates to:
  /// **'Add branch'**
  String get addingBranch;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {count}'**
  String quantityLabel(int count);

  /// No description provided for @otherProductsCount.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more products'**
  String otherProductsCount(int count);

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted product'**
  String get productDeleted;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(int count);

  /// No description provided for @todayTime.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String todayTime(String time);

  /// No description provided for @yesterdayTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday {time}'**
  String yesterdayTime(String time);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String sizeLabel(String size);

  /// No description provided for @inProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgressStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @confirmedStatus.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedStatus;

  /// No description provided for @preparingStatus.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparingStatus;

  /// No description provided for @outForDeliveryStatus.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get outForDeliveryStatus;

  /// No description provided for @deliveredStatus.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredStatus;

  /// No description provided for @cancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledStatus;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @confirmBlock.
  ///
  /// In en, this message translates to:
  /// **'Confirm block'**
  String get confirmBlock;

  /// No description provided for @blockReason.
  ///
  /// In en, this message translates to:
  /// **'Block reason:'**
  String get blockReason;

  /// No description provided for @customReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get customReasonOptional;

  /// No description provided for @writeReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Write any extra details...'**
  String get writeReasonHint;

  /// No description provided for @customerWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'The customer will not be able to place new orders until unblocked'**
  String get customerWillBeBlocked;

  /// No description provided for @confirmBlockAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm block'**
  String get confirmBlockAction;

  /// No description provided for @selectOrWriteReason.
  ///
  /// In en, this message translates to:
  /// **'Please select or write a block reason'**
  String get selectOrWriteReason;

  /// No description provided for @reasonTooManyCancels.
  ///
  /// In en, this message translates to:
  /// **'Too many cancelled orders'**
  String get reasonTooManyCancels;

  /// No description provided for @reasonBadComments.
  ///
  /// In en, this message translates to:
  /// **'Annoying customer / bad comments'**
  String get reasonBadComments;

  /// No description provided for @reasonFraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud attempts'**
  String get reasonFraud;

  /// No description provided for @reasonNoPickup.
  ///
  /// In en, this message translates to:
  /// **'Did not receive confirmed orders'**
  String get reasonNoPickup;

  /// No description provided for @reasonCashRefusal.
  ///
  /// In en, this message translates to:
  /// **'Refused cash on delivery'**
  String get reasonCashRefusal;

  /// No description provided for @reasonBadBehavior.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate behavior'**
  String get reasonBadBehavior;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get reasonOther;

  /// No description provided for @unblockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unblock customer'**
  String get unblockTitle;

  /// No description provided for @unblockMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to unblock \"{name}\"? The customer will be able to order again.'**
  String unblockMessage(String name);

  /// No description provided for @viewDetailsAndStatistics.
  ///
  /// In en, this message translates to:
  /// **'View details and statistics'**
  String get viewDetailsAndStatistics;

  /// No description provided for @orderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get orderStatusLabel;

  /// No description provided for @deliveredSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'✓ Order delivered successfully'**
  String get deliveredSuccessTitle;

  /// No description provided for @deliveredSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The order has been completed and delivered to the customer'**
  String get deliveredSuccessSubtitle;

  /// No description provided for @cancelledOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'🚫 This order was cancelled'**
  String get cancelledOrderTitle;

  /// No description provided for @cancelledOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A cancelled order cannot change status anymore'**
  String get cancelledOrderSubtitle;

  /// No description provided for @goToNextStatus.
  ///
  /// In en, this message translates to:
  /// **'Move to: {status}'**
  String goToNextStatus(String status);

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancellation'**
  String get confirmCancellation;

  /// No description provided for @cancelOrderConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order? This action cannot be undone.'**
  String get cancelOrderConfirmMessage;

  /// No description provided for @backAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backAction;

  /// No description provided for @cancelOrderAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrderAction;

  /// No description provided for @customerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerSectionTitle;

  /// No description provided for @customerSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer information'**
  String get customerSectionSubtitle;

  /// No description provided for @deliveryAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddressTitle;

  /// No description provided for @deliveryAddressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery location details'**
  String get deliveryAddressSubtitle;

  /// No description provided for @preparationBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation branch'**
  String get preparationBranchTitle;

  /// No description provided for @invoiceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceSectionTitle;

  /// No description provided for @invoiceSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print, save, or share the invoice'**
  String get invoiceSectionSubtitle;

  /// No description provided for @itemsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ordered items'**
  String get itemsSectionTitle;

  /// No description provided for @totalsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get totalsSectionTitle;

  /// No description provided for @totalsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order amount summary'**
  String get totalsSectionSubtitle;

  /// No description provided for @notesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer notes'**
  String get notesSectionTitle;

  /// No description provided for @notesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Special instructions'**
  String get notesSectionSubtitle;

  /// No description provided for @exactGps.
  ///
  /// In en, this message translates to:
  /// **'Accurate GPS'**
  String get exactGps;

  /// No description provided for @openInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInGoogleMaps;

  /// No description provided for @branchPhones.
  ///
  /// In en, this message translates to:
  /// **'Branch phones'**
  String get branchPhones;

  /// No description provided for @sizePrefix.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String sizePrefix(String size);

  /// No description provided for @flavorsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Flavors: {flavors}'**
  String flavorsPrefix(String flavors);

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @deliveryFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get deliveryFeeLabel;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @finalTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Final total'**
  String get finalTotalLabel;

  /// No description provided for @customerContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get customerContact;

  /// No description provided for @customerAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get customerAddress;

  /// No description provided for @noAddressSaved.
  ///
  /// In en, this message translates to:
  /// **'No saved address'**
  String get noAddressSaved;

  /// No description provided for @statsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsSectionTitle;

  /// No description provided for @latestOrdersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest orders'**
  String get latestOrdersSectionTitle;

  /// No description provided for @averageOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get averageOrderLabel;

  /// No description provided for @deliveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredLabel;

  /// No description provided for @cancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledLabel;

  /// No description provided for @lastOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Last order: '**
  String get lastOrderLabel;

  /// No description provided for @blockCustomerAction.
  ///
  /// In en, this message translates to:
  /// **'Block customer'**
  String get blockCustomerAction;

  /// No description provided for @unblockCustomerAction.
  ///
  /// In en, this message translates to:
  /// **'Unblock customer'**
  String get unblockCustomerAction;

  /// No description provided for @customerBlockedBanner.
  ///
  /// In en, this message translates to:
  /// **'This customer is blocked from placing new orders.'**
  String get customerBlockedBanner;

  /// No description provided for @openWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get openWhatsapp;

  /// No description provided for @regularTier.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regularTier;

  /// No description provided for @bronzeTier.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronzeTier;

  /// No description provided for @silverTier.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silverTier;

  /// No description provided for @goldTier.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get goldTier;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @reportsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed operational and management reports by selected branch'**
  String get reportsPageSubtitle;

  /// No description provided for @reportExecutiveHeaderAll.
  ///
  /// In en, this message translates to:
  /// **'Executive report - all branches'**
  String get reportExecutiveHeaderAll;

  /// No description provided for @reportExecutiveHeaderBranch.
  ///
  /// In en, this message translates to:
  /// **'Executive report - {branchName}'**
  String reportExecutiveHeaderBranch(String branchName);

  /// No description provided for @reportExecutiveDescription.
  ///
  /// In en, this message translates to:
  /// **'This report is designed for management and shows financial, operational, customer, and branch performance in one place.'**
  String get reportExecutiveDescription;

  /// No description provided for @reportMissingBranchData.
  ///
  /// In en, this message translates to:
  /// **'Branch-linked order data is currently unavailable from the API, so branch-specific reports are limited until the backend returns branchId or branchName.'**
  String get reportMissingBranchData;

  /// No description provided for @activeCustomersLabel.
  ///
  /// In en, this message translates to:
  /// **'Active customers'**
  String get activeCustomersLabel;

  /// No description provided for @repeatCustomersLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat customers'**
  String get repeatCustomersLabel;

  /// No description provided for @financialReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial report'**
  String get financialReportTitle;

  /// No description provided for @todayRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Today revenue'**
  String get todayRevenueLabel;

  /// No description provided for @weekRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Week revenue'**
  String get weekRevenueLabel;

  /// No description provided for @monthRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Month revenue'**
  String get monthRevenueLabel;

  /// No description provided for @averageOrderValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Average order value'**
  String get averageOrderValueLabel;

  /// No description provided for @completedOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed orders'**
  String get completedOrdersLabel;

  /// No description provided for @cancelledOrdersCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled orders'**
  String get cancelledOrdersCountLabel;

  /// No description provided for @customersReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer report'**
  String get customersReportTitle;

  /// No description provided for @noEnoughCustomerData.
  ///
  /// In en, this message translates to:
  /// **'Not enough customer data yet'**
  String get noEnoughCustomerData;

  /// No description provided for @ordersCountWord.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get ordersCountWord;

  /// No description provided for @branchesReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches report'**
  String get branchesReportTitle;

  /// No description provided for @branchesOverview.
  ///
  /// In en, this message translates to:
  /// **'Total branches: {total} | Open: {open} | Closed: {closed}'**
  String branchesOverview(int total, int open, int closed);

  /// No description provided for @branchDistributionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Branch order distribution cannot be generated because current orders do not contain branch data from the API.'**
  String get branchDistributionUnavailable;

  /// No description provided for @recommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational recommendations'**
  String get recommendationsTitle;

  /// No description provided for @noCriticalRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No critical recommendations at the moment.'**
  String get noCriticalRecommendations;

  /// No description provided for @recommendationCancelledOrders.
  ///
  /// In en, this message translates to:
  /// **'Review cancellation reasons because the current number of cancelled orders is {count}.'**
  String recommendationCancelledOrders(int count);

  /// No description provided for @recommendationLowActiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active customers are relatively low; consider targeted offers for repeat customers.'**
  String get recommendationLowActiveCustomers;

  /// No description provided for @recommendationBranchBalance.
  ///
  /// In en, this message translates to:
  /// **'Review branch load distribution to ensure balanced operations, especially during peak times.'**
  String get recommendationBranchBalance;

  /// No description provided for @recommendationAverageOrder.
  ///
  /// In en, this message translates to:
  /// **'The current average order is {amount} EGP; it can be used to design upsell offers.'**
  String recommendationAverageOrder(String amount);

  /// No description provided for @analyticsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics dashboards for finance, customers, employees, sales, branches, and orders'**
  String get analyticsPageSubtitle;

  /// No description provided for @financialTab.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financialTab;

  /// No description provided for @customersTab.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTab;

  /// No description provided for @employeesTab.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employeesTab;

  /// No description provided for @salesTab.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesTab;

  /// No description provided for @branchesTab.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesTab;

  /// No description provided for @ordersTab.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTab;

  /// No description provided for @analyticsScopeAll.
  ///
  /// In en, this message translates to:
  /// **'Current analysis: all branches'**
  String get analyticsScopeAll;

  /// No description provided for @analyticsScopeBranch.
  ///
  /// In en, this message translates to:
  /// **'Current analysis: {branchName}'**
  String analyticsScopeBranch(String branchName);

  /// No description provided for @analyticsScopeDescription.
  ///
  /// In en, this message translates to:
  /// **'This page combines multidimensional analytics based on available orders, customers, and branches data.'**
  String get analyticsScopeDescription;

  /// No description provided for @analyticsMissingBranchData.
  ///
  /// In en, this message translates to:
  /// **'Current orders do not provide branchId/branchName, so branch-based analytics will remain limited until the backend links orders to branches.'**
  String get analyticsMissingBranchData;

  /// No description provided for @totalRevenueKpi.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get totalRevenueKpi;

  /// No description provided for @todayRevenueKpi.
  ///
  /// In en, this message translates to:
  /// **'Today revenue'**
  String get todayRevenueKpi;

  /// No description provided for @weekRevenueKpi.
  ///
  /// In en, this message translates to:
  /// **'Week revenue'**
  String get weekRevenueKpi;

  /// No description provided for @monthRevenueKpi.
  ///
  /// In en, this message translates to:
  /// **'Month revenue'**
  String get monthRevenueKpi;

  /// No description provided for @orderCountKpi.
  ///
  /// In en, this message translates to:
  /// **'Orders count'**
  String get orderCountKpi;

  /// No description provided for @totalCustomersKpi.
  ///
  /// In en, this message translates to:
  /// **'Total customers'**
  String get totalCustomersKpi;

  /// No description provided for @activeCustomersKpi.
  ///
  /// In en, this message translates to:
  /// **'Active customers'**
  String get activeCustomersKpi;

  /// No description provided for @repeatCustomersKpi.
  ///
  /// In en, this message translates to:
  /// **'Repeat customers'**
  String get repeatCustomersKpi;

  /// No description provided for @vipCustomersKpi.
  ///
  /// In en, this message translates to:
  /// **'VIP customers'**
  String get vipCustomersKpi;

  /// No description provided for @topSpendingCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Top spending customers'**
  String get topSpendingCustomersTitle;

  /// No description provided for @employeesAnalyticsEstimatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Employees analytics (estimated)'**
  String get employeesAnalyticsEstimatedTitle;

  /// No description provided for @employeesEstimatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There is no real employees API yet, so the figures below are operational estimates based on order load and number of open branches.'**
  String get employeesEstimatedSubtitle;

  /// No description provided for @neededCashiers.
  ///
  /// In en, this message translates to:
  /// **'Required cashiers'**
  String get neededCashiers;

  /// No description provided for @neededKitchen.
  ///
  /// In en, this message translates to:
  /// **'Required kitchen staff'**
  String get neededKitchen;

  /// No description provided for @neededDelivery.
  ///
  /// In en, this message translates to:
  /// **'Required delivery staff'**
  String get neededDelivery;

  /// No description provided for @loadPerBranch.
  ///
  /// In en, this message translates to:
  /// **'Load per branch'**
  String get loadPerBranch;

  /// No description provided for @topProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get topProductsTitle;

  /// No description provided for @openBranchesKpi.
  ///
  /// In en, this message translates to:
  /// **'Open branches'**
  String get openBranchesKpi;

  /// No description provided for @closedBranchesKpi.
  ///
  /// In en, this message translates to:
  /// **'Closed branches'**
  String get closedBranchesKpi;

  /// No description provided for @totalBranchesKpi.
  ///
  /// In en, this message translates to:
  /// **'Total branches'**
  String get totalBranchesKpi;

  /// No description provided for @linkedOrdersToBranch.
  ///
  /// In en, this message translates to:
  /// **'Orders linked to branch'**
  String get linkedOrdersToBranch;

  /// No description provided for @branchLinkWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Branch linking warning'**
  String get branchLinkWarningTitle;

  /// No description provided for @branchDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Order distribution by branch'**
  String get branchDistributionTitle;

  /// No description provided for @inProgressOrdersKpi.
  ///
  /// In en, this message translates to:
  /// **'In progress orders'**
  String get inProgressOrdersKpi;

  /// No description provided for @completionRateKpi.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get completionRateKpi;

  /// No description provided for @cancellationRateKpi.
  ///
  /// In en, this message translates to:
  /// **'Cancellation rate'**
  String get cancellationRateKpi;

  /// No description provided for @revenueChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly revenue'**
  String get revenueChartTitle;

  /// No description provided for @revenueChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sales performance over the last 7 days'**
  String get revenueChartSubtitle;

  /// No description provided for @noDataLabel.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noDataLabel;

  /// No description provided for @ordersByStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders by status'**
  String get ordersByStatusTitle;

  /// No description provided for @ordersByStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current order distribution'**
  String get ordersByStatusSubtitle;

  /// No description provided for @noOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrdersLabel;

  /// No description provided for @topProductsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Top selling products'**
  String get topProductsChartTitle;

  /// No description provided for @topProductsChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top 5 most ordered products'**
  String get topProductsChartSubtitle;

  /// No description provided for @totalOrdersWord.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get totalOrdersWord;

  /// No description provided for @requestWord.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get requestWord;

  /// No description provided for @activityPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A full timeline for operations, alerts, and updates'**
  String get activityPageSubtitle;

  /// No description provided for @eventsWord.
  ///
  /// In en, this message translates to:
  /// **'events'**
  String get eventsWord;

  /// No description provided for @clearLog.
  ///
  /// In en, this message translates to:
  /// **'Clear log'**
  String get clearLog;

  /// No description provided for @overallLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overallLabel;

  /// No description provided for @warningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get warningsLabel;

  /// No description provided for @criticalLabel.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get criticalLabel;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @systemLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLabel;

  /// No description provided for @loginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLabel;

  /// No description provided for @notificationsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order alerts, critical updates, and system notifications'**
  String get notificationsPageSubtitle;

  /// No description provided for @markAllReadAction.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllReadAction;

  /// No description provided for @unreadLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadLabel;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @ordersFilter.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersFilter;

  /// No description provided for @branchesFilter.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesFilter;

  /// No description provided for @customersFilter.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersFilter;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Clear list'**
  String get clearList;

  /// No description provided for @alertLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alertLabel;

  /// No description provided for @activityTypeOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get activityTypeOrder;

  /// No description provided for @activityTypeBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get activityTypeBranch;

  /// No description provided for @activityTypeUser.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get activityTypeUser;

  /// No description provided for @activityTypeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get activityTypeSystem;

  /// No description provided for @activityTypeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get activityTypeSettings;

  /// No description provided for @dashboardPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardPageTitle;

  /// No description provided for @dashboardPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today business summary'**
  String get dashboardPageSubtitle;

  /// No description provided for @autoRefreshEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'🟢 Auto refresh enabled'**
  String get autoRefreshEnabledLabel;

  /// No description provided for @autoRefreshingLabel.
  ///
  /// In en, this message translates to:
  /// **'🔄 Refreshing...'**
  String get autoRefreshingLabel;

  /// No description provided for @everySeconds.
  ///
  /// In en, this message translates to:
  /// **'(every {seconds} sec)'**
  String everySeconds(int seconds);

  /// No description provided for @lastUpdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Last update: {time}'**
  String lastUpdateLabel(String time);

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'✅ Updated'**
  String get updatedSuccessfully;

  /// No description provided for @dashboardWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today business summary ✨'**
  String get dashboardWelcomeSubtitle;

  /// No description provided for @totalRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get totalRevenueLabel;

  /// No description provided for @allPeriodsLabel.
  ///
  /// In en, this message translates to:
  /// **'All periods'**
  String get allPeriodsLabel;

  /// No description provided for @weeklySalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly sales'**
  String get weeklySalesLabel;

  /// No description provided for @last7DaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7DaysLabel;

  /// No description provided for @averageOrderValueKpi.
  ///
  /// In en, this message translates to:
  /// **'Average order value'**
  String get averageOrderValueKpi;

  /// No description provided for @availableProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available products'**
  String get availableProductsLabel;

  /// No description provided for @categoriesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get categoriesCountLabel;

  /// No description provided for @recentOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest orders'**
  String get recentOrdersTitle;

  /// No description provided for @recentOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest transactions'**
  String get recentOrdersSubtitle;

  /// No description provided for @noOrdersForBranch.
  ///
  /// In en, this message translates to:
  /// **'No orders for selected branch'**
  String get noOrdersForBranch;

  /// No description provided for @productsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsPageTitle;

  /// No description provided for @productsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage store products'**
  String get productsPageSubtitle;

  /// No description provided for @availableLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableLabel;

  /// No description provided for @soldOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOutLabel;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProduct;

  /// No description provided for @productsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a product...'**
  String get productsSearchHint;

  /// No description provided for @allFilterProducts.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilterProducts;

  /// No description provided for @activeOnlyFilter.
  ///
  /// In en, this message translates to:
  /// **'Available only'**
  String get activeOnlyFilter;

  /// No description provided for @soldOutOnlyFilter.
  ///
  /// In en, this message translates to:
  /// **'Sold Out only'**
  String get soldOutOnlyFilter;

  /// No description provided for @confirmSoldOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Sold Out'**
  String get confirmSoldOutTitle;

  /// No description provided for @confirmSoldOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark \"{name}\" as Sold Out? It will appear unavailable to customers.'**
  String confirmSoldOutMessage(String name);

  /// No description provided for @soldOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOutAction;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// No description provided for @noSoldOutProducts.
  ///
  /// In en, this message translates to:
  /// **'No Sold Out products'**
  String get noSoldOutProducts;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add new product'**
  String get addNewProduct;

  /// No description provided for @featuredLabel.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredLabel;

  /// No description provided for @bestSellerLabel.
  ///
  /// In en, this message translates to:
  /// **'Best seller'**
  String get bestSellerLabel;

  /// No description provided for @customizableLabel.
  ///
  /// In en, this message translates to:
  /// **'Customizable'**
  String get customizableLabel;

  /// No description provided for @availableStatus.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableStatus;

  /// No description provided for @soldOutStatus.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOutStatus;

  /// No description provided for @sizesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sizes'**
  String sizesCount(int count);

  /// No description provided for @flavorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} flavors'**
  String flavorsCount(int count);

  /// No description provided for @enableProductForSale.
  ///
  /// In en, this message translates to:
  /// **'Enable product for sale'**
  String get enableProductForSale;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @markAsSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Mark as Sold Out'**
  String get markAsSoldOut;

  /// No description provided for @productDetailsBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get productDetailsBack;

  /// No description provided for @basePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get basePriceLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @availableSizesTitle.
  ///
  /// In en, this message translates to:
  /// **'Available sizes'**
  String get availableSizesTitle;

  /// No description provided for @noSizesAdded.
  ///
  /// In en, this message translates to:
  /// **'No sizes added'**
  String get noSizesAdded;

  /// No description provided for @availableFlavorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available flavors'**
  String get availableFlavorsTitle;

  /// No description provided for @noFlavorsAdded.
  ///
  /// In en, this message translates to:
  /// **'No flavors added'**
  String get noFlavorsAdded;

  /// No description provided for @productWizardEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get productWizardEditTitle;

  /// No description provided for @productWizardAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new product'**
  String get productWizardAddTitle;

  /// No description provided for @wizardStepBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get wizardStepBasic;

  /// No description provided for @wizardStepSizes.
  ///
  /// In en, this message translates to:
  /// **'Sizes'**
  String get wizardStepSizes;

  /// No description provided for @wizardStepFlavors.
  ///
  /// In en, this message translates to:
  /// **'Flavors'**
  String get wizardStepFlavors;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get selectCategoryError;

  /// No description provided for @selectProductImageError.
  ///
  /// In en, this message translates to:
  /// **'Choose a product image'**
  String get selectProductImageError;

  /// No description provided for @nameArField.
  ///
  /// In en, this message translates to:
  /// **'Name in Arabic *'**
  String get nameArField;

  /// No description provided for @nameEnField.
  ///
  /// In en, this message translates to:
  /// **'Name (English) *'**
  String get nameEnField;

  /// No description provided for @descriptionArField.
  ///
  /// In en, this message translates to:
  /// **'Description in Arabic *'**
  String get descriptionArField;

  /// No description provided for @descriptionEnField.
  ///
  /// In en, this message translates to:
  /// **'Description (English) *'**
  String get descriptionEnField;

  /// No description provided for @defaultSizeNameField.
  ///
  /// In en, this message translates to:
  /// **'Default size name'**
  String get defaultSizeNameField;

  /// No description provided for @basePriceField.
  ///
  /// In en, this message translates to:
  /// **'Base price *'**
  String get basePriceField;

  /// No description provided for @featuredOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured ⭐'**
  String get featuredOptionTitle;

  /// No description provided for @featuredOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show in featured section'**
  String get featuredOptionSubtitle;

  /// No description provided for @bestSellerOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Best seller 🔥'**
  String get bestSellerOptionTitle;

  /// No description provided for @bestSellerOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show in best sellers'**
  String get bestSellerOptionSubtitle;

  /// No description provided for @customizableOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Customizable 🎨'**
  String get customizableOptionTitle;

  /// No description provided for @customizableOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contains sizes/flavors'**
  String get customizableOptionSubtitle;

  /// No description provided for @saveAndNextSizes.
  ///
  /// In en, this message translates to:
  /// **'Save and continue to sizes'**
  String get saveAndNextSizes;

  /// No description provided for @saveAndContinueSizesLoading.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saveAndContinueSizesLoading;

  /// No description provided for @pickProductImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose product image *'**
  String get pickProductImage;

  /// No description provided for @requiredFieldShort.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredFieldShort;

  /// No description provided for @noCategoriesFirst.
  ///
  /// In en, this message translates to:
  /// **'No categories available. Add a category first.'**
  String get noCategoriesFirst;

  /// No description provided for @categoryField.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get categoryField;

  /// No description provided for @mustChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'You must choose a category'**
  String get mustChooseCategory;

  /// No description provided for @productSizeAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} sizes added successfully'**
  String productSizeAddedSuccess(int count);

  /// No description provided for @productSizesTitle.
  ///
  /// In en, this message translates to:
  /// **'Available product sizes'**
  String get productSizesTitle;

  /// No description provided for @productSizesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add sizes with price and dimensions'**
  String get productSizesSubtitle;

  /// No description provided for @addSize.
  ///
  /// In en, this message translates to:
  /// **'Add size'**
  String get addSize;

  /// No description provided for @existingSizes.
  ///
  /// In en, this message translates to:
  /// **'Existing sizes:'**
  String get existingSizes;

  /// No description provided for @noSizesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No sizes added yet'**
  String get noSizesAddedYet;

  /// No description provided for @skipIfNoSizes.
  ///
  /// In en, this message translates to:
  /// **'You can skip this step if the product has no sizes'**
  String get skipIfNoSizes;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @savingSizes.
  ///
  /// In en, this message translates to:
  /// **'Saving sizes...'**
  String get savingSizes;

  /// No description provided for @skipToFlavors.
  ///
  /// In en, this message translates to:
  /// **'Skip to flavors'**
  String get skipToFlavors;

  /// No description provided for @saveSizesAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save {count} sizes and continue'**
  String saveSizesAndContinue(int count);

  /// No description provided for @addSizeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add size'**
  String get addSizeDialogTitle;

  /// No description provided for @sizeImageOptional.
  ///
  /// In en, this message translates to:
  /// **'Size image (optional)'**
  String get sizeImageOptional;

  /// No description provided for @sizeNameArField.
  ///
  /// In en, this message translates to:
  /// **'Size name AR *'**
  String get sizeNameArField;

  /// No description provided for @sizeNameEnField.
  ///
  /// In en, this message translates to:
  /// **'Size name EN *'**
  String get sizeNameEnField;

  /// No description provided for @sizeTokenField.
  ///
  /// In en, this message translates to:
  /// **'SizeName (e.g. S/M/L)'**
  String get sizeTokenField;

  /// No description provided for @sizeDescriptionArField.
  ///
  /// In en, this message translates to:
  /// **'Description AR'**
  String get sizeDescriptionArField;

  /// No description provided for @sizeDescriptionEnField.
  ///
  /// In en, this message translates to:
  /// **'Description EN'**
  String get sizeDescriptionEnField;

  /// No description provided for @priceField.
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get priceField;

  /// No description provided for @radiusField.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get radiusField;

  /// No description provided for @heightField.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightField;

  /// No description provided for @servesField.
  ///
  /// In en, this message translates to:
  /// **'Serves (e.g. 4-6 people)'**
  String get servesField;

  /// No description provided for @availableSwitch.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableSwitch;

  /// No description provided for @addSizeAction.
  ///
  /// In en, this message translates to:
  /// **'Add size'**
  String get addSizeAction;

  /// No description provided for @availableFlavorsChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose available flavors'**
  String get availableFlavorsChooseTitle;

  /// No description provided for @availableFlavorsChooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select flavors and optional extra price'**
  String get availableFlavorsChooseSubtitle;

  /// No description provided for @noFlavorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No flavors available. Add flavors first from the flavors page.'**
  String get noFlavorsAvailable;

  /// No description provided for @extraPriceField.
  ///
  /// In en, this message translates to:
  /// **'Extra price'**
  String get extraPriceField;

  /// No description provided for @saveAndFinishFlavorsLoading.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saveAndFinishFlavorsLoading;

  /// No description provided for @finishWithoutFlavors.
  ///
  /// In en, this message translates to:
  /// **'Finish without flavors'**
  String get finishWithoutFlavors;

  /// No description provided for @saveFlavorsAndFinish.
  ///
  /// In en, this message translates to:
  /// **'Save {count} flavors and finish'**
  String saveFlavorsAndFinish(int count);

  /// No description provided for @categoriesPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your products into categories'**
  String get categoriesPageSubtitle;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @searchCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a category...'**
  String get searchCategoryHint;

  /// No description provided for @activeCategoriesFilter.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeCategoriesFilter;

  /// No description provided for @archivedCategoriesFilter.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedCategoriesFilter;

  /// No description provided for @confirmArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm archive'**
  String get confirmArchiveTitle;

  /// No description provided for @categoryArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive category \"{name}\"?\nProducts count: {count}'**
  String categoryArchiveMessage(String name, int count);

  /// No description provided for @archiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveAction;

  /// No description provided for @noArchivedCategories.
  ///
  /// In en, this message translates to:
  /// **'No archived categories'**
  String get noArchivedCategories;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesAvailable;

  /// No description provided for @addCategoryAction.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategoryAction;

  /// No description provided for @archivedBadge.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedBadge;

  /// No description provided for @productsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String productsCountLabel(int count);

  /// No description provided for @chooseImageRequired.
  ///
  /// In en, this message translates to:
  /// **'You must choose an image'**
  String get chooseImageRequired;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategoryTitle;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new category'**
  String get addCategoryTitle;

  /// No description provided for @saveCategoryChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveCategoryChanges;

  /// No description provided for @addCategoryButton.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategoryButton;

  /// No description provided for @changeImageTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to change image'**
  String get changeImageTap;

  /// No description provided for @pickCategoryImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose category image *'**
  String get pickCategoryImage;

  /// No description provided for @flavorsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage product flavors'**
  String get flavorsPageSubtitle;

  /// No description provided for @availableFlavorsLabel.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get availableFlavorsLabel;

  /// No description provided for @archivedFlavorsLabel.
  ///
  /// In en, this message translates to:
  /// **'archived'**
  String get archivedFlavorsLabel;

  /// No description provided for @newFlavor.
  ///
  /// In en, this message translates to:
  /// **'New flavor'**
  String get newFlavor;

  /// No description provided for @searchFlavorHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a flavor...'**
  String get searchFlavorHint;

  /// No description provided for @availableFilter.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableFilter;

  /// No description provided for @unavailableFilter.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailableFilter;

  /// No description provided for @archivedFilter.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedFilter;

  /// No description provided for @confirmFlavorArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm archive'**
  String get confirmFlavorArchiveTitle;

  /// No description provided for @flavorArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive flavor \"{name}\"?'**
  String flavorArchiveMessage(String name);

  /// No description provided for @noArchivedFlavors.
  ///
  /// In en, this message translates to:
  /// **'No archived flavors'**
  String get noArchivedFlavors;

  /// No description provided for @allFlavorsAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'All flavors are available 👍'**
  String get allFlavorsAvailableLabel;

  /// No description provided for @noFlavorsCreated.
  ///
  /// In en, this message translates to:
  /// **'No flavors yet'**
  String get noFlavorsCreated;

  /// No description provided for @addFlavorAction.
  ///
  /// In en, this message translates to:
  /// **'Add flavor'**
  String get addFlavorAction;

  /// No description provided for @flavorArchivedBadge.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get flavorArchivedBadge;

  /// No description provided for @flavorUnavailableBadge.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get flavorUnavailableBadge;

  /// No description provided for @flavorAvailableBadge.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get flavorAvailableBadge;

  /// No description provided for @editFlavorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit flavor'**
  String get editFlavorTitle;

  /// No description provided for @addFlavorTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new flavor'**
  String get addFlavorTitle;

  /// No description provided for @availableForSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Available for selection ✓'**
  String get availableForSelectionTitle;

  /// No description provided for @availableForSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customers can choose this flavor'**
  String get availableForSelectionSubtitle;

  /// No description provided for @saveFlavorChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveFlavorChanges;

  /// No description provided for @addFlavorButton.
  ///
  /// In en, this message translates to:
  /// **'Add flavor'**
  String get addFlavorButton;

  /// No description provided for @pickOptionalImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose an image (optional)'**
  String get pickOptionalImage;

  /// No description provided for @basicInfoSavedNextSizes.
  ///
  /// In en, this message translates to:
  /// **'Save and continue to sizes'**
  String get basicInfoSavedNextSizes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
