import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user_credentials.dart';

part 'auth_provider.g.dart';

// State to hold Auth Status
class AuthState {
  final UserCredentials? credentials;
  final bool isAuthenticated;
  final bool isLoading;
  final bool isDemo;

  AuthState({
    this.credentials,
    this.isAuthenticated = false,
    this.isLoading = true,
    this.isDemo = false,
  });

  AuthState copyWith({
    UserCredentials? credentials,
    bool? isAuthenticated,
    bool? isLoading,
    bool? isDemo,
  }) {
    return AuthState(
      credentials: credentials ?? this.credentials,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isDemo: isDemo ?? this.isDemo,
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
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('apiKey');
    final refreshToken = prefs.getString('refreshToken');

    if (apiKey != null && refreshToken != null) {
      state = AuthState(
        credentials: UserCredentials(apiKey: apiKey, refreshToken: refreshToken),
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = AuthState(isAuthenticated: false, isLoading: false);
    }
  }

  Future<void> login(String apiKey, String refreshToken) async {
    state = state.copyWith(isLoading: true);
    // Simulate delay or validate specific format if needed
    await Future.delayed(const Duration(milliseconds: 500)); 

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', apiKey);
    await prefs.setString('refreshToken', refreshToken);

    state = AuthState(
      credentials: UserCredentials(apiKey: apiKey, refreshToken: refreshToken),
      isAuthenticated: true,
      isLoading: false,
      isDemo: false,
    );
  }

  void loginAsDemo() {
    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      isDemo: true,
    );
  }

  Future<void> logout() async {
    if (!state.isDemo) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('apiKey');
      await prefs.remove('refreshToken');
    }
    state = AuthState(isAuthenticated: false, isLoading: false, isDemo: false);
  }
}
