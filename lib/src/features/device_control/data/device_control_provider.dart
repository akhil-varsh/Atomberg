import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/domain/device_model.dart';
import '../../dashboard/data/device_provider.dart';
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
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'power': on,
      });
    } catch (e) {
      // Revert on failure
      state = state.copyWith(power: !on);
    }
  }

  Future<void> setSpeed(int speed) async {
    final oldSpeed = state.speed;
    state = state.copyWith(speed: speed);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'speed': speed,
      });
    } catch (e) {
      state = state.copyWith(speed: oldSpeed);
    }
  }

  Future<void> setSleep(bool sleep) async {
    state = state.copyWith(sleep: sleep);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'sleep': sleep,
      });
    } catch (e) {
      state = state.copyWith(sleep: !sleep);
    }
  }

  Future<void> setLed(bool led) async {
    state = state.copyWith(led: led);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'led': led,
      });
    } catch (e) {
      state = state.copyWith(led: !led);
    }
  }

  Future<void> setTimer(int hours) async {
    state = state.copyWith(timer: hours);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'timer': hours,
      });
    } catch (e) {
      // Revert logic is complex for timer, maybe fetch fresh state
    }
  }

  Future<void> setBrightness(int brightness) async {
    final oldBrightness = state.brightness;
    state = state.copyWith(brightness: brightness);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'brightness': brightness,
      });
    } catch (e) {
      state = state.copyWith(brightness: oldBrightness);
    }
  }

  Future<void> setLightMode(String mode) async {
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'light_mode': mode,
      });
      // Refresh state to get updated color
      await refreshState();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refreshState() async {
    try {
      final updatedDevice = await ref
          .read(apiServiceProvider)
          .getDeviceState(state.deviceId);
      // Merge state while preserving original device info (name, room, etc.)
      state = state.copyWith(
        power: updatedDevice.power,
        speed: updatedDevice.speed,
        isOnline: updatedDevice.isOnline,
        brightness: updatedDevice.brightness,
        sleep: updatedDevice.sleep,
        timer: updatedDevice.timer,
        led: updatedDevice.led,
        lightColor: updatedDevice.lightColor,
      );
    } catch (e) {
      // Handle error or just ignore
    }
  }

  Future<void> toggleOnlineStatus() async {
    // Toggle online/offline status in demo mode
    final newStatus = !state.isOnline;
    state = state.copyWith(isOnline: newStatus);
    try {
      await ref.read(apiServiceProvider).sendCommand(state.deviceId, {
        'isOnline': newStatus,
      });
      // Refresh state to confirm the change
      await refreshState();
      // Invalidate devices provider to refresh dashboard
      ref.invalidate(devicesProvider);
    } catch (e) {
      // Revert on failure
      state = state.copyWith(isOnline: !newStatus);
    }
  }
}
