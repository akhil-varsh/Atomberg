import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_service.dart';
import '../domain/device_model.dart';

final devicesProvider = FutureProvider.autoDispose<List<Device>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getDevices();
});
