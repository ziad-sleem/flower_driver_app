class AuthEndPoint {
  static const baseUrl = "https://flower.elevateegy.com/api/v1/";
  static const signIn = "drivers/signin";
  static const applyNow = "drivers/apply";
  static const vehicles = "vehicles/";
}

class ProfileEndPoint {
  static const baseUrl = "https://flower.elevateegy.com/api/v1/";
  static const profileData = "drivers/profile-data";
  static const vehicleId = "vehicle/";
  static const vehicles = "vehicles";
  static const changePassword = "drivers/change-password";
}

class EditProfileEndPoint {
  static const editProfile = 'drivers/editProfile';
  static const uploadPhoto = 'drivers/upload-photo';
}

class EditVehicleInfoEndPoint {
  static const vehicles = 'vehicles';
  static const updateVehicleInfo = 'vehicles/update';
}

class ProductsSectionsEndPoint {}

class CartEndPoints {}

class CheckoutEndPoints {}

class OrdersEndPoints {
  static const getPendingOrder = "orders/pending-orders";
  static const String updateOrderState = "orders/state";
  static const getDriverOrders = "orders/driver-orders";
}

class NotificationsEndPoints {}

class AddressEndPoints {}
