// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BAR Sweets - Dashboard';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get dashboardShellSubtitle => 'Full business control panel';

  @override
  String get products => 'Products';

  @override
  String get categories => 'Categories';

  @override
  String get flavors => 'Flavors';

  @override
  String get inventory => 'Inventory';

  @override
  String get customers => 'Customers';

  @override
  String get employees => 'Employees';

  @override
  String get coupons => 'Coupons';

  @override
  String get reports => 'Reports';

  @override
  String get analytics => 'Analytics';

  @override
  String get branches => 'Branches';

  @override
  String get notifications => 'Notifications';

  @override
  String get activityLog => 'Activity Log';

  @override
  String get settings => 'Settings';

  @override
  String get orders => 'Orders';

  @override
  String get searchHint => 'Search...';

  @override
  String get allBranches => 'All Branches';

  @override
  String get branchClosedLabel => 'Closed';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get owner => 'Owner';

  @override
  String get logout => 'Logout';

  @override
  String get userMenu => 'User menu';

  @override
  String get openNotificationsPage => 'Open notifications page';

  @override
  String get lastNotifications => 'Latest notifications';

  @override
  String get markAllRead => 'Read all';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get latestActivity => 'Latest activity';

  @override
  String get openActivityPage => 'Open activity log';

  @override
  String get noActivity => 'No activity yet';

  @override
  String get headerWelcome => 'Overview';

  @override
  String get headerLive => 'Live';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageSubtitle =>
      'Control alerts, updates, language, and system behavior';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsSectionNotifications => 'Notifications & Alerts';

  @override
  String get settingsSectionLiveUpdates => 'Live Updates';

  @override
  String get settingsSectionBehavior => 'General Behavior';

  @override
  String get settingsSectionSecurity => 'Security & Session';

  @override
  String get settingsSectionSystem => 'System Information';

  @override
  String get soundEnabledTitle => 'Enable notification sound';

  @override
  String get soundEnabledSubtitle =>
      'Play a strong alert when new online orders arrive';

  @override
  String get pushEnabledTitle => 'Enable live notifications';

  @override
  String get pushEnabledSubtitle =>
      'Add new alerts directly to the notifications center';

  @override
  String get testNotificationSound => 'Test notification sound';

  @override
  String get testNotificationSoundSubtitle =>
      'Play the current notification sound to verify output';

  @override
  String get testButton => 'Test';

  @override
  String get autoRefreshTitle => 'Auto refresh';

  @override
  String get autoRefreshSubtitle =>
      'Refresh orders and alerts in background every few seconds';

  @override
  String get analyticsRealtimeTitle => 'Realtime analytics';

  @override
  String get analyticsRealtimeSubtitle =>
      'Keep analytics and charts updated continuously';

  @override
  String get showClosedBranchesTitle => 'Show closed branches';

  @override
  String get showClosedBranchesSubtitle =>
      'Keep closed branches visible in lists and selectors';

  @override
  String get confirmationsTitle => 'Confirm sensitive actions';

  @override
  String get confirmationsSubtitle =>
      'Show confirmation dialogs for archive, edit, and cancel operations';

  @override
  String get compactModeTitle => 'Compact mode';

  @override
  String get compactModeSubtitle =>
      'Reduce spacing and margins across cards and lists';

  @override
  String get securityLevelTitle => 'Security level';

  @override
  String get securityLevelSubtitle =>
      'The dashboard currently relies on local session token storage. 2FA and richer permissions can be added later.';

  @override
  String get appVersion => 'App version';

  @override
  String get systemStatus => 'System status';

  @override
  String get systemReady => 'Ready';

  @override
  String get notificationSoundTestTitle => 'Sound test';

  @override
  String get notificationSoundTestBody =>
      'Notification sound played successfully.';

  @override
  String get notificationSoundTestLog =>
      'Notification sound was tested from settings page.';

  @override
  String get goToNotifications => 'Notifications';

  @override
  String get goToSettings => 'Settings';

  @override
  String get goToActivity => 'Activity';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get unreadCount => 'Unread';

  @override
  String get viewAll => 'View all';

  @override
  String get ordersPageSubtitle => 'Manage customer orders';

  @override
  String get totalLabel => 'total';

  @override
  String get inProgressLabel => 'in progress';

  @override
  String get refreshingLabel => 'Refreshing...';

  @override
  String get liveLabel => 'Live';

  @override
  String get ordersSearchHint =>
      'Search by order number, customer, or address...';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get selectOrderToView => 'Select an order to view its details';

  @override
  String get noMatchingResults => 'No matching results';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get noOrdersForSelectedBranch =>
      'No orders for the selected branch, or current orders are not linked to a branch by the backend.';

  @override
  String get retry => 'Retry';

  @override
  String get singleNewOrderArrived => '🎉 A new order has arrived!';

  @override
  String multipleNewOrdersArrived(int count) {
    return '🎉 $count new orders have arrived!';
  }

  @override
  String get noCustomersYet => 'No customers yet';

  @override
  String get noCustomersForSelectedBranch =>
      'No customers have orders in the selected branch, or current orders are not linked to a branch.';

  @override
  String get noCustomersInSelectedBranch =>
      'No customers in the selected branch';

  @override
  String get selectCustomerFromList => 'Select a customer from the list';

  @override
  String get viewDetailsAndStats => 'To view customer details and statistics';

  @override
  String get reload => 'Reload';

  @override
  String get branchesPageSubtitle => 'Manage branches and operating status';

  @override
  String get openBranchesShortLabel => 'open';

  @override
  String get closedBranchesShortLabel => 'closed';

  @override
  String get newBranch => 'New branch';

  @override
  String get branchesSearchHint =>
      'Search by branch name, phone, or address...';

  @override
  String get allBranchesFilter => 'All branches';

  @override
  String get openBranchesFilter => 'Open branches';

  @override
  String get closedBranchesFilter => 'Closed branches';

  @override
  String get branchArchiveTitle => 'Close branch';

  @override
  String branchArchiveMessage(String branchName) {
    return 'Do you want to close branch \"$branchName\"? It will remain visible in the list but marked as closed.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get closeBranch => 'Close';

  @override
  String get noBranchesYet => 'No branches yet';

  @override
  String get noClosedBranches => 'No closed branches';

  @override
  String get noMatchingBranches => 'No matching results';

  @override
  String get addNewBranch => 'Add new branch';

  @override
  String get print => 'Print';

  @override
  String get preview => 'Preview';

  @override
  String get savePdf => 'Save PDF';

  @override
  String get share => 'Share';

  @override
  String get invoice => 'Invoice';

  @override
  String get invoiceActionsSubtitle => 'Print, save, or share the invoice';

  @override
  String get orderStatusTitle => 'Order status';

  @override
  String get customerData => 'Customer data';

  @override
  String get customerDataSubtitle => 'Customer information for this order';

  @override
  String get customerId => 'ID';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get withGps => 'With GPS coordinates';

  @override
  String get noAddressEntered => 'No address entered';

  @override
  String get accurateCoordinates => 'Accurate coordinates';

  @override
  String get openGoogleMaps => 'Open in Google Maps';

  @override
  String get preparationBranch => 'Preparation branch';

  @override
  String get preparationBranchSubtitle =>
      'The branch responsible for this order';

  @override
  String get orderItems => 'Ordered items';

  @override
  String productsAndPieces(int products, int pieces) {
    return '$products products / $pieces pieces';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery fee';

  @override
  String get discount => 'Discount';

  @override
  String get finalTotal => 'Final total';

  @override
  String get totals => 'Totals';

  @override
  String get totalsSubtitle => 'Amount summary';

  @override
  String get customerNotes => 'Customer notes';

  @override
  String get specialInstructions => 'Special instructions for the order';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get call => 'Call';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get noPhoneRegistered => 'No phone number registered';

  @override
  String get address => 'Address';

  @override
  String get noAddressRegistered => 'No address registered';

  @override
  String get stats => 'Statistics';

  @override
  String get totalOrdersLabel => 'Total orders';

  @override
  String get totalPurchase => 'Total spending';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get averageOrder => 'Average order';

  @override
  String get lastOrder => 'Last order';

  @override
  String latestOrders(int count) {
    return 'Latest $count orders';
  }

  @override
  String get noPreviousOrders => 'No previous orders';

  @override
  String get blockUser => 'Block customer';

  @override
  String get unblockUser => 'Unblock customer';

  @override
  String get updatingLabel => 'Updating...';

  @override
  String get customerBlockedInfo =>
      'This customer is blocked from placing new orders.';

  @override
  String suspiciousCancellationRate(String rate) {
    return '⚠️ High cancellation rate: $rate% of orders';
  }

  @override
  String get contact => 'Contact';

  @override
  String get latestOrderPrefix => 'Last order: ';

  @override
  String get phoneDisabled => 'Phone disabled';

  @override
  String get branchStatusOpen => 'Open';

  @override
  String get branchStatusClosed => 'Closed';

  @override
  String get edit => 'Edit';

  @override
  String get reopenBranch => 'Re-open branch';

  @override
  String get pauseBranch => 'Close branch';

  @override
  String get branchFormEditTitle => 'Edit branch';

  @override
  String get branchFormAddTitle => 'Add new branch';

  @override
  String get branchNameAr => 'Branch name in Arabic *';

  @override
  String get branchNameEn => 'Branch Name (English) *';

  @override
  String get phoneRequired => 'Phone number *';

  @override
  String get addressAr => 'Address in Arabic *';

  @override
  String get addressEn => 'Address (English) *';

  @override
  String get descriptionAr => 'Description in Arabic *';

  @override
  String get descriptionEn => 'Description (English) *';

  @override
  String get branchCloseInfo =>
      'Closing a branch does not remove it from the list; it remains visible as closed.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get addingBranch => 'Add branch';

  @override
  String get saving => 'Saving...';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get blocked => 'Blocked';

  @override
  String get orderTotal => 'Total';

  @override
  String quantityLabel(int count) {
    return 'Quantity: $count';
  }

  @override
  String otherProductsCount(int count) {
    return '+ $count more products';
  }

  @override
  String get productDeleted => 'Deleted product';

  @override
  String get now => 'Now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String todayTime(String time) {
    return 'Today $time';
  }

  @override
  String yesterdayTime(String time) {
    return 'Yesterday $time';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String sizeLabel(String size) {
    return 'Size: $size';
  }

  @override
  String get inProgressStatus => 'In progress';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get confirmedStatus => 'Confirmed';

  @override
  String get preparingStatus => 'Preparing';

  @override
  String get outForDeliveryStatus => 'Out for delivery';

  @override
  String get deliveredStatus => 'Delivered';

  @override
  String get cancelledStatus => 'Cancelled';

  @override
  String get unknown => 'Unknown';

  @override
  String get confirmBlock => 'Confirm block';

  @override
  String get blockReason => 'Block reason:';

  @override
  String get customReasonOptional => 'Additional details (optional)';

  @override
  String get writeReasonHint => 'Write any extra details...';

  @override
  String get customerWillBeBlocked =>
      'The customer will not be able to place new orders until unblocked';

  @override
  String get confirmBlockAction => 'Confirm block';

  @override
  String get selectOrWriteReason => 'Please select or write a block reason';

  @override
  String get reasonTooManyCancels => 'Too many cancelled orders';

  @override
  String get reasonBadComments => 'Annoying customer / bad comments';

  @override
  String get reasonFraud => 'Fraud attempts';

  @override
  String get reasonNoPickup => 'Did not receive confirmed orders';

  @override
  String get reasonCashRefusal => 'Refused cash on delivery';

  @override
  String get reasonBadBehavior => 'Inappropriate behavior';

  @override
  String get reasonOther => 'Other reason';

  @override
  String get unblockTitle => 'Unblock customer';

  @override
  String unblockMessage(String name) {
    return 'Do you want to unblock \"$name\"? The customer will be able to order again.';
  }

  @override
  String get viewDetailsAndStatistics => 'View details and statistics';

  @override
  String get orderStatusLabel => 'Order status';

  @override
  String get deliveredSuccessTitle => '✓ Order delivered successfully';

  @override
  String get deliveredSuccessSubtitle =>
      'The order has been completed and delivered to the customer';

  @override
  String get cancelledOrderTitle => '🚫 This order was cancelled';

  @override
  String get cancelledOrderSubtitle =>
      'A cancelled order cannot change status anymore';

  @override
  String goToNextStatus(String status) {
    return 'Move to: $status';
  }

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get confirmCancellation => 'Confirm cancellation';

  @override
  String get cancelOrderConfirmMessage =>
      'Are you sure you want to cancel this order? This action cannot be undone.';

  @override
  String get backAction => 'Back';

  @override
  String get cancelOrderAction => 'Cancel order';

  @override
  String get customerSectionTitle => 'Customer';

  @override
  String get customerSectionSubtitle => 'Customer information';

  @override
  String get deliveryAddressTitle => 'Delivery address';

  @override
  String get deliveryAddressSubtitle => 'Delivery location details';

  @override
  String get preparationBranchTitle => 'Preparation branch';

  @override
  String get invoiceSectionTitle => 'Invoice';

  @override
  String get invoiceSectionSubtitle => 'Print, save, or share the invoice';

  @override
  String get itemsSectionTitle => 'Ordered items';

  @override
  String get totalsSectionTitle => 'Totals';

  @override
  String get totalsSectionSubtitle => 'Order amount summary';

  @override
  String get notesSectionTitle => 'Customer notes';

  @override
  String get notesSectionSubtitle => 'Special instructions';

  @override
  String get exactGps => 'Accurate GPS';

  @override
  String get openInGoogleMaps => 'Open in Google Maps';

  @override
  String get branchPhones => 'Branch phones';

  @override
  String sizePrefix(String size) {
    return 'Size: $size';
  }

  @override
  String flavorsPrefix(String flavors) {
    return 'Flavors: $flavors';
  }

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryFeeLabel => 'Delivery fee';

  @override
  String get discountLabel => 'Discount';

  @override
  String get finalTotalLabel => 'Final total';

  @override
  String get customerContact => 'Contact';

  @override
  String get customerAddress => 'Address';

  @override
  String get noAddressSaved => 'No saved address';

  @override
  String get statsSectionTitle => 'Statistics';

  @override
  String get latestOrdersSectionTitle => 'Latest orders';

  @override
  String get averageOrderLabel => 'Average order';

  @override
  String get deliveredLabel => 'Delivered';

  @override
  String get cancelledLabel => 'Cancelled';

  @override
  String get lastOrderLabel => 'Last order: ';

  @override
  String get blockCustomerAction => 'Block customer';

  @override
  String get unblockCustomerAction => 'Unblock customer';

  @override
  String get customerBlockedBanner =>
      'This customer is blocked from placing new orders.';

  @override
  String get openWhatsapp => 'WhatsApp';

  @override
  String get regularTier => 'Regular';

  @override
  String get bronzeTier => 'Bronze';

  @override
  String get silverTier => 'Silver';

  @override
  String get goldTier => 'Gold';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get reportsPageSubtitle =>
      'Detailed operational and management reports by selected branch';

  @override
  String get reportExecutiveHeaderAll => 'Executive report - all branches';

  @override
  String reportExecutiveHeaderBranch(String branchName) {
    return 'Executive report - $branchName';
  }

  @override
  String get reportExecutiveDescription =>
      'This report is designed for management and shows financial, operational, customer, and branch performance in one place.';

  @override
  String get reportMissingBranchData =>
      'Branch-linked order data is currently unavailable from the API, so branch-specific reports are limited until the backend returns branchId or branchName.';

  @override
  String get activeCustomersLabel => 'Active customers';

  @override
  String get repeatCustomersLabel => 'Repeat customers';

  @override
  String get financialReportTitle => 'Financial report';

  @override
  String get todayRevenueLabel => 'Today revenue';

  @override
  String get weekRevenueLabel => 'Week revenue';

  @override
  String get monthRevenueLabel => 'Month revenue';

  @override
  String get averageOrderValueLabel => 'Average order value';

  @override
  String get completedOrdersLabel => 'Completed orders';

  @override
  String get cancelledOrdersCountLabel => 'Cancelled orders';

  @override
  String get customersReportTitle => 'Customer report';

  @override
  String get noEnoughCustomerData => 'Not enough customer data yet';

  @override
  String get ordersCountWord => 'orders';

  @override
  String get branchesReportTitle => 'Branches report';

  @override
  String branchesOverview(int total, int open, int closed) {
    return 'Total branches: $total | Open: $open | Closed: $closed';
  }

  @override
  String get branchDistributionUnavailable =>
      'Branch order distribution cannot be generated because current orders do not contain branch data from the API.';

  @override
  String get recommendationsTitle => 'Operational recommendations';

  @override
  String get noCriticalRecommendations =>
      'No critical recommendations at the moment.';

  @override
  String recommendationCancelledOrders(int count) {
    return 'Review cancellation reasons because the current number of cancelled orders is $count.';
  }

  @override
  String get recommendationLowActiveCustomers =>
      'Active customers are relatively low; consider targeted offers for repeat customers.';

  @override
  String get recommendationBranchBalance =>
      'Review branch load distribution to ensure balanced operations, especially during peak times.';

  @override
  String recommendationAverageOrder(String amount) {
    return 'The current average order is $amount EGP; it can be used to design upsell offers.';
  }

  @override
  String get analyticsPageSubtitle =>
      'Advanced analytics dashboards for finance, customers, employees, sales, branches, and orders';

  @override
  String get financialTab => 'Financial';

  @override
  String get customersTab => 'Customers';

  @override
  String get employeesTab => 'Employees';

  @override
  String get salesTab => 'Sales';

  @override
  String get branchesTab => 'Branches';

  @override
  String get ordersTab => 'Orders';

  @override
  String get analyticsScopeAll => 'Current analysis: all branches';

  @override
  String analyticsScopeBranch(String branchName) {
    return 'Current analysis: $branchName';
  }

  @override
  String get analyticsScopeDescription =>
      'This page combines multidimensional analytics based on available orders, customers, and branches data.';

  @override
  String get analyticsMissingBranchData =>
      'Current orders do not provide branchId/branchName, so branch-based analytics will remain limited until the backend links orders to branches.';

  @override
  String get totalRevenueKpi => 'Total revenue';

  @override
  String get todayRevenueKpi => 'Today revenue';

  @override
  String get weekRevenueKpi => 'Week revenue';

  @override
  String get monthRevenueKpi => 'Month revenue';

  @override
  String get orderCountKpi => 'Orders count';

  @override
  String get totalCustomersKpi => 'Total customers';

  @override
  String get activeCustomersKpi => 'Active customers';

  @override
  String get repeatCustomersKpi => 'Repeat customers';

  @override
  String get vipCustomersKpi => 'VIP customers';

  @override
  String get topSpendingCustomersTitle => 'Top spending customers';

  @override
  String get employeesAnalyticsEstimatedTitle =>
      'Employees analytics (estimated)';

  @override
  String get employeesEstimatedSubtitle =>
      'There is no real employees API yet, so the figures below are operational estimates based on order load and number of open branches.';

  @override
  String get neededCashiers => 'Required cashiers';

  @override
  String get neededKitchen => 'Required kitchen staff';

  @override
  String get neededDelivery => 'Required delivery staff';

  @override
  String get loadPerBranch => 'Load per branch';

  @override
  String get topProductsTitle => 'Top products';

  @override
  String get openBranchesKpi => 'Open branches';

  @override
  String get closedBranchesKpi => 'Closed branches';

  @override
  String get totalBranchesKpi => 'Total branches';

  @override
  String get linkedOrdersToBranch => 'Orders linked to branch';

  @override
  String get branchLinkWarningTitle => 'Branch linking warning';

  @override
  String get branchDistributionTitle => 'Order distribution by branch';

  @override
  String get inProgressOrdersKpi => 'In progress orders';

  @override
  String get completionRateKpi => 'Completion rate';

  @override
  String get cancellationRateKpi => 'Cancellation rate';

  @override
  String get revenueChartTitle => 'Weekly revenue';

  @override
  String get revenueChartSubtitle => 'Sales performance over the last 7 days';

  @override
  String get noDataLabel => 'No data';

  @override
  String get ordersByStatusTitle => 'Orders by status';

  @override
  String get ordersByStatusSubtitle => 'Current order distribution';

  @override
  String get noOrdersLabel => 'No orders';

  @override
  String get topProductsChartTitle => 'Top selling products';

  @override
  String get topProductsChartSubtitle => 'Top 5 most ordered products';

  @override
  String get totalOrdersWord => 'Total orders';

  @override
  String get requestWord => 'orders';

  @override
  String get activityPageSubtitle =>
      'A full timeline for operations, alerts, and updates';

  @override
  String get eventsWord => 'events';

  @override
  String get clearLog => 'Clear log';

  @override
  String get overallLabel => 'Overall';

  @override
  String get warningsLabel => 'Warnings';

  @override
  String get criticalLabel => 'Critical';

  @override
  String get allFilter => 'All';

  @override
  String get systemLabel => 'System';

  @override
  String get loginLabel => 'Login';

  @override
  String get notificationsPageSubtitle =>
      'Order alerts, critical updates, and system notifications';

  @override
  String get markAllReadAction => 'Mark all as read';

  @override
  String get unreadLabel => 'Unread';

  @override
  String get todayLabel => 'Today';

  @override
  String get ordersFilter => 'Orders';

  @override
  String get branchesFilter => 'Branches';

  @override
  String get customersFilter => 'Customers';

  @override
  String get clearList => 'Clear list';

  @override
  String get alertLabel => 'Alert';

  @override
  String get activityTypeOrder => 'Order';

  @override
  String get activityTypeBranch => 'Branch';

  @override
  String get activityTypeUser => 'Customer';

  @override
  String get activityTypeSystem => 'System';

  @override
  String get activityTypeSettings => 'Settings';

  @override
  String get dashboardPageTitle => 'Dashboard';

  @override
  String get dashboardPageSubtitle => 'Today business summary';

  @override
  String get autoRefreshEnabledLabel => '🟢 Auto refresh enabled';

  @override
  String get autoRefreshingLabel => '🔄 Refreshing...';

  @override
  String everySeconds(int seconds) {
    return '(every $seconds sec)';
  }

  @override
  String lastUpdateLabel(String time) {
    return 'Last update: $time';
  }

  @override
  String get updatedSuccessfully => '✅ Updated';

  @override
  String get dashboardWelcomeSubtitle => 'Today business summary ✨';

  @override
  String get totalRevenueLabel => 'Total revenue';

  @override
  String get allPeriodsLabel => 'All periods';

  @override
  String get weeklySalesLabel => 'Weekly sales';

  @override
  String get last7DaysLabel => 'Last 7 days';

  @override
  String get averageOrderValueKpi => 'Average order value';

  @override
  String get availableProductsLabel => 'Available products';

  @override
  String get categoriesCountLabel => 'categories';

  @override
  String get recentOrdersTitle => 'Latest orders';

  @override
  String get recentOrdersSubtitle => 'Latest transactions';

  @override
  String get noOrdersForBranch => 'No orders for selected branch';

  @override
  String get productsPageTitle => 'Products';

  @override
  String get productsPageSubtitle => 'Manage store products';

  @override
  String get availableLabel => 'Available';

  @override
  String get soldOutLabel => 'Sold Out';

  @override
  String get newProduct => 'New product';

  @override
  String get productsSearchHint => 'Search for a product...';

  @override
  String get allFilterProducts => 'All';

  @override
  String get activeOnlyFilter => 'Available only';

  @override
  String get soldOutOnlyFilter => 'Sold Out only';

  @override
  String get confirmSoldOutTitle => 'Confirm Sold Out';

  @override
  String confirmSoldOutMessage(String name) {
    return 'Do you want to mark \"$name\" as Sold Out? It will appear unavailable to customers.';
  }

  @override
  String get soldOutAction => 'Sold Out';

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get noSoldOutProducts => 'No Sold Out products';

  @override
  String get addNewProduct => 'Add new product';

  @override
  String get featuredLabel => 'Featured';

  @override
  String get bestSellerLabel => 'Best seller';

  @override
  String get customizableLabel => 'Customizable';

  @override
  String get availableStatus => 'Available';

  @override
  String get soldOutStatus => 'Sold Out';

  @override
  String sizesCount(int count) {
    return '$count sizes';
  }

  @override
  String flavorsCount(int count) {
    return '$count flavors';
  }

  @override
  String get enableProductForSale => 'Enable product for sale';

  @override
  String get editProduct => 'Edit product';

  @override
  String get markAsSoldOut => 'Mark as Sold Out';

  @override
  String get productDetailsBack => 'Back';

  @override
  String get basePriceLabel => 'Base price';

  @override
  String get categoryLabel => 'Category';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get availableSizesTitle => 'Available sizes';

  @override
  String get noSizesAdded => 'No sizes added';

  @override
  String get availableFlavorsTitle => 'Available flavors';

  @override
  String get noFlavorsAdded => 'No flavors added';

  @override
  String get productWizardEditTitle => 'Edit product';

  @override
  String get productWizardAddTitle => 'Add new product';

  @override
  String get wizardStepBasic => 'Basic info';

  @override
  String get wizardStepSizes => 'Sizes';

  @override
  String get wizardStepFlavors => 'Flavors';

  @override
  String get selectCategoryError => 'Choose a category';

  @override
  String get selectProductImageError => 'Choose a product image';

  @override
  String get nameArField => 'Name in Arabic *';

  @override
  String get nameEnField => 'Name (English) *';

  @override
  String get descriptionArField => 'Description in Arabic *';

  @override
  String get descriptionEnField => 'Description (English) *';

  @override
  String get defaultSizeNameField => 'Default size name';

  @override
  String get basePriceField => 'Base price *';

  @override
  String get featuredOptionTitle => 'Featured ⭐';

  @override
  String get featuredOptionSubtitle => 'Show in featured section';

  @override
  String get bestSellerOptionTitle => 'Best seller 🔥';

  @override
  String get bestSellerOptionSubtitle => 'Show in best sellers';

  @override
  String get customizableOptionTitle => 'Customizable 🎨';

  @override
  String get customizableOptionSubtitle => 'Contains sizes/flavors';

  @override
  String get saveAndNextSizes => 'Save and continue to sizes';

  @override
  String get saveAndContinueSizesLoading => 'Saving...';

  @override
  String get pickProductImage => 'Tap to choose product image *';

  @override
  String get requiredFieldShort => 'Required';

  @override
  String get noCategoriesFirst =>
      'No categories available. Add a category first.';

  @override
  String get categoryField => 'Category *';

  @override
  String get mustChooseCategory => 'You must choose a category';

  @override
  String productSizeAddedSuccess(int count) {
    return '$count sizes added successfully';
  }

  @override
  String get productSizesTitle => 'Available product sizes';

  @override
  String get productSizesSubtitle => 'Add sizes with price and dimensions';

  @override
  String get addSize => 'Add size';

  @override
  String get existingSizes => 'Existing sizes:';

  @override
  String get noSizesAddedYet => 'No sizes added yet';

  @override
  String get skipIfNoSizes =>
      'You can skip this step if the product has no sizes';

  @override
  String get previous => 'Previous';

  @override
  String get savingSizes => 'Saving sizes...';

  @override
  String get skipToFlavors => 'Skip to flavors';

  @override
  String saveSizesAndContinue(int count) {
    return 'Save $count sizes and continue';
  }

  @override
  String get addSizeDialogTitle => 'Add size';

  @override
  String get sizeImageOptional => 'Size image (optional)';

  @override
  String get sizeNameArField => 'Size name AR *';

  @override
  String get sizeNameEnField => 'Size name EN *';

  @override
  String get sizeTokenField => 'SizeName (e.g. S/M/L)';

  @override
  String get sizeDescriptionArField => 'Description AR';

  @override
  String get sizeDescriptionEnField => 'Description EN';

  @override
  String get priceField => 'Price *';

  @override
  String get radiusField => 'Radius';

  @override
  String get heightField => 'Height';

  @override
  String get servesField => 'Serves (e.g. 4-6 people)';

  @override
  String get availableSwitch => 'Available';

  @override
  String get addSizeAction => 'Add size';

  @override
  String get availableFlavorsChooseTitle => 'Choose available flavors';

  @override
  String get availableFlavorsChooseSubtitle =>
      'Select flavors and optional extra price';

  @override
  String get noFlavorsAvailable =>
      'No flavors available. Add flavors first from the flavors page.';

  @override
  String get extraPriceField => 'Extra price';

  @override
  String get saveAndFinishFlavorsLoading => 'Saving...';

  @override
  String get finishWithoutFlavors => 'Finish without flavors';

  @override
  String saveFlavorsAndFinish(int count) {
    return 'Save $count flavors and finish';
  }

  @override
  String get categoriesPageSubtitle => 'Organize your products into categories';

  @override
  String get newCategory => 'New category';

  @override
  String get searchCategoryHint => 'Search for a category...';

  @override
  String get activeCategoriesFilter => 'Active';

  @override
  String get archivedCategoriesFilter => 'Archived';

  @override
  String get confirmArchiveTitle => 'Confirm archive';

  @override
  String categoryArchiveMessage(String name, int count) {
    return 'Are you sure you want to archive category \"$name\"?\nProducts count: $count';
  }

  @override
  String get archiveAction => 'Archive';

  @override
  String get noArchivedCategories => 'No archived categories';

  @override
  String get noCategoriesAvailable => 'No categories yet';

  @override
  String get addCategoryAction => 'Add category';

  @override
  String get archivedBadge => 'Archived';

  @override
  String productsCountLabel(int count) {
    return '$count products';
  }

  @override
  String get chooseImageRequired => 'You must choose an image';

  @override
  String get editCategoryTitle => 'Edit category';

  @override
  String get addCategoryTitle => 'Add new category';

  @override
  String get saveCategoryChanges => 'Save changes';

  @override
  String get addCategoryButton => 'Add category';

  @override
  String get changeImageTap => 'Tap to change image';

  @override
  String get pickCategoryImage => 'Tap to choose category image *';

  @override
  String get flavorsPageSubtitle => 'Manage product flavors';

  @override
  String get availableFlavorsLabel => 'available';

  @override
  String get archivedFlavorsLabel => 'archived';

  @override
  String get newFlavor => 'New flavor';

  @override
  String get searchFlavorHint => 'Search for a flavor...';

  @override
  String get availableFilter => 'Available';

  @override
  String get unavailableFilter => 'Unavailable';

  @override
  String get archivedFilter => 'Archived';

  @override
  String get confirmFlavorArchiveTitle => 'Confirm archive';

  @override
  String flavorArchiveMessage(String name) {
    return 'Are you sure you want to archive flavor \"$name\"?';
  }

  @override
  String get noArchivedFlavors => 'No archived flavors';

  @override
  String get allFlavorsAvailableLabel => 'All flavors are available 👍';

  @override
  String get noFlavorsCreated => 'No flavors yet';

  @override
  String get addFlavorAction => 'Add flavor';

  @override
  String get flavorArchivedBadge => 'Archived';

  @override
  String get flavorUnavailableBadge => 'Unavailable';

  @override
  String get flavorAvailableBadge => 'Available';

  @override
  String get editFlavorTitle => 'Edit flavor';

  @override
  String get addFlavorTitle => 'Add new flavor';

  @override
  String get availableForSelectionTitle => 'Available for selection ✓';

  @override
  String get availableForSelectionSubtitle =>
      'Customers can choose this flavor';

  @override
  String get saveFlavorChanges => 'Save changes';

  @override
  String get addFlavorButton => 'Add flavor';

  @override
  String get pickOptionalImage => 'Tap to choose an image (optional)';

  @override
  String get basicInfoSavedNextSizes => 'Save and continue to sizes';
}
