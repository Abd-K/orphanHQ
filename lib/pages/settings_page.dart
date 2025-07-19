import 'package:flutter/material.dart';
import 'package:orphan_hq/layouts/desktop_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      currentRoute: '/settings',
      pageTitle: 'Settings',
      actions: [
        // Settings actions
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings exported successfully')),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text('Export Data'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings saved successfully')),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('Save Settings'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
      child: _buildSettingsContent(context),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Categories
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategoryItem('General', Icons.settings, true),
                _buildCategoryItem('Users & Permissions', Icons.people, false),
                _buildCategoryItem('Data & Privacy', Icons.security, false),
                _buildCategoryItem('Notifications', Icons.notifications, false),
                _buildCategoryItem('Backup & Sync', Icons.cloud, false),
                _buildCategoryItem('About', Icons.info, false),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Settings Content
          Expanded(
            child: Column(
              children: [
                // General Settings Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.settings, color: Colors.blue[600]),
                            const SizedBox(width: 8),
                            Text(
                              'General Settings',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSettingItem(
                          'Application Language',
                          'Choose the language for the application interface',
                          DropdownButton<String>(
                            value: 'English',
                            items: const [
                              DropdownMenuItem(
                                  value: 'English', child: Text('English')),
                              DropdownMenuItem(
                                  value: 'Arabic', child: Text('العربية')),
                              DropdownMenuItem(
                                  value: 'Kurdish', child: Text('کوردی')),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        _buildSettingItem(
                          'Date Format',
                          'Select how dates are displayed throughout the application',
                          DropdownButton<String>(
                            value: 'DD/MM/YYYY',
                            items: const [
                              DropdownMenuItem(
                                  value: 'DD/MM/YYYY',
                                  child: Text('DD/MM/YYYY')),
                              DropdownMenuItem(
                                  value: 'MM/DD/YYYY',
                                  child: Text('MM/DD/YYYY')),
                              DropdownMenuItem(
                                  value: 'YYYY-MM-DD',
                                  child: Text('YYYY-MM-DD')),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        _buildSettingItem(
                          'Default Status for New Orphans',
                          'Set the default status when adding new orphan records',
                          DropdownButton<String>(
                            value: 'Active',
                            items: const [
                              DropdownMenuItem(
                                  value: 'Active', child: Text('Active')),
                              DropdownMenuItem(
                                  value: 'Pending',
                                  child: Text('Pending Review')),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        _buildSwitchSetting(
                          'Auto-save Forms',
                          'Automatically save form data while editing',
                          true,
                          (value) {},
                        ),
                        _buildSwitchSetting(
                          'Show Confirmation Dialogs',
                          'Ask for confirmation before deleting records',
                          true,
                          (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Data Management Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.storage, color: Colors.green[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Data Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Database Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '/Users/Documents/OrphanHQ/database.sqlite',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.folder_open, size: 16),
                              label: const Text('Change Location'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildActionButton(
                              'Backup Database',
                              'Create a backup of all data',
                              Icons.backup,
                              Colors.blue,
                              () {},
                            ),
                            const SizedBox(width: 16),
                            _buildActionButton(
                              'Import Data',
                              'Import data from backup file',
                              Icons.upload_file,
                              Colors.green,
                              () {},
                            ),
                            const SizedBox(width: 16),
                            _buildActionButton(
                              'Clear Cache',
                              'Clear temporary files and cache',
                              Icons.cleaning_services,
                              Colors.orange,
                              () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.blue[600] : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.blue[700] : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildSettingItem(String title, String description, Widget control) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          control,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
      String title, String description, bool value, Function(bool) onChanged) {
    return _buildSettingItem(
      title,
      description,
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[600],
      ),
    );
  }

  Widget _buildActionButton(String title, String description, IconData icon,
      Color color, VoidCallback onPressed) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
