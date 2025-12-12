import '../features/dashboard/domain/device_model.dart';
import '../features/auth/domain/user_credentials.dart';
import 'api_service.dart';

class MockApiService implements ApiService {
  @override
  final UserCredentials? credentials;

  MockApiService([this.credentials]);

  @override
  Future<List<Device>> getDevices() async {
    // await Future.delayed(const Duration(milliseconds: 800)); // Simulate network - Removed for speed
    return [
      Device(
        deviceId: 'demo_1',
        name: 'Living Room Fan',
        room: 'Living Room',
        model: 'Renesa',
        series: 'Smart+',
        isOnline: true,
        speed: 3,
        power: true,
      ),
      Device(
        deviceId: 'demo_2',
        name: 'Bedroom Fan',
        room: 'Bedroom',
        model: 'Renesa',
        series: 'Smart+',
        isOnline: false,
        speed: 1,
        power: false,
      ),
      Device(
        deviceId: 'demo_3',
        name: 'Kitchen Fan',
        room: 'Kitchen',
        model: 'Studio',
        series: 'Smart+',
        isOnline: true,
        speed: 5,
        power: true,
      ),
    ];
  }

  @override
  Future<void> sendCommand(String deviceId, Map<String, dynamic> command) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real mock, we might want to update local state, but for this simple demo, 
    // we rely on the optimistic UI updates in the providers.
    if (deviceId == 'demo_2') {
       // Simulate a failure for the offline device
       throw Exception('Device is offline');
    }
  }

  @override
  Future<Device> getDeviceState(String deviceId) async {
    // Return a fake updated state. 
    return Device(
      deviceId: deviceId,
      name: _getName(deviceId), 
      room: _getRoom(deviceId),
      isOnline: true,
      power: true,
      speed: 4, // Force a speed change to verify sync
      model: 'Renesa',
      series: 'Smart+',
    );
  }
  String _getName(String id) {
    if (id == 'demo_1') return 'Living Room Fan';
    if (id == 'demo_2') return 'Bedroom Fan';
    if (id == 'demo_3') return 'Kitchen Fan';
    return 'Smart Fan';
  }

  String _getRoom(String id) {
    if (id == 'demo_1') return 'Living Room';
    if (id == 'demo_2') return 'Bedroom';
    if (id == 'demo_3') return 'Kitchen';
    return 'Home';
  }
}
