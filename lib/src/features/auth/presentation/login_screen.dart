import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/constants.dart';
import '../data/auth_provider.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _refreshTokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _refreshTokenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        await ref.read(authProvider.notifier).login(
          _apiKeyController.text.trim(),
          _refreshTokenController.text.trim(),
        );
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 16),
                
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),
                
                const SizedBox(height: 8),
                
                Text(
                  'Enter your developer credentials to control your fans.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ).animate().fadeIn(delay: 300.ms).moveY(begin: 10, end: 0),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'API Key',
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.key),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ).animate().fadeIn(delay: 400.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _refreshTokenController,
                  decoration: const InputDecoration(
                    labelText: 'Refresh Token',
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.refresh),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ).animate().fadeIn(delay: 500.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.atombergOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Connect', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ).animate().fadeIn(delay: 600.ms).moveY(begin: 10, end: 0),
                
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: _isLoading 
                    ? null 
                    : () {
                        ref.read(authProvider.notifier).loginAsDemo();
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          );
                        }
                      },
                  child: const Text('Try Demo Mode'),
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }
}

