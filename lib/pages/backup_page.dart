import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  List<BackupInfo> _backups = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final backups = await BackupService.listBackups();
      setState(() {
        _backups = backups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading backups: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating backup...';
    });

    try {
      final backupPath = await BackupService.createBackup(
        onProgress: (message) {
          setState(() {
            _statusMessage = message;
          });
        },
      );

      if (backupPath != null) {
        setState(() {
          _statusMessage = 'Backup created successfully!';
        });
        await _loadBackups();
        _showSuccessDialog(
            'Backup Created', 'Your data has been backed up successfully.');
      } else {
        setState(() {
          _statusMessage = 'Failed to create backup';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error creating backup: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      _clearStatusAfterDelay();
    }
  }

  Future<void> _exportBackup() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Exporting backup...';
    });

    try {
      final backupPath = await BackupService.exportBackup(
        onProgress: (message) {
          setState(() {
            _statusMessage = message;
          });
        },
      );

      if (backupPath != null) {
        setState(() {
          _statusMessage = 'Backup exported successfully!';
        });
        _showSuccessDialog('Export Complete',
            'Backup has been saved to your chosen location.');
      } else {
        setState(() {
          _statusMessage = 'Export cancelled';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error exporting backup: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      _clearStatusAfterDelay();
    }
  }

  Future<void> _importBackup() async {
    final confirmed = await _showConfirmationDialog(
      'Import Backup',
      'This will replace all current data with the backup data. '
          'A safety backup of your current data will be created first. '
          'Are you sure you want to continue?',
      'Import',
      Colors.orange,
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Importing backup...';
    });

    try {
      final success = await BackupService.importBackup(
        onProgress: (message) {
          setState(() {
            _statusMessage = message;
          });
        },
      );

      if (success) {
        setState(() {
          _statusMessage = 'Backup imported successfully!';
        });
        _showRestartDialog();
      } else {
        setState(() {
          _statusMessage = 'Import cancelled or failed';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error importing backup: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restoreBackup(BackupInfo backup) async {
    final confirmed = await _showConfirmationDialog(
      'Restore Backup',
      'This will replace all current data with the backup from ${backup.createdAt.toString().split('.')[0]}. '
          'A safety backup of your current data will be created first. '
          'Are you sure you want to continue?',
      'Restore',
      Colors.orange,
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Restoring backup...';
    });

    try {
      final success = await BackupService.restoreBackup(
        backup.path,
        onProgress: (message) {
          setState(() {
            _statusMessage = message;
          });
        },
      );

      if (success) {
        setState(() {
          _statusMessage = 'Backup restored successfully!';
        });
        _showRestartDialog();
      } else {
        setState(() {
          _statusMessage = 'Failed to restore backup';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error restoring backup: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBackup(BackupInfo backup) async {
    final confirmed = await _showConfirmationDialog(
      'Delete Backup',
      'Are you sure you want to delete backup "${backup.name}"?',
      'Delete',
      Colors.red,
    );

    if (confirmed == true) {
      final success = await BackupService.deleteBackup(backup.path);
      if (success) {
        await _loadBackups();
        setState(() {
          _statusMessage = 'Backup deleted successfully';
        });
        _clearStatusAfterDelay();
      } else {
        setState(() {
          _statusMessage = 'Failed to delete backup';
        });
      }
    }
  }

  Future<bool?> _showConfirmationDialog(
    String title,
    String content,
    String confirmText,
    Color confirmColor,
  ) async {
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

  void _showRestartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restart Required'),
        content: const Text(
          'The operation completed successfully. Please restart the application to see the changes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
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
              IconButton(
                onPressed: () => context.go('/settings'),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Backup & Restore',
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

        // Content
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Backup Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _createBackup,
                              icon: const Icon(Icons.save),
                              label: const Text('Create Backup'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF238636), // GitHub green
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _exportBackup,
                              icon: const Icon(Icons.upload),
                              label: const Text('Export Backup'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0969DA), // GitHub blue
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _importBackup,
                              icon: const Icon(Icons.download),
                              label: const Text('Import Backup'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFD1242F), // GitHub orange/red
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Backups list
                Expanded(
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Available Backups',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _backups.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.backup,
                                        size: 64,
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color
                                            ?.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No backups found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Create your first backup using the button above',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _backups.length,
                                  itemBuilder: (context, index) {
                                    final backup = _backups[index];
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.archive,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        title: Text(
                                          backup.name,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Created: ${backup.createdAt.toString().split('.')[0]}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color,
                                              ),
                                            ),
                                            Text(
                                              'Size: ${backup.formattedSize}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : () =>
                                                      _restoreBackup(backup),
                                              icon: Icon(
                                                Icons.restore,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              tooltip: 'Restore',
                                            ),
                                            IconButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : () => _deleteBackup(backup),
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors
                                                    .red, // Keep red for danger action
                                              ),
                                              tooltip: 'Delete',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
