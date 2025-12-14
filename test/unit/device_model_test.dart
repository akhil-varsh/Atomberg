import 'package:flutter_test/flutter_test.dart';
import 'package:atomberg/src/features/dashboard/domain/device_model.dart';

void main() {
  group('Device Model Tests', () {
    test('fromJson creates device with valid data', () {
      final json = {
        'device_id': 'test_123',
        'name': 'Living Room Fan',
        'room': 'Living Room',
        'model': 'Renesa',
        'series': 'Smart+',
      };

      final device = Device.fromJson(json);

      expect(device.deviceId, 'test_123');
      expect(device.name, 'Living Room Fan');
      expect(device.room, 'Living Room');
      expect(device.model, 'Renesa');
      expect(device.series, 'Smart+');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final device = Device.fromJson(json);

      expect(device.deviceId, '');
      expect(device.name, 'Unknown Fan');
      expect(device.room, 'Unknown Room');
      expect(device.model, '');
      expect(device.series, '');
    });

    test('copyWith updates specific fields', () {
      final device = Device(
        deviceId: 'test',
        name: 'Fan',
        room: 'Room',
        model: 'Model',
        series: 'Series',
        power: false,
        speed: 1,
        isOnline: true,
      );

      final updated = device.copyWith(power: true, speed: 5);

      expect(updated.power, true);
      expect(updated.speed, 5);
      expect(updated.deviceId, 'test');
      expect(updated.name, 'Fan');
    });

    test('copyWith with no parameters returns same values', () {
      final device = Device(
        deviceId: 'test',
        name: 'Fan',
        room: 'Room',
        model: 'Model',
        series: 'Series',
        power: true,
        speed: 3,
      );

      final updated = device.copyWith();

      expect(updated.power, device.power);
      expect(updated.speed, device.speed);
      expect(updated.deviceId, device.deviceId);
    });

    test('Device has correct default values', () {
      final device = Device(
        deviceId: 'test',
        name: 'Fan',
        room: 'Room',
        model: 'Model',
        series: 'Series',
      );

      expect(device.isOnline, true);
      expect(device.power, false);
      expect(device.speed, 1);
      expect(device.brightness, 0);
      expect(device.sleep, false);
      expect(device.timer, 0);
      expect(device.led, false);
    });
  });
}
