import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

/// Service to handle runtime permissions for local network access
class PermissionService {
  /// Request necessary permissions for UDP local network discovery
  /// Returns true if permissions granted, false otherwise
  Future<bool> requestLocalNetworkPermissions() async {
    // iOS handles permissions automatically via Info.plist
    // Android 13+ requires runtime permission for NEARBY_WIFI_DEVICES
    
    if (Platform.isAndroid) {
      // Check Android version - only Android 13+ (API 33+) needs runtime permission
      final status = await Permission.nearbyWifiDevices.status;
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isDenied || status.isLimited) {
        // Request permission with user dialog
        final result = await Permission.nearbyWifiDevices.request();
        return result.isGranted;
      }
      
      if (status.isPermanentlyDenied) {
        // User previously denied and selected "Don't ask again"
        // Guide them to settings
        await openAppSettings();
        return false;
      }
      
      return status.isGranted;
    }
    
    // iOS permissions handled automatically by system
    return true;
  }
  
  /// Check if local network permissions are already granted
  Future<bool> hasLocalNetworkPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.nearbyWifiDevices.status;
      return status.isGranted;
    }
    // iOS permissions can't be checked programmatically before first use
    return true;
  }
  
  /// Show permission rationale dialog before requesting
  /// Returns the user-friendly message to display
  String getPermissionRationale() {
    return 'Atomberg needs access to discover and control your smart fans '
        'on the local network. This provides faster response times and '
        'works even without internet connection.';
  }
}
