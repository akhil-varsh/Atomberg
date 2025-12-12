class Device {
  final String deviceId;
  final String name;
  final String room;
  final String model;
  final String series;
  final bool isOnline; // Inferred from state or metadata if available
  // State properties
  final bool power;
  final int speed;
  final int brightness;
  final bool sleep;
  final int timer;
  final bool led;

  Device({
    required this.deviceId,
    required this.name,
    required this.room,
    required this.model,
    required this.series,
    this.isOnline = true,
    this.power = false,
    this.speed = 1,
    this.brightness = 0,
    this.sleep = false,
    this.timer = 0,
    this.led = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['device_id'] ?? '',
      name: json['name'] ?? 'Unknown Fan',
      room: json['room'] ?? 'Unknown Room',
      model: json['model'] ?? '',
      series: json['series'] ?? '',
    );
  }

  Device copyWith({
    bool? power,
    int? speed,
    bool? isOnline,
    int? brightness,
    bool? sleep,
    int? timer,
    bool? led,
  }) {
    return Device(
      deviceId: deviceId,
      name: name,
      room: room,
      model: model,
      series: series,
      isOnline: isOnline ?? this.isOnline,
      power: power ?? this.power,
      speed: speed ?? this.speed,
      brightness: brightness ?? this.brightness,
      sleep: sleep ?? this.sleep,
      timer: timer ?? this.timer,
      led: led ?? this.led,
    );
  }
}
