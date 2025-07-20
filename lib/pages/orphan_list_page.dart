import 'dart:async'; // Added for the debounce timer
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';
import 'dart:io';

enum OrphanFilter { all, active, missing }

class OrphanListPage extends StatefulWidget {
  const OrphanListPage({super.key});

  @override
  State<OrphanListPage> createState() => _OrphanListPageState();
}

class _OrphanListPageState extends State<OrphanListPage> {
  OrphanFilter _currentFilter = OrphanFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce; // --- Start of new code ---

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  } // --- End of new code ---

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();

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
              // Page Title
              Expanded(
                child: Text(
                  'Orphans',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
              ),

              // Page Actions
              ElevatedButton.icon(
                onPressed: () => context.push('/onboard'),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Orphan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).brightness ==
                      Brightness.dark
                      ? const Color(0xFF4CAF50) // Green for dark mode
                      : const Color(0xFF2E7D32), // Darker green for light mode
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black26,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Page Content
        Expanded(
          child: StreamBuilder<List<Orphan>>(
            stream: orphanRepository.getAllOrphans(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }

              final orphans = snapshot.data!;
              return _buildOrphanGrid(context, orphans, supervisorRepository);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care,
            size: 80,
            color: theme.iconTheme.color?.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No orphans found',
            style: TextStyle(
              fontSize: 24,
              color: theme.textTheme.headlineMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get started by adding your first orphan',
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/onboard'),
            icon: const Icon(Icons.person_add),
            label: const Text('Add First Orphan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF4CAF50) // Green for dark mode
                  : const Color(0xFF2E7D32), // Darker green for light mode
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black26,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanGrid(BuildContext context, List<Orphan> orphans,
      SupervisorRepository supervisorRepository) {
    // --- Start of modified code ---
    final filteredOrphans = orphans.where((orphan) {
      switch (_currentFilter) {
        case OrphanFilter.active:
          return orphan.status == OrphanStatus.active;
        case OrphanFilter.missing:
          return orphan.status == OrphanStatus.missing;
        case OrphanFilter.all:
        default:
          return true;
      }
    }).toList();

    final searchedOrphans = _searchQuery.isEmpty
        ? filteredOrphans
        : filteredOrphans.where((orphan) {
      final fullName =
      '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}'
          .toLowerCase();
      return fullName.contains(_searchQuery.toLowerCase());
    }).toList();
    // --- End of modified code ---

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              _buildStatCard(
                'Total Orphans',
                orphans.length.toString(),
                Icons.child_care,
                Colors.blue,
                OrphanFilter.all,
                _currentFilter == OrphanFilter.all,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Missing',
                orphans
                    .where((o) => o.status == OrphanStatus.missing)
                    .length
                    .toString(),
                Icons.warning,
                Colors.red,
                OrphanFilter.missing,
                _currentFilter == OrphanFilter.missing,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Active',
                orphans
                    .where((o) => o.status == OrphanStatus.active)
                    .length
                    .toString(),
                Icons.check_circle,
                Colors.green,
                OrphanFilter.active,
                _currentFilter == OrphanFilter.active,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Orphans',
                hintText: 'Enter orphan name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Filter indicator
          if (_currentFilter != OrphanFilter.all)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _getFilterColor(_currentFilter).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getFilterColor(_currentFilter).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getFilterIcon(_currentFilter),
                    size: 16,
                    color: _getFilterColor(_currentFilter),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${_getFilterName(_currentFilter)} orphans (${filteredOrphans.length})',
                    style: TextStyle(
                      color: _getFilterColor(_currentFilter),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _currentFilter = OrphanFilter.all),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: _getFilterColor(_currentFilter),
                    ),
                  ),
                ],
              ),
            ),

          // Orphans List
          Expanded(
            child: Card(
              child: searchedOrphans.isEmpty
                  ? _buildNoResultsState()
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchedOrphans.length,
                itemBuilder: (context, index) {
                  final orphan = searchedOrphans[index];
                  return _buildOrphanCard(context, orphan);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    final theme = Theme.of(context);
    final isSearching = _searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : _getFilterIcon(_currentFilter),
            size: 64,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No Orphans Found'
                : 'No ${_getFilterName(_currentFilter).toLowerCase()} orphans found',
            style: TextStyle(
              fontSize: 18,
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Try a different search term.'
                : 'Try selecting a different filter',
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _currentFilter = OrphanFilter.all),
              child: const Text('Show All Orphans'),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      OrphanFilter filter,
      bool isActive,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (filter == OrphanFilter.all) {
                _currentFilter = OrphanFilter.all;
              } else if (_currentFilter == filter) {
                _currentFilter = OrphanFilter.all;
              } else {
                _currentFilter = filter;
              }
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? color : theme.dividerColor,
                width: isActive ? 2 : 1,
              ),
              color: isActive
                  ? color.withOpacity(isDark ? 0.15 : 0.05)
                  : theme.cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color
                          .withOpacity(isActive ? 0.2 : (isDark ? 0.15 : 0.1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? color
                                : theme.textTheme.headlineMedium?.color,
                          ),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: isActive
                                ? color.withOpacity(0.8)
                                : theme.textTheme.bodySmall?.color,
                            fontWeight:
                            isActive ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Icon(
                      Icons.check_circle,
                      color: color,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getFilterColor(OrphanFilter filter) {
    switch (filter) {
      case OrphanFilter.active:
        return Colors.green;
      case OrphanFilter.missing:
        return Colors.red;
      case OrphanFilter.all:
      default:
        return Colors.blue;
    }
  }

  IconData _getFilterIcon(OrphanFilter filter) {
    switch (filter) {
      case OrphanFilter.active:
        return Icons.check_circle;
      case OrphanFilter.missing:
        return Icons.warning;
      case OrphanFilter.all:
      default:
        return Icons.child_care;
    }
  }

  String _getFilterName(OrphanFilter filter) {
    switch (filter) {
      case OrphanFilter.active:
        return 'Active';
      case OrphanFilter.missing:
        return 'Missing';
      case OrphanFilter.all:
      default:
        return 'All';
    }
  }

  Widget _buildOrphanCard(BuildContext context, Orphan orphan) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color statusColor = _getStatusColor(orphan.status);
    File? recentPhoto = _getOrphanRecentPhoto(orphan);

    String initials = '';
    if (orphan.firstName.isNotEmpty) {
      initials += orphan.firstName[0];
    }
    if (orphan.fatherName.isNotEmpty) {
      initials += orphan.fatherName[0];
    }
    if (initials.isEmpty) initials = '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF21262D)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: recentPhoto != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              recentPhoto,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          )
              : CircleAvatar(
            backgroundColor: statusColor.withOpacity(isDark ? 0.2 : 0.1),
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          '${orphan.firstName.isNotEmpty ? orphan.firstName : 'Unknown'} ${orphan.fatherName.isNotEmpty ? orphan.fatherName : ''} ${orphan.grandfatherName.isNotEmpty ? orphan.grandfatherName : ''} ${orphan.familyName.isNotEmpty ? orphan.familyName : ''}'
              .trim(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    orphan.status.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Age: ${_calculateAge(orphan.dateOfBirth)} years',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => context.push('/orphan/${orphan.orphanId}'),
      ),
    );
  }

  Color _getStatusColor(OrphanStatus status) {
    switch (status) {
      case OrphanStatus.active:
        return Colors.green;
      case OrphanStatus.missing:
        return Colors.red;
      case OrphanStatus.found:
        return Colors.blue;
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  File? _getOrphanRecentPhoto(Orphan orphan) {
    if (orphan.documentsPath == null || orphan.documentsPath!.isEmpty) {
      return null;
    }

    try {
      final documentEntries = orphan.documentsPath!.split(',');
      for (final entry in documentEntries) {
        final parts = entry.split(':');
        if (parts.length == 2 && parts[0] == 'recent') {
          final file = File(parts[1]);
          if (file.existsSync()) {
            final extension = file.path.split('.').last.toLowerCase();
            if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
                .contains(extension)) {
              return file;
            }
          }
        }
      }
    } catch (e) {
      print('Error extracting recent photo: $e');
    }
    return null;
  }
}