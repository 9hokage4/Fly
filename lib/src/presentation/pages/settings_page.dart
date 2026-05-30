import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../model/settings_model.dart';
import '../../services/auth_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSettingCard(
              context,
              title: 'Тема',
              icon: Icons.brightness_6,
              onTap: () => _showThemeDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              title: 'Шрифт',
              icon: Icons.font_download,
              onTap: () => _showFontDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              title: 'Основной цвет',
              icon: Icons.color_lens,
              onTap: () => _showColorDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              title: 'Выйти',
              icon: Icons.logout,
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Светлая'),
              onTap: () {
                context.read<SettingsModel>().setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Тёмная'),
              onTap: () {
                context.read<SettingsModel>().setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Выберите шрифт'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Roboto', style: TextStyle(fontFamily: 'Roboto')),
              onTap: () {
                context.read<SettingsModel>().setFontFamily('Roboto');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Impact', style: TextStyle(fontFamily: 'Impact')),
              onTap: () {
                context.read<SettingsModel>().setFontFamily('Impact');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Saxonia Antiqua', style: TextStyle(fontFamily: 'Saxonia Antiqua')),
              onTap: () {
                context.read<SettingsModel>().setFontFamily('Saxonia Antiqua');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Выберите основной цвет'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _colorOption(context, const Color(0xFFB989FE)), // фиолетовый
            _colorOption(context, Colors.blue.shade300),
            _colorOption(context, Colors.green.shade300),
            _colorOption(context, Colors.orange.shade300),
            _colorOption(context, Colors.pink.shade300),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsModel>().setAccentColor(color);
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: color,
      ),
    );
  }
}