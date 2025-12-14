import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants.dart';
import '../../dashboard/domain/device_model.dart';
import '../../auth/data/auth_provider.dart';
import '../../../core/services/udp_discovery_provider.dart';
import '../data/device_control_provider.dart';
import 'components/speed_dial.dart';

class DeviceControlScreen extends ConsumerStatefulWidget {
  final Device device;

  const DeviceControlScreen({super.key, required this.device});

  @override
  ConsumerState<DeviceControlScreen> createState() =>
      _DeviceControlScreenState();
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
    
    // Watch local devices to show local control indicator
    final localDevicesAsync = ref.watch(localDevicesProvider);
    final isLocallyAvailable = localDevicesAsync.when(
      data: (devices) => devices.containsKey(currentDevice.deviceId.replaceAll(':', '').toUpperCase()),
      loading: () => false,
      error: (_, __) => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(currentDevice.name),
            Text(
              currentDevice.room,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          // Local control indicator
          if (isLocallyAvailable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                avatar: const Icon(Icons.wifi, size: 16, color: Colors.green),
                label: const Text('Local', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
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
            _StatusBadge(isOnline: currentDevice.isOnline, isLocal: isLocallyAvailable),

            const SizedBox(height: 40),

            // Speed Dial
            Opacity(
              opacity: currentDevice.isOnline ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !currentDevice.isOnline,
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: SpeedRing(
                    currentSpeed: currentDevice.speed,
                    isPowerOn: currentDevice.power,
                    isOnline: currentDevice.isOnline,
                    onSpeedChanged: (val) => notifier.setSpeed(val),
                  ),
                ),
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 40),

            // Primary Power Button
            FloatingActionButton.large(
              onPressed: currentDevice.isOnline ? () => notifier.setPower(!currentDevice.power) : null,
              backgroundColor:
                  !currentDevice.isOnline
                      ? Colors.grey[400]
                      : currentDevice.power
                          ? AppColors.atombergOrange
                          : Colors.grey[300],
              foregroundColor:
                  !currentDevice.isOnline
                      ? Colors.grey[600]
                      : currentDevice.power
                          ? Colors.white
                          : Colors.grey[600],
              child: const Icon(Icons.power_settings_new, size: 48),
            ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),

            const SizedBox(height: 16),
            Text(
              currentDevice.power ? "Status: ON" : "Status: OFF",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Secondary Controls Grid
            Opacity(
              opacity: currentDevice.isOnline ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !currentDevice.isOnline,
                child: GridView.count(
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
                      label:
                          currentDevice.timer > 0
                              ? "${currentDevice.timer}h"
                              : "Timer",
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
            ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Brightness Control (only show if LED is on and device is online)
            if (currentDevice.led && currentDevice.isOnline)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Brightness',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${currentDevice.brightness}%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.atombergOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: currentDevice.brightness.toDouble().clamp(10, 100),
                    min: 10,
                    max: 100,
                    divisions: 90,
                    activeColor: AppColors.atombergOrange,
                    onChanged: (value) {
                      notifier.setBrightness(value.toInt());
                    },
                  ),
                  const SizedBox(height: 16),

                  // Color Mode Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ColorModeButton(
                        label: 'Warm',
                        icon: Icons.wb_incandescent,
                        color: Colors.orange,
                        isSelected: currentDevice.lightColor == 'warm',
                        onTap: () => notifier.setLightMode('warm'),
                      ),
                      _ColorModeButton(
                        label: 'Cool',
                        icon: Icons.ac_unit,
                        color: Colors.blue,
                        isSelected: currentDevice.lightColor == 'cool',
                        onTap: () => notifier.setLightMode('cool'),
                      ),
                      _ColorModeButton(
                        label: 'Daylight',
                        icon: Icons.wb_sunny,
                        color: Colors.yellow.shade700,
                        isSelected: currentDevice.lightColor == 'daylight',
                        onTap: () => notifier.setLightMode('daylight'),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOnline;
  final bool isLocal;
  const _StatusBadge({required this.isOnline, this.isLocal = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isOnline
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isOnline
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? (isLocal ? "Online • Local Network" : "Online") : "Offline",
            style: TextStyle(
              color: isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 13,
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
      color:
          isActive ? AppColors.softOrange.withValues(alpha: 0.3) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isActive
                ? const BorderSide(color: AppColors.atombergOrange, width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.atombergOrange : Colors.grey,
              size: 32,
            ),
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

class _ColorModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorModeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
