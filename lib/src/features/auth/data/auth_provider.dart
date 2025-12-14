import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_credentials.dart';
import '../../../core/services/secure_storage_service.dart';

part 'auth_provider.g.dart';

// State to hold Auth Status
class AuthState {
  final UserCredentials? credentials;
  final bool isAuthenticated;
  final bool isLoading;

  AuthState({
    this.credentials,
    this.isAuthenticated = false,
    this.isLoading = true,
  });

  AuthState copyWith({
    UserCredentials? credentials,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      credentials: credentials ?? this.credentials,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Controller
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _init();
    return AuthState();
  }

  Future<void> _init() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    final apiKey = await secureStorage.getApiKey();
    final refreshToken = await secureStorage.getRefreshToken();

    // Check if provider is still mounted before updating state
    if (!ref.mounted) return;

    if (apiKey != null && refreshToken != null) {
      state = AuthState(
        credentials: UserCredentials(
          apiKey: apiKey,
          refreshToken: refreshToken,
        ),
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = AuthState(isAuthenticated: false, isLoading: false);
    }
  }

  Future<void> login(String apiKey, String refreshToken, {bool skipValidation = false}) async {
    state = state.copyWith(isLoading: true);
    
    // Validate credentials by making a test API call (unless skipped for testing)
    if (!skipValidation) {
      await _validateCredentials(apiKey, refreshToken);
    }

    final secureStorage = ref.read(secureStorageServiceProvider);
    await secureStorage.saveCredentials(apiKey, refreshToken);

    state = AuthState(
      credentials: UserCredentials(apiKey: apiKey, refreshToken: refreshToken),
      isAuthenticated: true,
      isLoading: false,
    );
  }

  Future<void> _validateCredentials(String apiKey, String refreshToken) async {

    // Test credentials by attempting to get access token
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.developer.atomberg-iot.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    try {
      final response = await dio.get(
        '/v1/get_access_token',
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        // Credentials are valid
        return;
      } else {
        throw Exception('Invalid credentials');
      }
    } on DioException catch (e) {
      // Handle different error types with user-friendly messages
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception('Invalid API Key or Refresh Token');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Unable to connect. Check your internet connection.');
      } else {
        throw Exception('Authentication failed. Please check your credentials.');
      }
    } catch (e) {
      throw Exception('Authentication failed. Please check your credentials.');
    }
  }

  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    await secureStorage.deleteAllCredentials();
    state = AuthState(isAuthenticated: false, isLoading: false);
  }
}
