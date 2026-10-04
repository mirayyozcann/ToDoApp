// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../language_notifier.dart';
import '../theme_notifier.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String initialName;
  final String? initialEmail;
  final Function(String) onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.initialName,
    this.initialEmail,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.initialName);
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _aboutController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedProfileData();
  }

  Future<void> _loadSavedProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? name = prefs.getString('user_name_${widget.userId}');
      if (name != null && name.isNotEmpty) {
        _nameController.text = name;
        widget.onProfileUpdated(name);
      }
      _emailController.text = prefs.getString('user_email_${widget.userId}') ?? '';
      _titleController.text = prefs.getString('user_title_${widget.userId}') ?? '';
      _aboutController.text = prefs.getString('user_about_${widget.userId}') ?? '';

      String? imgPath = prefs.getString('user_image_${widget.userId}');
      if (imgPath != null && File(imgPath).existsSync()) _selectedImage = File(imgPath);
    });
  }

  Future<void> _saveAllProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name_${widget.userId}', _nameController.text);
    await prefs.setString('user_email_${widget.userId}', _emailController.text);
    await prefs.setString('user_title_${widget.userId}', _titleController.text);
    await prefs.setString('user_about_${widget.userId}', _aboutController.text);
    if (_selectedImage != null) {
      await prefs.setString('user_image_${widget.userId}', _selectedImage!.path);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() => _selectedImage = File(file.path));
      await _saveAllProfileData();
    }
  }

  void _showPickerOptions(LanguageNotifier lang, ThemeNotifier theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(children: [
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: theme.textColor),
              title: Text(lang.translate('select_from_gallery'), style: theme.tStyle(14)),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: theme.textColor),
              title: Text(lang.translate('take_photo_camera'), style: theme.tStyle(14)),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
          ]),
        ),
      ),
    );
  }

  void _saveProfile(LanguageNotifier lang) async {
    await _saveAllProfileData();
    widget.onProfileUpdated(_nameController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.translate('profile_saved_success')),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageNotifier>(context);
    final theme = Provider.of<ThemeNotifier>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.translate('edit_profile'), style: theme.titleStyle(24)),
            const SizedBox(height: 2),
            Text(lang.translate('update_profile_info'), style: theme.subtitleStyle(12)),
            const SizedBox(height: 24),

            // --- PROFİL FOTOĞRAFI ---
            Center(
              child: Stack(children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: theme.cardColor,
                    border: Border.all(color: theme.borderColor.withOpacity(0.8), width: 1.2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                    image: _selectedImage != null ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover) : null,
                  ),
                  child: _selectedImage == null ? Icon(Icons.person_outline_rounded, size: 50, color: theme.subtitleColor) : null,
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: GestureDetector(
                    onTap: () => _showPickerOptions(lang, theme),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.accentBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.cardColor, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            
            _buildField(lang.translate('profile_full_name'), _nameController, lang.translate('name_hint'), Icons.person_rounded, theme, 1),
            const SizedBox(height: 14),
            _buildField(lang.translate('email'), _emailController, lang.translate('email_hint'), Icons.email_rounded, theme, 1),
            const SizedBox(height: 14),
            _buildField(lang.translate('title'), _titleController, lang.translate('title_hint'), Icons.badge_rounded, theme, 1),
            const SizedBox(height: 14),
            _buildField(lang.translate('profile_about'), _aboutController, lang.translate('about_hint'), Icons.info_rounded, theme, 3),
            const SizedBox(height: 28),

            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveProfile(lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(lang.translate('save_changes'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, IconData icon, ThemeNotifier theme, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.subtitleStyle(11, weight: FontWeight.bold).copyWith(letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderColor.withOpacity(0.8), width: 1.2),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: theme.tStyle(14),
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(icon, color: theme.subtitleColor, size: 20),
              prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 0),
              hintText: hint,
              hintStyle: theme.subtitleStyle(14).copyWith(color: theme.subtitleColor.withOpacity(0.4)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}