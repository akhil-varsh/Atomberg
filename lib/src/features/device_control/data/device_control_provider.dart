import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/domain/device_model.dart';
import '../../../core/api_service.dart';

part 'device_control_provider.g.dart';

@riverpod
class DeviceControlNotifier extends _$DeviceControlNotifier {
  
  @override
  Device build(Device device) {
    return device; // Initial state is the device passed in
  }

  Future<void> setPower(bool on) async {
    // Optimistic Update
    state = state.copyWith(power: on);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {'power': on});
    } catch (e) {
      // Revert on failure
      state = state.copyWith(power: !on);
    }
  }

  Future<void> setSpeed(int speed) async {
    final oldSpeed = state.speed;
    state = state.copyWith(speed: speed);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {'speed': speed});
    } catch (e) {
      state = state.copyWith(speed: oldSpeed);
    }
  }

  Future<void> setSleep(bool sleep) async {
    state = state.copyWith(sleep: sleep);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {'sleep': sleep});
    } catch (e) {
      state = state.copyWith(sleep: !sleep);
    }
  }

  Future<void> setLed(bool led) async {
    state = state.copyWith(led: led);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {'led': led});
    } catch (e) {
      state = state.copyWith(led: !led);
    }
  }

   Future<void> setTimer(int hours) async {
    state = state.copyWith(timer: hours);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {'timer': hours});
    } catch (e) {
      // Revert logic is complex for timer, maybe fetch fresh state
    }
  }

  Future<void> refreshState() async {
    try {
      final updatedDevice = await ref.read(apiServiceProvider).getDeviceState(state.deviceId);
      state = updatedDevice;
    } catch (e) {
      // Handle error or just ignore
    }
  }
}
