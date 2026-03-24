import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/core/utils/phone_normalizer.dart';
import 'package:ssa/features/auth/presentation/providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredFieldMessage;
    }

    try {
      PhoneNormalizer.normalizeMyanmarPhone(value);
    } on FormatException {
      return AppStrings.invalidPhoneNumber;
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredFieldMessage;
    }
    return null;
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _submitting) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithPhoneAndPassword(
            phone: _phoneController.text,
            password: _passwordController.text,
          );
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } on FirebaseAuthException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.loginFailedGeneric)),
      );
    } on FormatException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.invalidPhoneNumber)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.loginFailedGeneric)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
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
              right: -60,
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
              top: 70,
              left: -90,
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.spacing20,
                      AppDimens.spacing24,
                      AppDimens.spacing20,
                      AppDimens.spacing24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.spacing20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppDimens.spacing24,
                          ),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.75),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.spacing16,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x260F766E),
                                      blurRadius: 18,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacing20),
                            Text(
                              AppStrings.loginTitle,
                              style: AppTextStyles.headlineLarge,
                            ),
                            const SizedBox(height: AppDimens.spacing20),
                            Text(
                              AppStrings.phoneNumberLabel,
                              style: AppTextStyles.labelLarge,
                            ),
                            const SizedBox(height: AppDimens.spacing8),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: '09 123 456 789',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              validator: _phoneValidator,
                              enabled: !_submitting,
                            ),
                            const SizedBox(height: AppDimens.spacing16),
                            Text(
                              AppStrings.passwordLabel,
                              style: AppTextStyles.labelLarge,
                            ),
                            const SizedBox(height: AppDimens.spacing8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: AppStrings.passwordLabel,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: _submitting
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: _passwordValidator,
                              enabled: !_submitting,
                            ),
                            const SizedBox(height: AppDimens.spacing20),
                            ElevatedButton(
                              onPressed: _submitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radius16,
                                  ),
                                ),
                              ),
                              child: Text(
                                _submitting
                                    ? AppStrings.loading
                                    : AppStrings.signIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
