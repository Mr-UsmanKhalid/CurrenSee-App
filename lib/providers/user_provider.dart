import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _profile;
  bool _isSaving = false;

  UserModel? get profile => _profile;
  bool get isSaving => _isSaving;

  void setProfile(UserModel user) {
    _profile = user;
    notifyListeners();
  }

  Future<UserModel> updateProfile({
    required UserModel current,
    String? name,
    String? defaultCurrency,
    String? profilePicturePath,
  }) async {
    _isSaving = true;
    notifyListeners();
    final updated = current.copyWith(
      name: name,
      defaultCurrency: defaultCurrency,
      profilePicturePath: profilePicturePath,
    );
    await _authService.updateProfile(updated);
    _profile = updated;
    _isSaving = false;
    notifyListeners();
    return updated;
  }
}
