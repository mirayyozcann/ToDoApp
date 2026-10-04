// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../responsive_helper.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false, _obscurePassword = true;

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


  // --- YARDIMCI STİL METOTLARI ---
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

  void _register(LanguageNotifier lang) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    bool success = await _apiService.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        _showMessage(lang.translate('register_success'), isError: false);
        Navigator.pop(context);
      } else {
        _showMessage(lang.translate('register_error'));
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textColor),
        title: Text(lang.translate('register'), style: _txtStyle(theme, 18, FontWeight.bold, theme.textColor)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: UIHelper.pagePadding,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
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
                    // ------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(lang.translate('create_account'), textAlign: TextAlign.center, style: _txtStyle(theme, 24, FontWeight.bold, theme.textColor)),
                          const SizedBox(height: 6),
                          Text(lang.translate('register_subtitle'), textAlign: TextAlign.center, style: _txtStyle(theme, 14, FontWeight.normal, theme.subtitleColor)),
                          const SizedBox(height: 32),
                          Text(lang.translate('username'), style: _txtStyle(theme, 13, FontWeight.w600, theme.textColor)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameController,
                            style: _txtStyle(theme, 15, FontWeight.normal, theme.textColor),
                            decoration: _inputDec(theme, "kullaniciadi", Icons.person_outline),
                            validator: (v) => v == null || v.trim().isEmpty ? lang.translate('username_empty_error') : null,
                          ),
                          const SizedBox(height: 20),
                          Text(lang.translate('email'), style: _txtStyle(theme, 13, FontWeight.w600, theme.textColor)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            style: _txtStyle(theme, 15, FontWeight.normal, theme.textColor),
                            decoration: _inputDec(theme, "ornek@todoapp.com", Icons.mail_outline),
                            validator: (v) => v == null || v.trim().isEmpty ? lang.translate('email_empty_error') : null,
                          ),
                          const SizedBox(height: 20),
                          Text(lang.translate('password'), style: _txtStyle(theme, 13, FontWeight.w600, theme.textColor)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
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
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                              onPressed: _isLoading ? null : () => _register(lang),
                              child: _isLoading ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: theme.isDarkMode ? const Color(0xFF0F1117) : Colors.white, strokeWidth: 2)) : Text(lang.translate('register_button'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
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