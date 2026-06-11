import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/primary_button.dart';
import '../services/auth_service.dart';
import 'complete_profile_screen.dart';
import 'home_screen.dart';
import 'admin/admin_shell.dart';

const _kAdminEmail    = 'admin@dineandgo.com';
const _kAdminPassword = 'admin123';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin          = false;
  bool _obscurePassword  = true;
  bool _isLoading        = false;
  String? _errorMsg;

  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name     = _nameCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final phone    = _phoneCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Please fill in all required fields.');
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      await AuthService.signUp(
        email: email,
        password: password,
        fullName: name,
        phone: phone,
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMsg = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() { _errorMsg = null; });

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Please enter your email and password.');
      return;
    }

    // Admin shortcut — bypass Supabase Auth for demo admin account
    if (email == _kAdminEmail && password == _kAdminPassword) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminShell(),
          settings: const RouteSettings(name: '/admin'),
        ),
        (_) => false,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signIn(email: email, password: password);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      setState(() => _errorMsg = 'Invalid email or password.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              Column(
                children: [
                  const Icon(Icons.restaurant,
                      size: 64, color: AppColors.midnightBlue),
                  const SizedBox(height: 8),
                  Text('DineAndGo', style: headline(26)),
                ],
              ),
              const SizedBox(height: 24),

              // ── Mode toggle (Sign Up / Log In) ────────────────────────────
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _modeTab('Sign Up', !_isLogin),
                    _modeTab('Log In', _isLogin),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Title ─────────────────────────────────────────────────────
              Text(
                _isLogin ? 'Welcome Back' : 'Create Your Account',
                style: headline(28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Sign in to continue your dining experience.'
                    : 'Join a community of discerning diners.',
                style: body(14, color: AppColors.textGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // ── Sign-up-only fields ───────────────────────────────────────
              if (!_isLogin) ...[
                _fieldLabel('Full Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.textGray),
                    hintText: 'Enter your full name',
                    hintStyle: body(14, color: AppColors.textGray),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Email ─────────────────────────────────────────────────────
              _fieldLabel('Email Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline,
                      color: AppColors.textGray),
                  hintText: 'Enter your email',
                  hintStyle: body(14, color: AppColors.textGray),
                ),
              ),
              const SizedBox(height: 16),

              // ── Sign-up-only phone ────────────────────────────────────────
              if (!_isLogin) ...[
                _fieldLabel('Phone Number'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined,
                        color: AppColors.textGray),
                    hintText: 'Enter your phone number',
                    hintStyle: body(14, color: AppColors.textGray),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Password ──────────────────────────────────────────────────
              _fieldLabel('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textGray),
                  hintText: _isLogin
                      ? 'Enter your password'
                      : 'Create a password',
                  hintStyle: body(14, color: AppColors.textGray),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textGray,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              // ── Error message ─────────────────────────────────────────────
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(_errorMsg!,
                              style: body(13, color: AppColors.error))),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // ── Primary action button ─────────────────────────────────────
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      label: _isLogin ? 'Log In' : 'Sign Up',
                      onTap: _isLogin ? _handleLogin : _handleSignUp,
                    ),

              // ── Admin hint (only shown on login screen) ───────────────────
              if (_isLogin) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    _emailCtrl.text    = _kAdminEmail;
                    _passwordCtrl.text = _kAdminPassword;
                    setState(() {});
                  },
                  child: Center(
                    child: Text(
                      'Demo admin: tap to autofill credentials',
                      style: body(11,
                          color: AppColors.champagneGold
                              .withOpacity(0.7)),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // ── Divider ───────────────────────────────────────────────────
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Or continue with',
                        style: body(13, color: AppColors.textGray)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // ── Toggle link ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? "Don't have an account? "
                        : "Already have an account? ",
                    style: body(14, color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _isLogin = !_isLogin;
                      _errorMsg = null;
                    }),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0)),
                    child: Text(
                      _isLogin ? 'Sign Up' : 'Log In',
                      style: body(14,
                          color: AppColors.champagneGold,
                          fw: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeTab(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _isLogin = label == 'Log In';
          _errorMsg = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1))
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: body(14,
                  color: active
                      ? AppColors.midnightBlue
                      : AppColors.textGray,
                  fw: active ? FontWeight.w600 : FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: body(14,
          color: AppColors.textSecondary, fw: FontWeight.w600),
    );
  }
}
