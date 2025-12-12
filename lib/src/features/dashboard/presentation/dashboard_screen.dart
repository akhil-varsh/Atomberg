import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../config/theme_provider.dart';
import '../data/device_provider.dart';
import '../domain/device_model.dart';
import '../../device_control/presentation/device_control_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () {
               ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
               Theme.of(context).scaffoldBackgroundColor,
               Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: devicesAsync.when(
          data: (devices) {
            if (devices.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Icon(Icons.wind_power, size: 64, color: Colors.grey),
                     const SizedBox(height: 16),
                     Text('No devices found.', style: Theme.of(context).textTheme.titleLarge),
                     const SizedBox(height: 8),
                     ElevatedButton(
                       onPressed: () => ref.refresh(devicesProvider),
                       child: const Text('Refresh'),
                     )
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(devicesProvider),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return _DeviceCard(device: device)
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideY(begin: 0.1, end: 0);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error: $err', textAlign: TextAlign.center),
                 const SizedBox(height: 16),
                 ElevatedButton(
                   onPressed: () => ref.refresh(devicesProvider),
                   child: const Text('Retry'),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final Device device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
               builder: (_) => DeviceControlScreen(device: device),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wind_power, 
                    color: device.isOnline ? AppColors.atombergOrange : Colors.grey,
                    size: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: device.isOnline ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      device.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 10, 
                        color: device.isOnline ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
              Text(
                device.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                device.room,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
