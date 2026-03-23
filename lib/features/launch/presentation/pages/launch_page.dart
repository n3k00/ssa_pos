import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/auth/presentation/pages/login_page.dart';
import 'package:ssa/features/launch/presentation/models/launch_state.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class LaunchPage extends ConsumerStatefulWidget {
  const LaunchPage({super.key});

  @override
  ConsumerState<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends ConsumerState<LaunchPage> {
  static const Duration _minimumLaunchDuration = Duration(milliseconds: 800);
  LaunchState _state = LaunchState(statusMessage: AppStrings.launchStarting);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_start());
    });
  }

  Future<void> _start() async {
    final stopwatch = Stopwatch()..start();
    try {
      await ref.read(deviceIdServiceProvider).getOrCreateDeviceId();
      if (!mounted) {
        return;
      }
      setState(() {
        _state = _state.copyWith(statusMessage: AppStrings.launchCheckingSession);
      });

      final user = ref.read(firebaseAuthProvider).currentUser;
      if (!mounted) {
        return;
      }

      await _waitForMinimumDuration(stopwatch);
      if (!mounted) {
        return;
      }

      if (user == null) {
        _openNext(const LoginPage());
        return;
      }

      unawaited(ref.read(voucherSyncServiceProvider).syncIfAuthenticated());
      _openNext(const PosHomePage());
    } catch (_) {
      await _waitForMinimumDuration(stopwatch);
      if (!mounted) {
        return;
      }
      _openNext(const LoginPage());
    }
  }

  Future<void> _waitForMinimumDuration(Stopwatch stopwatch) async {
    final remaining = _minimumLaunchDuration - stopwatch.elapsed;
    if (!remaining.isNegative && remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
  }

  void _openNext(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3FBF8), AppColors.background],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -70,
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
            Positioned(
              bottom: -110,
              left: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.08),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spacing24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimens.spacing20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x260F766E),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing20),
                      Text(AppStrings.appName, style: AppTextStyles.headlineLarge),
                      const SizedBox(height: AppDimens.spacing12),
                      Text(
                        _state.statusMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing20),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
