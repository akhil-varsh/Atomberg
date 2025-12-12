import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_provider.dart';
import '../features/dashboard/domain/device_model.dart';
import '../features/auth/domain/user_credentials.dart';

import 'mock_api_service.dart';

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final authState = ref.watch(authProvider);
  if (authState.isDemo) {
    return MockApiService();
  }
  return ApiService(authState.credentials);
});

class ApiService {
  final UserCredentials? credentials;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.developer.atomberg-iot.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  String? _accessToken;

  ApiService(this.credentials);

  Future<void> _ensureAccessToken() async {
    if (credentials == null) throw Exception('No credentials provided');
    if (_accessToken != null) return; // Basic caching, should check expiry ideally

    try {
      final response = await _dio.get(
        '/v1/get_access_token',
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': credentials!.refreshToken,
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        _accessToken = response.data['message']['access_token'];
      } else {
        throw Exception('Failed to get access token: ${response.data}');
      }
    } catch (e) {
      throw Exception('Auth Error: $e');
    }
  }

  Future<List<Device>> getDevices() async {
    if (credentials == null) return [];
    
    await _ensureAccessToken();

    try {
      final response = await _dio.get(
        '/v1/get_list_of_devices',
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': _accessToken,
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        final List<dynamic> list = response.data['message']['devices_list'];
        return list.map((e) => Device.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch devices: $e');
    }
  }

  Future<void> sendCommand(String deviceId, Map<String, dynamic> command) async {
    await _ensureAccessToken();

    try {
      await _dio.post(
        '/v1/send_command',
        data: {
          'device_id': deviceId,
          'payload': command,
        },
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': _accessToken,
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to send command: $e');
    }
  }
  Future<Device> getDeviceState(String deviceId) async {
    await _ensureAccessToken();

    try {
      final response = await _dio.get(
        '/v1/get_device_state',
        queryParameters: {'device_id': deviceId},
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': _accessToken,
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        return Device.fromJson(response.data['message']);
      } else {
        throw Exception('Failed to get device state: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch device state: $e');
    }
  }
}
