import 'dart:io';

class Env {
  // For Android emulator: use 10.0.2.2 to access host machine's localhost
  // For iOS simulator: localhost works fine
  // For physical devices: replace with your computer's IP address (e.g., "http://192.168.1.100:8088")
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host machine's localhost
      return "http://10.0.2.2:8088";
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return "http://localhost:8088";
    } else {
      // For other platforms (web, desktop), use localhost
      return "http://localhost:8088";
    }
  }

  // Routes used by backend
  static const String login = "/api/login/";
  static const String register = "/api/register/";
  static const String logout = "/api/logout/";
  static const String uploadPictures = "/api/upload/pictures/";
  static const String listPictures = "/api/list/pictures/";
  static const String listSuppliers = "/api/list/suppliers/";
  static const String requestLink = "/api/request/link/";
  static const String listLinks = "/api/list/links/";
  static const String requestIssue = "/api/request/issue/";
  static const String listIssues = "/api/list/issues/";
  static const String requestOrder = "/api/request/order/";
  static const String listOrders = "/api/list/orders/";
  static const String sendMessage = "/api/send/message/";
  static const String loadMessage = "/api/load/message/";
}
