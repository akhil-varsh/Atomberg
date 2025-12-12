import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants.dart';
import '../../dashboard/domain/device_model.dart';
import '../data/device_control_provider.dart';
import 'components/speed_dial.dart';

class DeviceControlScreen extends ConsumerStatefulWidget {
  final Device device;

  const DeviceControlScreen({super.key, required this.device});

  @override
  ConsumerState<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends ConsumerState<DeviceControlScreen> {
  
  @override
  void initState() {
    super.initState();
    // Refresh state when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceControlProvider(widget.device).notifier).refreshState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the specific device controller
    final currentDevice = ref.watch(deviceControlProvider(widget.device));
    final notifier = ref.read(deviceControlProvider(widget.device).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(currentDevice.name),
            Text(currentDevice.room, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refreshState(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Indicator
            _StatusBadge(isOnline: currentDevice.isOnline),
            
            const SizedBox(height: 40),
            
            // Speed Dial
            SizedBox(
              height: 300,
              width: 300,
              child: SpeedRing(
                currentSpeed: currentDevice.speed,
                isPowerOn: currentDevice.power,
                onSpeedChanged: (val) => notifier.setSpeed(val),
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 40),
            
            // Primary Power Button
            FloatingActionButton.large(
              onPressed: () => notifier.setPower(!currentDevice.power),
              backgroundColor: currentDevice.power ? AppColors.atombergOrange : Colors.grey[300],
              foregroundColor: currentDevice.power ? Colors.white : Colors.grey[600],
              child: const Icon(Icons.power_settings_new, size: 48),
            ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
            
            const SizedBox(height: 16),
            Text(currentDevice.power ? "Status: ON" : "Status: OFF", style: const TextStyle(fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 40),
            
            // Secondary Controls Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _ControlTile(
                  icon: Icons.lightbulb,
                  label: "Light",
                  isActive: currentDevice.led,
                  onTap: () => notifier.setLed(!currentDevice.led),
                ),
                _ControlTile(
                  icon: Icons.nightlight_round,
                  label: "Sleep",
                  isActive: currentDevice.sleep,
                  onTap: () => notifier.setSleep(!currentDevice.sleep),
                ),
                 _ControlTile(
                  icon: Icons.timer,
                  label: currentDevice.timer > 0 ? "${currentDevice.timer}h" : "Timer",
                  isActive: currentDevice.timer > 0,
                  onTap: () {
                    // Cyclic timer for demo: 0 -> 1 -> 2 -> 4 -> 0
                    int nextTimer = 0;
                    if (currentDevice.timer == 0) {
                      nextTimer = 1;
                    } else if (currentDevice.timer == 1) {
                      nextTimer = 2;
                    } else if (currentDevice.timer == 2) {
                      nextTimer = 4;
                    } else {
                      nextTimer = 0;
                    }
                    
                    notifier.setTimer(nextTimer);
                  },
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOnline;
  const _StatusBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isOnline ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: isOnline ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Text(
            isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isActive ? AppColors.softOrange.withValues(alpha: 0.3) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isActive ? const BorderSide(color: AppColors.atombergOrange, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? AppColors.atombergOrange : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.textPrimaryLight : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
