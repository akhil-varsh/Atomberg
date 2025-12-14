import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_service.dart';
import '../../auth/data/auth_provider.dart';
import '../domain/device_model.dart';

final devicesProvider = FutureProvider.autoDispose<List<Device>>((ref) async {
  // Check if user is authenticated before fetching devices
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.credentials == null) {
    throw Exception('Not authenticated');
  }
  
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getDevices();
});
