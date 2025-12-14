import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for securely storing sensitive data like API keys and tokens
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  // Keys for secure storage
  static const String _apiKeyKey = 'secure_apiKey';
  static const String _refreshTokenKey = 'secure_refreshToken';

  /// Save API key securely
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
  }

  /// Get API key
  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Save both credentials at once
  Future<void> saveCredentials(String apiKey, String refreshToken) async {
    await Future.wait([
      saveApiKey(apiKey),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Delete API key
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _apiKeyKey);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Delete all credentials
  Future<void> deleteAllCredentials() async {
    await Future.wait([
      deleteApiKey(),
      deleteRefreshToken(),
    ]);
  }

  /// Check if credentials exist
  Future<bool> hasCredentials() async {
    final apiKey = await getApiKey();
    final refreshToken = await getRefreshToken();
    return apiKey != null && refreshToken != null;
  }
}

// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
