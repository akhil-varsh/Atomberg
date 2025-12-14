import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'udp_device_discovery_service.dart';
import 'permission_service.dart';

/// Provider for permission service
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

/// Provider for UDP device discovery service
final udpDiscoveryServiceProvider = Provider<UdpDeviceDiscoveryService>((ref) {
  final service = UdpDeviceDiscoveryService();
  final permissionService = ref.read(permissionServiceProvider);
  
  // Request permissions and start discovery
  permissionService.requestLocalNetworkPermissions().then((granted) {
    if (granted) {
      service.startDiscovery().catchError((error) {
        // Handle error silently - local discovery is optional
      });
    }
  });
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider for available local devices
final localDevicesProvider = StreamProvider<Map<String, LocalDeviceInfo>>((ref) {
  final service = ref.watch(udpDiscoveryServiceProvider);
  return service.deviceUpdates;
});
