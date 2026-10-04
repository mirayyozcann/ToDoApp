// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final int userId;

  const SettingsScreen({super.key, required this.userId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _currentEmail = "";
  String _currentName = "Kullanıcı";

  @override
  void initState() {
    super.initState();
    _loadSettingsData();
  }

  Future<void> _loadSettingsData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final langNotifier = Provider.of<LanguageNotifier>(context, listen: false);

    setState(() {
      _currentEmail = prefs.getString('user_email_${widget.userId}') ?? langNotifier.translate('email_not_found');
      _currentName = prefs.getString('user_name_${widget.userId}') ?? langNotifier.translate('user');
    });
  }

  void _showLanguageBottomSheet(BuildContext context, ThemeNotifier theme) {
    final languageNotifier = Provider.of<LanguageNotifier>(context, listen: false);
    String tempSelectedLang = languageNotifier.currentLocale.languageCode;

    final List<Map<String, String>> languages = [
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: theme.textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            context.t('select_language'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48, height: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...languages.map((lang) {
                      bool isSelected = tempSelectedLang == lang['code'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setStateModal(() {
                              tempSelectedLang = lang['code']!;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? theme.accentBlue : theme.borderColor,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  lang['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    lang['name']!,
                                    style: TextStyle(
                                      color: theme.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                                  color: isSelected ? theme.accentBlue : theme.subtitleColor.withOpacity(0.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          languageNotifier.changeLanguage(tempSelectedLang);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          context.t('apply_changes'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'tr': return "Türkçe";
      case 'en': return "English";
      case 'de': return "Deutsch";
      case 'fr': return "Français";
      case 'es': return "Español";
      case 'it': return "Italiano";
      default: return "Türkçe";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('settings'),
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context.t('account'), theme),
            const SizedBox(height: 8),
            _buildCard(
              theme,
              [
                _buildTile(
                  Icons.person_outline,
                  context.t('edit_profile'),
                  theme,
                  onTap: () {
                    // Ayarlar sayfasını kapat ve 3 (Profil Sekmesi indeksi) değerini gönder
                    Navigator.pop(context, 3);
                  },
                ),
                _buildDivider(theme),
                _buildTile(
                  Icons.email_outlined,
                  context.t('email'),
                  theme,
                  subtitle: _currentEmail,
                  onTap: () {},
                ),
                _buildDivider(theme),
                _buildTile(
                  Icons.lock_outline,
                  context.t('change_password'),
                  theme,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context.t('application'), theme),
            const SizedBox(height: 8),
            _buildCard(
              theme,
              [
                SwitchListTile(
                  secondary: Icon(Icons.notifications_none_outlined, color: theme.textColor),
                  title: Text(context.t('notifications'), style: TextStyle(color: theme.textColor, fontWeight: FontWeight.w500)),
                  value: _notificationsEnabled,
                  activeColor: theme.accentBlue,
                  onChanged: (val) {
                    setState(() {
                      _notificationsEnabled = val;
                    });
                  },
                ),
                _buildDivider(theme),
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode_outlined, color: theme.textColor),
                  title: Text(context.t('dark_mode'), style: TextStyle(color: theme.textColor, fontWeight: FontWeight.w500)),
                  value: theme.isDarkMode,
                  activeColor: theme.accentBlue,
                  onChanged: (val) {
                    theme.toggleTheme();
                  },
                ),
                _buildDivider(theme),
                _buildTile(
                  Icons.language,
                  context.t('language'),
                  theme,
                  subtitle: _getLanguageName(languageNotifier.currentLocale.languageCode),
                  onTap: () {
                    _showLanguageBottomSheet(context, theme);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context.t('security'), theme),
            const SizedBox(height: 8),
            _buildCard(
              theme,
              [
                _buildTile(Icons.security, context.t('two_factor'), theme, onTap: () {}),
                _buildDivider(theme),
                _buildTile(Icons.devices, context.t('device_management'), theme, onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context.t('support'), theme),
            const SizedBox(height: 8),
            _buildCard(
              theme,
              [
                _buildTile(Icons.help_outline, context.t('help_center'), theme, trailingIcon: Icons.open_in_new, onTap: () {}),
                _buildDivider(theme),
                _buildTile(Icons.privacy_tip_outlined, context.t('privacy_policy'), theme, trailingIcon: Icons.open_in_new, onTap: () {}),
                _buildDivider(theme),
                _buildTile(Icons.description_outlined, context.t('terms_of_use'), theme, trailingIcon: Icons.open_in_new, onTap: () {}),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  backgroundColor: Colors.red.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  context.t('logout'),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeNotifier theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.subtitleColor,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildCard(ThemeNotifier theme, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(
      IconData icon,
      String title,
      ThemeNotifier theme, {
        String? subtitle,
        IconData trailingIcon = Icons.arrow_forward_ios_rounded,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: theme.textColor, size: 22),
      title: Text(
        title,
        style: TextStyle(color: theme.textColor, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(color: theme.subtitleColor, fontSize: 12),
      )
          : null,
      trailing: Icon(trailingIcon, size: trailingIcon == Icons.open_in_new ? 18 : 14, color: theme.subtitleColor),
      onTap: onTap,
    );
  }

  Widget _buildDivider(ThemeNotifier theme) {
    return Divider(height: 1, thickness: 0.5, color: theme.borderColor, indent: 54);
  }
}
