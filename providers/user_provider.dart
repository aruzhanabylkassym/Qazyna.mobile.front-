import 'package:flutter/foundation.dart';
import '../models/user_credentials.dart';

class UserProvider extends ChangeNotifier {
  UserCredentials? _currentUser;
  String? _userLogin;

  UserCredentials? get currentUser => _currentUser;
  String? get userLogin => _userLogin;
  bool get isConsumer => _currentUser?.accType == 'consumer';
  bool get isSupplier => _currentUser?.accType == 'supplier';

  void setUser(UserCredentials user) {
    _currentUser = user;
    _userLogin = user.userLogin;
    notifyListeners();
  }

  void setUserLogin(String login) {
    _userLogin = login;
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    _userLogin = null;
    notifyListeners();
  }
}

