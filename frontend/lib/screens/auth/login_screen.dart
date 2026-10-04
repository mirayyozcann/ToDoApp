// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import '../home/home_screen.dart';
import '../../services/api_service.dart';
import '../../responsive_helper.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../home/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false, _obscurePassword = true, _isRememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('is_remember_me') ?? false) {
      setState(() {
        _emailController.text = prefs.getString('saved_email') ?? '';
        _sifreController.text = prefs.getString('saved_password') ?? '';
        _isRememberMe = true;
      });
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }


  TextStyle _txtStyle(ThemeNotifier t, double size, FontWeight weight, Color color) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color);

  InputDecoration _inputDec(ThemeNotifier t, String hint, IconData icon, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: t.subtitleColor.withOpacity(0.7)),
    prefixIcon: Icon(icon, size: 20, color: t.subtitleColor),
    suffixIcon: suffix,
    filled: true,
    fillColor: t.isDarkMode ? const Color(0xFF21262D) : const Color(0xFFF6F8FA),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: t.borderColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: t.borderColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: t.accentBlue, width: 2)),
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
  );

  void _showForgotPasswordDialog(LanguageNotifier lang) {
    final resetEmailController = TextEditingController();
    final resetFormKey = GlobalKey<FormState>();
    bool isResetting = false;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Provider.of<ThemeNotifier>(context);
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(lang.translate('forgot_password'), style: _txtStyle(theme, 18, FontWeight.bold, theme.textColor)),
            content: Form(
              key: resetFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Şifrenizi doğrudan e-posta ile göndermiyoruz. Güvenliğiniz için e-posta adresinize şifre sıfırlama bağlantısı gönderilecektir.", style: _txtStyle(theme, 13, FontWeight.normal, theme.subtitleColor)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: resetEmailController,
                    style: _txtStyle(theme, 14, FontWeight.normal, theme.textColor),
                    decoration: _inputDec(theme, "ornek@todoapp.com", Icons.mail_outline),
                    validator: (v) => v == null || v.trim().isEmpty ? lang.translate('email_empty_error') : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isResetting ? null : () => Navigator.pop(context),
                child: Text(lang.translate('cancel') ?? "İptal", style: TextStyle(color: theme.subtitleColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: isResetting ? null : () async {
                  if (!resetFormKey.currentState!.validate()) return;
                  setDialogState(() => isResetting = true);
                  await Future.delayed(const Duration(seconds: 1));
                  if (!mounted) return;
                  Navigator.pop(context);
                  _showMessage("Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.", isError: false);
                },
                child: isResetting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(lang.translate('send') ?? "Gönder"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogin(LanguageNotifier lang) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      int? kullaniciId = await _apiService.login(_emailController.text.trim(), _sifreController.text.trim());
      if (!mounted) return;

      if (kullaniciId != null) {
        final prefs = await SharedPreferences.getInstance();
        if (_isRememberMe) {
          await prefs.setString('saved_email', _emailController.text.trim());
          await prefs.setString('saved_password', _sifreController.text.trim());
          await prefs.setBool('is_remember_me', true);
        } else {
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
          await prefs.setBool('is_remember_me', false);
        }

        _showMessage(lang.translate('login_success'), isError: false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(userId: kullaniciId, kullaniciAdi: _emailController.text.split('@')[0])));
      } else {
        _showMessage(lang.translate('login_error'));
      }
    } catch (e) {
      _showMessage(lang.translate('server_error'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: UIHelper.pagePadding,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            // Kartın iç padding'ini sıfırlıyoruz ki banner kenarlara tam yapışsın
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.borderColor, width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(theme.isDarkMode ? 0.5 : 0.08), blurRadius: 30, offset: const Offset(0, 15))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
               

                   
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(lang.translate('welcome_back'), textAlign: TextAlign.center, style: _txtStyle(theme, 22, FontWeight.w600, theme.textColor)),
                          const SizedBox(height: 6),
                          Text(lang.translate('login_subtitle'), textAlign: TextAlign.center, style: _txtStyle(theme, 14, FontWeight.normal, theme.subtitleColor)),
                          const SizedBox(height: 32),
                          Text(lang.translate('email_or_username'), style: _txtStyle(theme, 13, FontWeight.w600, theme.textColor)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            style: _txtStyle(theme, 15, FontWeight.normal, theme.textColor),
                            decoration: _inputDec(theme, "ornek@todoapp.com", Icons.mail_outline),
                            validator: (v) => v == null || v.trim().isEmpty ? lang.translate('email_empty_error') : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(lang.translate('password'), style: _txtStyle(theme, 13, FontWeight.w600, theme.textColor)),
                              GestureDetector(
                                onTap: () => _showForgotPasswordDialog(lang),
                                child: Text(lang.translate('forgot_password'), style: _txtStyle(theme, 13, FontWeight.w600, theme.accentBlue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _sifreController,
                            obscureText: _obscurePassword,
                            style: _txtStyle(theme, 15, FontWeight.normal, theme.textColor),
                            decoration: _inputDec(
                              theme,
                              "••••••••",
                              Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20, color: theme.subtitleColor),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? lang.translate('password_empty_error') : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _isRememberMe,
                                  activeColor: theme.accentBlue,
                                  side: BorderSide(color: theme.borderColor),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (v) => setState(() => _isRememberMe = v ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => setState(() => _isRememberMe = !_isRememberMe),
                                child: Text(lang.translate('remember_me'), style: _txtStyle(theme, 14, FontWeight.w500, theme.textColor)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                              onPressed: _isLoading ? null : () => _handleLogin(lang),
                              child: _isLoading ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: theme.isDarkMode ? const Color(0xFF0F1117) : Colors.white, strokeWidth: 2)) : Text(lang.translate('login_button'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          UIHelper.verticalSpaceLow(context),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                              if (mounted) setState(() {});
                            },
                            child: Text(lang.translate('no_account_register'), style: _txtStyle(theme, 14, FontWeight.w600, theme.accentBlue)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}