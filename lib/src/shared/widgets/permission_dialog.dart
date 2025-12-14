import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/udp_discovery_provider.dart';

/// Dialog to request local network permissions with explanation
class LocalNetworkPermissionDialog extends ConsumerWidget {
  const LocalNetworkPermissionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionService = ref.read(permissionServiceProvider);
    
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.blue),
          const SizedBox(width: 12),
          const Flexible(
            child: Text('Local Network Access'),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            permissionService.getPermissionRationale(),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Benefits:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _buildBenefit('⚡', 'Faster response (50ms vs 500ms)'),
          _buildBenefit('📶', 'Works without internet'),
          _buildBenefit('🔒', 'Enhanced privacy - local control'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not Now'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Allow'),
        ),
      ],
    );
  }
  
  Widget _buildBenefit(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

/// Show permission dialog and request permissions
Future<bool> showLocalNetworkPermissionDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LocalNetworkPermissionDialog(),
  );
  
  if (result == true) {
    final permissionService = ref.read(permissionServiceProvider);
    return await permissionService.requestLocalNetworkPermissions();
  }
  
  return false;
}
