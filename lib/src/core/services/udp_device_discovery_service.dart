import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Service for discovering Atomberg devices on local network via UDP beacon packets
class UdpDeviceDiscoveryService {
  static const int beaconPort = 5625;
  static const int commandPort = 5600;
  static const int deviceTimeout = 3; // seconds
  
  RawDatagramSocket? _socket;
  Timer? _cleanupTimer;
  bool _isRunning = false;
  
  // Map of MAC address to (IP address, last seen timestamp)
  final Map<String, LocalDeviceInfo> _availableDevices = {};
  
  // Stream controller for device updates
  final _deviceUpdateController = StreamController<Map<String, LocalDeviceInfo>>.broadcast();
  
  Stream<Map<String, LocalDeviceInfo>> get deviceUpdates => _deviceUpdateController.stream;
  
  Map<String, LocalDeviceInfo> get availableDevices => Map.unmodifiable(_availableDevices);
  
  /// Start listening for device beacon packets
  Future<void> startDiscovery() async {
    if (_isRunning) {
      debugPrint('UDP discovery already running');
      return;
    }
    
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, beaconPort);
      _isRunning = true;
      
      debugPrint('UDP Device Discovery: Listening on port $beaconPort');
      
      // Listen for incoming beacon packets
      _socket!.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _socket!.receive();
          if (datagram != null) {
            _handleBeaconPacket(datagram);
          }
        }
      });
      
      // Start cleanup timer to remove inactive devices
      _cleanupTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _cleanupInactiveDevices();
      });
      
    } catch (e) {
      debugPrint('UDP Discovery Error: $e');
      _isRunning = false;
      rethrow;
    }
  }
  
  /// Handle received beacon packet
  void _handleBeaconPacket(Datagram datagram) {
    try {
      final content = utf8.decode(datagram.data, allowMalformed: true);
      
      // Beacon packet format: MAC (12 chars) + series
      if (content.length >= 12) {
        final mac = content.substring(0, 12);
        final series = content.length > 12 ? content.substring(12).trim() : '';
        final ip = datagram.address.address;
        
        // Update device info
        final deviceInfo = LocalDeviceInfo(
          mac: mac,
          ip: ip,
          series: series,
          lastSeen: DateTime.now(),
        );
        
        _availableDevices[mac] = deviceInfo;
        
        debugPrint('Beacon received - MAC: $mac, IP: $ip, Series: $series');
        
        // Notify listeners
        _deviceUpdateController.add(Map.unmodifiable(_availableDevices));
      }
    } catch (e) {
      debugPrint('Error handling beacon packet: $e');
    }
  }
  
  /// Remove devices that haven't sent beacon packets recently
  void _cleanupInactiveDevices() {
    final now = DateTime.now();
    final inactiveDevices = <String>[];
    
    _availableDevices.forEach((mac, info) {
      if (now.difference(info.lastSeen).inSeconds > deviceTimeout) {
        inactiveDevices.add(mac);
      }
    });
    
    if (inactiveDevices.isNotEmpty) {
      for (final mac in inactiveDevices) {
        debugPrint('Removing inactive device: $mac');
        _availableDevices.remove(mac);
      }
      _deviceUpdateController.add(Map.unmodifiable(_availableDevices));
    }
  }
  
  /// Send command to device via UDP
  Future<bool> sendCommand(String ip, Map<String, dynamic> command) async {
    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      
      final jsonCommand = json.encode(command);
      final data = utf8.encode(jsonCommand);
      
      final address = InternetAddress(ip);
      final sent = socket.send(data, address, commandPort);
      
      socket.close();
      
      if (sent > 0) {
        debugPrint('Sent command to $ip:$commandPort - $jsonCommand');
        return true;
      } else {
        debugPrint('Failed to send command to $ip');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending UDP command: $e');
      return false;
    }
  }
  
  /// Get device IP by MAC address (without colons)
  String? getDeviceIp(String mac) {
    // Remove colons from MAC if present
    final cleanMac = mac.replaceAll(':', '').toUpperCase();
    return _availableDevices[cleanMac]?.ip;
  }
  
  /// Check if device is available locally
  bool isDeviceAvailable(String mac) {
    final cleanMac = mac.replaceAll(':', '').toUpperCase();
    return _availableDevices.containsKey(cleanMac);
  }
  
  /// Stop discovery service
  Future<void> stopDiscovery() async {
    _isRunning = false;
    _cleanupTimer?.cancel();
    _socket?.close();
    _availableDevices.clear();
    debugPrint('UDP Device Discovery stopped');
  }
  
  void dispose() {
    stopDiscovery();
    _deviceUpdateController.close();
  }
}

/// Information about a locally discovered device
class LocalDeviceInfo {
  final String mac;
  final String ip;
  final String series;
  final DateTime lastSeen;
  
  LocalDeviceInfo({
    required this.mac,
    required this.ip,
    required this.series,
    required this.lastSeen,
  });
  
  @override
  String toString() => 'LocalDevice(mac: $mac, ip: $ip, series: $series)';
}
