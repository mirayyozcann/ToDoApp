import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import 'home_screen.dart';
import '../todo/todo_screen.dart';
import '../todo/stats_screen.dart';
import '../profile_screen.dart';
import '../notification_screen.dart';
import '../settings_screen.dart';
import '../auth/login_screen.dart';

class MainScreen extends StatefulWidget {
  final int userId;
  final String kullaniciAdi;

  const MainScreen({
    super.key,
    required this.userId,
    this.kullaniciAdi = "Kullanıcı",
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late String _currentName;
  String? _savedImagePath;
  String _currentEmail = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentName = widget.kullaniciAdi;
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? savedName = prefs.getString('user_name_${widget.userId}');
      if (savedName != null && savedName.isNotEmpty) {
        _currentName = savedName;
      }
      _savedImagePath = prefs.getString('user_image_${widget.userId}');

      String? savedEmail = prefs.getString('user_email_${widget.userId}');
      if (savedEmail != null && savedEmail.isNotEmpty) {
        _currentEmail = savedEmail;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    final List<Widget> pages = [
      HomeScreen(userId: widget.userId, kullaniciAdi: _currentName),
      TodoScreen(userId: widget.userId),
      StatsScreen(userId: widget.userId),
      ProfileScreen(
        userId: widget.userId,
        initialName: _currentName,
        onProfileUpdated: (newName) {
          setState(() {
            _currentName = newName;
          });
          _loadProfileData();
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.textColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          lang.translate('app_title'),
          style: theme.titleStyle(18),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: theme.cardColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.isDarkMode ? const Color(0xFF21262D) : Colors.grey[200],
                      border: Border.all(color: theme.subtitleColor.withOpacity(0.2)),
                      image: _savedImagePath != null && File(_savedImagePath!).existsSync()
                          ? DecorationImage(
                        image: FileImage(File(_savedImagePath!)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _savedImagePath == null
                        ? Icon(Icons.person_outline_rounded, size: 28, color: theme.subtitleColor)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentName,
                    style: theme.titleStyle(16),
                  ),
                  if (_currentEmail.isNotEmpty)
                    Text(_currentEmail, style: theme.subtitleStyle(12)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.grid_view_rounded, lang.translate('home_screen'), 0, theme),
            _buildDrawerItem(Icons.assignment_outlined, lang.translate('edit_profile'), 3, theme),
            _buildDrawerItem(Icons.bar_chart_rounded, lang.translate('stats'), 2, theme),
            _buildDrawerItem(
              Icons.notifications_none_outlined,
              lang.translate('notifications'),
              -1,
              theme,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(userId: widget.userId)));
              },
            ),
            Divider(color: theme.borderColor, height: 40),
            _buildDrawerItem(
              Icons.settings_outlined,
              lang.translate('settings'),
              -1,
              theme,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(userId: widget.userId)));
              },
            ),
            _buildDrawerItem(
              Icons.logout,
              lang.translate('logout'),
              -1,
              theme,
              isLogout: true,
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardColor,
        selectedItemColor: theme.accentBlue,
        unselectedItemColor: theme.subtitleColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          _buildNavItem(Icons.home_outlined, lang.translate('home_screen'), 0, theme),
          _buildNavItem(Icons.assignment_outlined, lang.translate('tasks'), 1, theme),
          _buildNavItem(Icons.bar_chart_rounded, lang.translate('stats'), 2, theme),
          _buildNavItem(Icons.person_outline, lang.translate('profile'), 3, theme),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index, ThemeNotifier theme) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? theme.accentBlue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  Widget _buildDrawerItem(
      IconData icon,
      String title,
      int index,
      ThemeNotifier theme, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    bool isSelected = _selectedIndex == index && index != -1;
    final itemColor = isLogout ? Colors.red : (isSelected ? theme.accentBlue : theme.textColor);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? theme.accentBlue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: itemColor),
        title: Text(
          title,
          style: theme.tStyle(
            14,
            color: itemColor,
            weight: isSelected || isLogout ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap ??
                () {
              if (index != -1) setState(() => _selectedIndex = index);
              Navigator.pop(context);
            },
      ),
    );
  }
}