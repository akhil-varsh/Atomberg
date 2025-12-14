import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atomberg/src/core/api_service.dart';
import 'package:atomberg/src/core/services/secure_storage_service.dart';
import 'package:atomberg/src/features/dashboard/domain/device_model.dart';
import 'mock_secure_storage.dart';

// Generate mocks with: dart run build_runner build
@GenerateMocks([ApiService])
class MockApiServiceGenerated {}

// Mock Secure Storage instance for tests
final mockSecureStorage = MockSecureStorage();

// Mock Device Helper
Device createMockDevice({
  String deviceId = 'test_device',
  String name = 'Test Fan',
  String room = 'Test Room',
  bool isOnline = true,
  bool power = false,
  int speed = 3,
}) {
  return Device(
    deviceId: deviceId,
    name: name,
    room: room,
    model: 'Test Model',
    series: 'Test Series',
    isOnline: isOnline,
    power: power,
    speed: speed,
  );
}

// Mock SharedPreferences (for non-sensitive data like onboarding and theme)
Future<void> setupMockSharedPreferences({
  bool hasSeenOnboarding = false,
  int? themeMode,
}) async {
  SharedPreferences.setMockInitialValues({
    'hasSeenOnboarding': hasSeenOnboarding,
    if (themeMode != null) 'themeMode': themeMode,
  });
}

// Setup Mock Secure Storage (for sensitive data like credentials)
Future<void> setupMockSecureStorage({
  String? apiKey,
  String? refreshToken,
}) async {
  mockSecureStorage.clear();
  if (apiKey != null) {
    await mockSecureStorage.write(key: 'secure_apiKey', value: apiKey);
  }
  if (refreshToken != null) {
    await mockSecureStorage.write(key: 'secure_refreshToken', value: refreshToken);
  }
}

// Provider Container Helper with Secure Storage override
ProviderContainer createContainer({List<dynamic> overrides = const []}) {
  final allOverrides = [
    secureStorageServiceProvider.overrideWithValue(
      SecureStorageService(storage: mockSecureStorage),
    ),
    ...overrides,
  ];
  return ProviderContainer(overrides: allOverrides.cast());
}
