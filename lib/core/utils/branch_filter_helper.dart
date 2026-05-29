import '../../features/orders/domain/entities/order_entity.dart';

class BranchFilterHelper {
  static String _normalize(String? value) => value?.trim().toLowerCase() ?? '';

  static bool matchesOrder(
    OrderEntity order, {
    required String? selectedBranchId,
    required String selectedBranchName,
  }) {
    final normalizedSelectedId = _normalize(selectedBranchId);
    if (normalizedSelectedId.isEmpty) return true;

    final orderBranchId = _normalize(order.branchId);
    if (orderBranchId == normalizedSelectedId) return true;

    final normalizedSelectedName = _normalize(selectedBranchName);
    final orderBranchName = _normalize(order.branchName);

    if (normalizedSelectedName.isNotEmpty && orderBranchName.isNotEmpty) {
      if (orderBranchName == normalizedSelectedName) return true;
      if (orderBranchName.contains(normalizedSelectedName)) return true;
      if (normalizedSelectedName.contains(orderBranchName)) return true;
    }

    return false;
  }

  static bool hasBranchData(OrderEntity order) {
    return _normalize(order.branchId).isNotEmpty ||
        _normalize(order.branchName).isNotEmpty;
  }

  static bool listHasAnyBranchData(List<OrderEntity> orders) {
    return orders.any(hasBranchData);
  }
}
