import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  AuthStatus _status = AuthStatus.unknown;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final sessionUser = await _authService.getSessionUser();
      if (sessionUser != null) {
        _user = sessionUser;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({required String name, required String email, required String password}) async {
    return _runAuthAction(() async {
      _user = await _authService.register(name: name, email: email, password: password);
      await _authService.login(email: email, password: password);
      _status = AuthStatus.authenticated;
    });
  }

  Future<bool> login({required String email, required String password}) async {
    return _runAuthAction(() async {
      _user = await _authService.login(email: email, password: password);
      _status = AuthStatus.authenticated;
    });
  }

  Future<bool> forgotPassword({required String email, required String newPassword}) async {
    return _runAuthAction(() async {
      await _authService.resetPassword(email: email, newPassword: newPassword);
    });
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void updateLocalUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
