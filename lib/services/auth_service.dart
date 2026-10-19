import '../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await ApiClient.post(
      ApiConstants.registerUrl,
      {'name': name, 'email': email, 'password': password},
      auth: false,
    );
    await ApiClient.saveToken(data['token'] as String);
    return UserModel.fromApiJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> login({required String email, required String password}) async {
    final data = await ApiClient.post(
      ApiConstants.loginUrl,
      {'email': email, 'password': password},
      auth: false,
    );
    await ApiClient.saveToken(data['token'] as String);
    return UserModel.fromApiJson(data['user'] as Map<String, dynamic>);
  }

  /// Used by AuthProvider.restoreSession() on app startup. Returns null if
  /// there's no saved token or it's no longer valid (expired/tampered).
  Future<UserModel?> getSessionUser() async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    try {
      final data = await ApiClient.get(ApiConstants.profileUrl);
      return UserModel.fromApiJson(data as Map<String, dynamic>);
    } catch (_) {
      await ApiClient.clearToken();
      return null;
    }
  }

  /// Matches your ForgotPasswordScreen's flow: email + new password, no
  /// separate verification step. See the backend route's comment for the
  /// security trade-off that comes with that design.
  Future<void> resetPassword({required String email, required String newPassword}) async {
    await ApiClient.post(
      ApiConstants.forgotPasswordUrl,
      {'email': email, 'newPassword': newPassword},
      auth: false,
    );
  }

  Future<void> logout() async {
    await ApiClient.clearToken();
  }

  /// Used by UserProvider.updateProfile().
  Future<void> updateProfile(UserModel user) async {
    await ApiClient.put(ApiConstants.profileUrl, {
      'name': user.name,
      'defaultCurrency': user.defaultCurrency,
      'profilePicturePath': user.profilePicturePath,
    });
  }
}
