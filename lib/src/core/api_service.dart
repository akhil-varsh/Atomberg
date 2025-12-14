import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_provider.dart';
import '../features/dashboard/domain/device_model.dart';
import '../features/auth/domain/user_credentials.dart';
import 'services/udp_discovery_provider.dart';
import 'services/udp_device_discovery_service.dart';

// Abstract interface for API services
abstract class IApiService {
  UserCredentials? get credentials;
  Future<List<Device>> getDevices();
  Future<void> sendCommand(String deviceId, Map<String, dynamic> command);
  Future<Device> getDeviceState(String deviceId);
}

// Provider for ApiService with hybrid local/cloud support
final apiServiceProvider = Provider<IApiService>((ref) {
  final authState = ref.watch(authProvider);
  final udpService = ref.watch(udpDiscoveryServiceProvider);
  return HybridApiService(authState.credentials, udpService);
});

class ApiService implements IApiService {
  @override
  final UserCredentials? credentials;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.developer.atomberg-iot.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  String? _accessToken;

  ApiService(this.credentials);

  Future<void> _ensureAccessToken() async {
    if (credentials == null) throw Exception('No credentials provided');
    if (_accessToken != null)
      return; // Basic caching, should check expiry ideally

    try {
      final response = await _dio.get(
        '/v1/get_access_token',
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': 'Bearer ${credentials!.refreshToken}',
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
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        final List<dynamic> list = response.data['message']['devices_list'];
        final devices = list.map((e) => Device.fromJson(e)).toList();
        
        // Try to fetch state for each device and merge with device info
        final devicesWithState = <Device>[];
        for (final device in devices) {
          try {
            // Fetch state data directly instead of parsing as full Device
            final stateResponse = await _dio.get(
              '/v1/get_device_state',
              queryParameters: {'device_id': device.deviceId},
              options: Options(
                headers: {
                  'x-api-key': credentials!.apiKey,
                  'Authorization': 'Bearer $_accessToken',
                },
              ),
            );
            
            if (stateResponse.statusCode == 200 && stateResponse.data['status'] == 'Success') {
              final List<dynamic> stateList = stateResponse.data['message']['device_state'];
              if (stateList.isNotEmpty) {
                final state = stateList[0];
                final mergedDevice = device.copyWith(
                  power: state['power'] ?? false,
                  speed: state['last_recorded_speed'] ?? 1,
                  isOnline: state['is_online'] ?? true,
                  brightness: state['last_recorded_brightness'] ?? 0,
                  sleep: state['sleep_mode'] ?? false,
                  timer: state['timer_hours'] ?? 0,
                  led: state['led'] ?? false,
                  lightColor: state['last_recorded_color'] ?? 'cool',
                );
                devicesWithState.add(mergedDevice);
                continue;
              }
            }
            // If state fetch didn't work, use device with default state
            devicesWithState.add(device);
          } catch (e) {
            // If state fetch fails, use device with info from list
            devicesWithState.add(device);
          }
        }
        
        return devicesWithState;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch devices: $e');
    }
  }

  Future<void> sendCommand(
    String deviceId,
    Map<String, dynamic> command,
  ) async {
    await _ensureAccessToken();

    try {
      await _dio.post(
        '/v1/send_command',
        data: {'device_id': deviceId, 'command': command},
        options: Options(
          headers: {
            'x-api-key': credentials!.apiKey,
            'Authorization': 'Bearer $_accessToken',
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
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'Success') {
        final List<dynamic> stateList = response.data['message']['device_state'];
        if (stateList.isNotEmpty) {
          return Device.fromJson(stateList[0]);
        } else {
          throw Exception('No device state found');
        }
      } else {
        throw Exception('Failed to get device state: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch device state: $e');
    }
  }
}

/// Hybrid API service that uses local UDP when available, falls back to cloud API
class HybridApiService implements IApiService {
  @override
  final UserCredentials? credentials;
  
  final ApiService _cloudApi;
  final UdpDeviceDiscoveryService _udpService;
  
  HybridApiService(this.credentials, this._udpService) 
      : _cloudApi = ApiService(credentials);
  
  @override
  Future<List<Device>> getDevices() async {
    // Always fetch from cloud API for device list
    return _cloudApi.getDevices();
  }
  
  @override
  Future<void> sendCommand(String deviceId, Map<String, dynamic> command) async {
    // Try local UDP first if device is available
    final deviceIp = _udpService.getDeviceIp(deviceId);
    
    if (deviceIp != null) {
      final success = await _udpService.sendCommand(deviceIp, command);
      if (success) {
        // Command sent locally, no need for cloud API
        return;
      }
    }
    
    // Fallback to cloud API
    return _cloudApi.sendCommand(deviceId, command);
  }
  
  @override
  Future<Device> getDeviceState(String deviceId) async {
    // Use cloud API for state (UDP doesn't provide state)
    return _cloudApi.getDeviceState(deviceId);
  }
}
