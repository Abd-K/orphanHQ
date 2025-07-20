import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/backup_service.dart';
import '../database.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

// Simple theme provider
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _clearAllData() async {
    final confirmed = await _showConfirmationDialog(
      'Clear All Data',
      'This will permanently delete ALL orphan data, supervisor data, and associated files. '
          'This action cannot be undone. Are you sure you want to continue?',
      'Delete All',
      Colors.red,
    );

    if (confirmed != true) return;

    // Double confirmation for such a destructive action
    final doubleConfirmed = await _showConfirmationDialog(
      'Final Confirmation',
      'You are about to PERMANENTLY DELETE all data. '
          'This includes all orphan records, supervisor records, and uploaded files. '
          'Type "DELETE" to confirm.',
      'DELETE',
      Colors.red,
      requireTextConfirmation: true,
    );

    if (doubleConfirmed != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing all data...';
    });

    try {
      // Create a final backup before clearing
      setState(() {
        _statusMessage = 'Creating safety backup before clearing...';
      });
      await BackupService.createBackup();

      final database = AppDb();

      // Clear database tables
      setState(() {
        _statusMessage = 'Clearing database...';
      });
      await database.delete(database.orphans).go();
      await database.delete(database.supervisors).go();

      // Clear image directories
      setState(() {
        _statusMessage = 'Clearing files...';
      });
      await _clearImageDirectories();

      setState(() {
        _statusMessage = 'All data cleared successfully!';
      });

      _showSuccessDialog(
        'Data Cleared',
        'All data has been permanently deleted. A final backup was created before deletion.',
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      _clearStatusAfterDelay();
    }
  }

  Future<void> _clearImageDirectories() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      // Clear orphan documents
      final documentsDir = Directory(p.join(appDir.path, 'orphan_documents'));
      if (await documentsDir.exists()) {
        await documentsDir.delete(recursive: true);
      }

      // Clear orphan photos
      final photosDir = Directory(p.join(appDir.path, 'orphan_photos'));
      if (await photosDir.exists()) {
        await photosDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing image directories: $e');
    }
  }

  Future<bool?> _showConfirmationDialog(
    String title,
    String content,
    String confirmText,
    Color confirmColor, {
    bool requireTextConfirmation = false,
  }) async {
    if (requireTextConfirmation) {
      final controller = TextEditingController();
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type "DELETE" to confirm',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text == 'DELETE') {
                  Navigator.of(context).pop(true);
                }
              },
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearStatusAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _statusMessage = '';
        });
      }
    });
  }

  void _navigateToBackup() {
    context.go('/backup');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      children: [
        // Action Bar
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
              ),
              if (_isLoading)
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Processing...',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Status message
        if (_statusMessage.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _statusMessage.contains('Error') ||
                    _statusMessage.contains('Failed')
                ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.red.shade900.withOpacity(0.3)
                    : Colors.red[50])
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.green.shade900.withOpacity(0.3)
                    : Colors.green[50]),
            child: Row(
              children: [
                Icon(
                  _statusMessage.contains('Error') ||
                          _statusMessage.contains('Failed')
                      ? Icons.error
                      : Icons.info,
                  color: _statusMessage.contains('Error') ||
                          _statusMessage.contains('Failed')
                      ? Colors.red
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Page Content
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsSection(
                  'General',
                  [
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English (Not implemented yet)',
                      onTap: null,
                      isDisabled: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Enabled (Not implemented yet)',
                      onTap: null,
                      isDisabled: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.palette,
                      title: 'Theme',
                      subtitle: themeProvider.isDarkMode ? 'Dark' : 'Light',
                      onTap: () => themeProvider.toggleTheme(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  'Data Management',
                  [
                    _buildSettingsTile(
                      icon: Icons.backup,
                      title: 'Backup & Restore',
                      subtitle: 'Manage your data backups',
                      onTap: _isLoading ? null : _navigateToBackup,
                    ),
                    _buildSettingsTile(
                      icon: Icons.delete_forever,
                      title: 'Clear All Data',
                      subtitle:
                          'Permanently delete all data (creates backup first)',
                      onTap: _isLoading ? null : _clearAllData,
                      isDestructive: true,
                    ),
                  ],
                ),
                _buildSettingsSection(
                  'System',
                  [
                    _buildSettingsTile(
                      icon: Icons.cloud,
                      title: 'API Connection Status',
                      subtitle: 'View server and tunnel status',
                      onTap: () => context.go('/connection'),
                    ),
                    _buildSettingsTile(
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'Orphan HQ v1.0.0',
                      onTap: () {},
                    ),
                    _buildSettingsTile(
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () {},
                    ),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isDestructive = false,
    bool isDisabled = false,
  }) {
    final theme = Theme.of(context);
    final disabledColor = theme.brightness == Brightness.dark
        ? Colors.grey[600]
        : Colors.grey[400];

    return ListTile(
      leading: Icon(
        icon,
        color: isDisabled
            ? disabledColor
            : (isDestructive ? Colors.red[600] : theme.iconTheme.color),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDisabled
              ? disabledColor
              : (isDestructive
                  ? Colors.red[600]
                  : theme.textTheme.titleMedium?.color),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDisabled
              ? disabledColor
              : (isDestructive
                  ? Colors.red[400]
                  : theme.textTheme.bodySmall?.color),
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.iconTheme.color,
            )
          : Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: disabledColor,
            ),
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}
