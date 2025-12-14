import '../features/dashboard/domain/device_model.dart';
import '../features/auth/domain/user_credentials.dart';
import 'api_service.dart';

class MockApiService implements ApiService {
  @override
  final UserCredentials? credentials;

  // Store device states in memory - Full featured demo devices
  static final Map<String, Device> _deviceStates = {
    'demo_1': Device(
      deviceId: 'demo_1',
      name: 'Living Room Fan',
      room: 'Living Room',
      model: 'Renesa',
      series: 'Smart+',
      isOnline: true,
      speed: 3,
      power: true,
      led: false,
      brightness: 50,
      lightColor: 'cool',
      sleep: false,
      timer: 0,
    ),
    'demo_2': Device(
      deviceId: 'demo_2',
      name: 'Bedroom Fan',
      room: 'Bedroom',
      model: 'Aris',
      series: 'Smart+',
      isOnline: true,
      speed: 2,
      power: false,
      led: false,
      brightness: 30,
      lightColor: 'warm',
      sleep: true,
      timer: 0,
    ),
    'demo_3': Device(
      deviceId: 'demo_3',
      name: 'Kitchen Fan',
      room: 'Kitchen',
      model: 'Renesa',
      series: 'Smart+',
      isOnline: true,
      speed: 5,
      power: true,
      led: true,
      brightness: 80,
      lightColor: 'daylight',
      sleep: false,
      timer: 2,
    ),
  };

  MockApiService([this.credentials]);

  @override
  Future<List<Device>> getDevices() async {
    // await Future.delayed(const Duration(milliseconds: 800)); // Simulate network - Removed for speed
    return _deviceStates.values.toList();
  }

  @override
  Future<void> sendCommand(
    String deviceId,
    Map<String, dynamic> command,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final device = _deviceStates[deviceId];
    if (device == null) return;
    
    // Process each command type
    Device updatedDevice = device;
    
    // Online status control (demo mode only)
    if (command.containsKey('isOnline')) {
      updatedDevice = updatedDevice.copyWith(isOnline: command['isOnline']);
      _deviceStates[deviceId] = updatedDevice;
      return; // Return early for online/offline toggle
    }
    
    // If device is offline, simulate failure for other commands
    if (!device.isOnline) {
      throw Exception('Device is offline');
    }
    
    // Power control
    if (command.containsKey('power')) {
      updatedDevice = updatedDevice.copyWith(power: command['power']);
    }
    
    // Speed control
    if (command.containsKey('speed')) {
      final speed = (command['speed'] as int).clamp(1, 6);
      updatedDevice = updatedDevice.copyWith(speed: speed);
    }
    
    // Sleep mode
    if (command.containsKey('sleep')) {
      updatedDevice = updatedDevice.copyWith(sleep: command['sleep']);
    }
    
    // Timer control
    if (command.containsKey('timer')) {
      final timer = (command['timer'] as int).clamp(0, 12);
      updatedDevice = updatedDevice.copyWith(timer: timer);
    }
    
    // LED control
    if (command.containsKey('led')) {
      updatedDevice = updatedDevice.copyWith(led: command['led']);
    }
    
    // Brightness control
    if (command.containsKey('brightness')) {
      final brightness = (command['brightness'] as int).clamp(10, 100);
      updatedDevice = updatedDevice.copyWith(brightness: brightness);
    }
    
    // Light mode control
    if (command.containsKey('light_mode')) {
      final lightColor = command['light_mode'] as String;
      if (['warm', 'cool', 'daylight'].contains(lightColor)) {
        updatedDevice = updatedDevice.copyWith(lightColor: lightColor);
      }
    }
    
    // Update the stored state
    _deviceStates[deviceId] = updatedDevice;
  }

  @override
  Future<Device> getDeviceState(String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Return the current state from memory
    final device = _deviceStates[deviceId];
    if (device != null) {
      return device;
    }
    
    // Default fallback for unknown devices
    return Device(
      deviceId: deviceId,
      name: 'Demo Fan',
      room: 'Home',
      isOnline: true,
      power: false,
      speed: 1,
      model: 'Renesa',
      series: 'Smart+',
      led: false,
      brightness: 50,
      lightColor: 'cool',
      sleep: false,
      timer: 0,
    );
  }
}
