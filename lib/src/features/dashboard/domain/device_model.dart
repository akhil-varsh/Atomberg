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
  final String lightColor; // "warm", "cool", "daylight"

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
    this.lightColor = 'cool',
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? json['device_name'] ?? 'Unknown Fan';
    final room = json['room'] ?? json['room_name'] ?? 'Unknown Room';
    
    return Device(
      deviceId: json['device_id'] ?? '',
      name: name,
      room: room,
      model: json['model'] ?? json['device_model'] ?? '',
      series: json['series'] ?? '',
      // State fields - map API response names to our model
      isOnline: json['is_online'] ?? true,
      power: json['power'] ?? false,
      speed: json['last_recorded_speed'] ?? json['speed'] ?? 1,
      brightness: json['last_recorded_brightness'] ?? json['brightness'] ?? 0,
      sleep: json['sleep_mode'] ?? json['sleep'] ?? false,
      timer: json['timer_hours'] ?? json['timer'] ?? 0,
      led: json['led'] ?? false,
      lightColor: json['last_recorded_color'] ?? json['light_color'] ?? 'cool',
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
    String? lightColor,
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
      lightColor: lightColor ?? this.lightColor,
    );
  }
}
