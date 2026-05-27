class ApiConstants {
  static const String baseUrl = 'https://bar-backend.runasp.net/';

  // Accounts
  static const String registerAdmin = '/api/Accounts/RegisterAdmin';
  static const String adminLogin = '/api/Accounts/AdminLogin';
  static const String getAllUsers = '/api/Accounts/GetAllUser';
  static const String getUserById = '/api/Accounts/GetUserById';
  static const String updateUserArchiveStatus =
      '/api/Accounts/UpdateUserArchiveStatus';

  // Carts
  static const String getCart = '/api/Carts/GetCart';
  static const String addToCart = '/api/Carts/AddToCart';
  static const String updateCartItemQuantity =
      '/api/Carts/UpdateCartItemQuantity';
  static const String removeFromCart = '/api/Carts/RemoveFromCart';
  static const String clearCart = '/api/Carts/ClearCart';

  // Categories
  static const String getAllCategories = '/api/Categories/GetAllCategories';
  static const String getCategoryById = '/api/Categories/GetCategoryById';
  static const String addCategory = '/api/Categories/AddCategory';
  static const String updateCategory = '/api/Categories/UpdateCategory';
  static const String archiveCategory = '/api/Categories/ArchiveCategory';
  static const String unArchiveCategory = '/api/Categories/UnArchiveCategory';

  // Flavors
  static const String getAllFlavors = '/api/Flavors/GetAllFlavors';
  static const String getFlavorById = '/api/Flavors/GetFlavorById';
  static const String addFlavor = '/api/Flavors/AddFlavor';
  static const String updateFlavor = '/api/Flavors/UpdateFlavor';
  static const String archiveFlavor = '/api/Flavors/ArchiveFlavor';
  static const String unArchiveFlavor = '/api/Flavors/UnArchiveFlavor';

  // Orders
  static const String getMyOrders = '/api/Orders/GetMyOrders';
  static const String getAllOrders = '/api/Orders/GetAllOrders';
  static const String getOrderById = '/api/Orders/GetOrderById';
  static const String placeOrder = '/api/Orders/PlaceOrder';
  static const String cancelOrder = '/api/Orders/CancelOrder';
  static const String updateOrderStatus = '/api/Orders/UpdateOrderStatus';

  // Products
  static const String getAllProducts = '/api/Products/GetAllProducts';
  static const String getProductById = '/api/Products/GetProductById';
  static const String addProduct = '/api/Products/AddProduct';
  static const String updateProduct = '/api/Products/UpdateProduct';
  static const String archiveProduct = '/api/Products/ArchiveProduct';
  static const String unArchiveProduct = '/api/Products/UnArchiveProduct';
  static const String assignFlavorsToProduct =
      '/api/Products/AssignFlavorsToProduct';

  // ProductSizes
  static const String getProductSizes = '/api/ProductSizes/GetProductSizes';
  static const String addProductSize = '/api/ProductSizes/AddProductSize';
  static const String updateProductSize =
      '/api/ProductSizes/UpdateProductSize';
  static const String archiveProductSize =
      '/api/ProductSizes/ArchiveProductSize';
}
