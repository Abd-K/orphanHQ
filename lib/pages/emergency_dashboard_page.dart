import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';
import 'dart:io';

enum EmergencyFilter { none, missing, unsupervised, both }

class EmergencyDashboardPage extends StatefulWidget {
  const EmergencyDashboardPage({super.key});

  @override
  State<EmergencyDashboardPage> createState() => _EmergencyDashboardPageState();
}

class _EmergencyDashboardPageState extends State<EmergencyDashboardPage> {
  EmergencyFilter _currentFilter = EmergencyFilter.none;

  void _onFilterTap(EmergencyFilter filter) {
    setState(() {
      if (_currentFilter == filter) {
        // If same filter is clicked, turn it off (go to none)
        _currentFilter = EmergencyFilter.none;
      } else {
        // Otherwise, set the clicked filter (only one at a time)
        _currentFilter = filter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();
    final supervisorRepository = context.watch<SupervisorRepository>();

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
                  'Emergency Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
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
            builder: (context, orphanSnapshot) {
              if (orphanSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!orphanSnapshot.hasData || orphanSnapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }

              return StreamBuilder<List<Supervisor>>(
                stream: supervisorRepository.watchAllSupervisors(),
                builder: (context, supervisorSnapshot) {
                  if (supervisorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orphans = orphanSnapshot.data!;
                  final supervisors = supervisorSnapshot.data ?? [];
                  final inactiveSupervisors =
                      supervisors.where((s) => !(s.active ?? true)).toList();
                  final inactiveSupervisorIds =
                      inactiveSupervisors.map((s) => s.supervisorId).toSet();

                  final missingOrphans = orphans
                      .where((o) => o.status == OrphanStatus.missing)
                      .toList();

                  final orphansWithInactiveSupervisors = orphans
                      .where((o) =>
                          o.supervisorId != null &&
                          inactiveSupervisorIds.contains(o.supervisorId))
                      .toList();

                  final orphansWithNoSupervisor =
                      orphans.where((o) => o.supervisorId == null).toList();

                  // Combine both types of unsupervised cases
                  final unsupervisedOrphans = [
                    ...orphansWithInactiveSupervisors,
                    ...orphansWithNoSupervisor,
                  ];

                  // Combine all emergency cases (avoid duplicates)
                  final allEmergencyOrphans = <Orphan>[
                    ...missingOrphans,
                    ...unsupervisedOrphans
                        .where((orphan) => !missingOrphans.contains(orphan)),
                  ];

                  return _buildEmergencyDashboard(
                      context,
                      missingOrphans,
                      orphansWithInactiveSupervisors,
                      orphans,
                      inactiveSupervisors,
                      unsupervisedOrphans,
                      allEmergencyOrphans);
                },
              );
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
            Icons.warning,
            size: 80,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No emergency data',
            style: TextStyle(
              fontSize: 24,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All orphans are accounted for',
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyDashboard(
      BuildContext context,
      List<Orphan> missingOrphans,
      List<Orphan> orphansWithInactiveSupervisors,
      List<Orphan> allOrphans,
      List<Supervisor> inactiveSupervisors,
      List<Orphan> unsupervisedOrphans,
      List<Orphan> allEmergencyOrphans) {
    // Filter orphans based on current filter
    List<Orphan> filteredOrphans;
    String filterTitle;

    switch (_currentFilter) {
      case EmergencyFilter.missing:
        filteredOrphans = missingOrphans;
        filterTitle = 'Missing Orphans';
        break;
      case EmergencyFilter.unsupervised:
        filteredOrphans = unsupervisedOrphans;
        filterTitle = 'Unsupervised Orphans';
        break;
      case EmergencyFilter.both:
        // Remove the 'both' case since we only allow one filter at a time
        filteredOrphans = allEmergencyOrphans;
        filterTitle = 'Emergency Cases';
        break;
      case EmergencyFilter.none:
      default:
        filteredOrphans = allEmergencyOrphans;
        filterTitle = 'Emergency Cases';
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Stats
          Row(
            children: [
              _buildEmergencyStatCard(
                'Missing Orphans',
                missingOrphans.length.toString(),
                Icons.warning,
                Colors.red,
                isEmergency: missingOrphans.isNotEmpty,
                isClickable: true,
                isActive: _currentFilter == EmergencyFilter.missing,
                onTap: () => _onFilterTap(EmergencyFilter.missing),
              ),
              const SizedBox(width: 16),
              _buildEmergencyStatCard(
                'Unsupervised Orphans',
                unsupervisedOrphans.length.toString(),
                Icons.child_care,
                Colors.orange,
                isEmergency: unsupervisedOrphans.isNotEmpty,
                isClickable: true,
                isActive: _currentFilter == EmergencyFilter.unsupervised,
                onTap: () => _onFilterTap(EmergencyFilter.unsupervised),
              ),
              const SizedBox(width: 16),
              _buildEmergencyStatCard(
                'Inactive Supervisors',
                inactiveSupervisors.length.toString(),
                Icons.person_off,
                Colors.blue,
                isEmergency: inactiveSupervisors.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter indicator
          if (_currentFilter != EmergencyFilter.none)
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
                    'Showing $filterTitle (${filteredOrphans.length})',
                    style: TextStyle(
                      color: _getFilterColor(_currentFilter),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _currentFilter = EmergencyFilter.none),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: _getFilterColor(_currentFilter),
                    ),
                  ),
                ],
              ),
            ),

          // Emergency Cases List
          if (filteredOrphans.isNotEmpty) ...[
            Text(
              '$filterTitle (${filteredOrphans.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.red[300]!),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrphans.length,
                  itemBuilder: (context, index) {
                    final orphan = filteredOrphans[index];
                    return _buildEmergencyOrphanCard(
                        context,
                        orphan,
                        missingOrphans,
                        inactiveSupervisors,
                        unsupervisedOrphans);
                  },
                ),
              ),
            ),
          ] else ...[
            // All Clear Message or No Results
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        _currentFilter == EmergencyFilter.none
                            ? Icons.check_circle
                            : _getFilterIcon(_currentFilter),
                        size: 80,
                        color: _currentFilter == EmergencyFilter.none
                            ? Colors.green[400]
                            : Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      _currentFilter == EmergencyFilter.none
                          ? 'All Clear!'
                          : 'No ${_getFilterName(_currentFilter)} found',
                      style: TextStyle(
                          fontSize: 24,
                          color: _currentFilter == EmergencyFilter.none
                              ? Colors.green[600]
                              : Theme.of(context).textTheme.titleMedium?.color,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentFilter == EmergencyFilter.none
                          ? 'All orphans are accounted for and safe'
                          : 'Try selecting a different filter or clear the current filter',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    if (_currentFilter != EmergencyFilter.none) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => setState(
                            () => _currentFilter = EmergencyFilter.none),
                        child: const Text('Show All Emergency Cases'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getFilterColor(EmergencyFilter filter) {
    switch (filter) {
      case EmergencyFilter.missing:
        return Colors.red;
      case EmergencyFilter.unsupervised:
        return Colors.orange;
      case EmergencyFilter.both:
        return Colors.purple;
      case EmergencyFilter.none:
      default:
        return Colors.grey;
    }
  }

  IconData _getFilterIcon(EmergencyFilter filter) {
    switch (filter) {
      case EmergencyFilter.missing:
        return Icons.warning;
      case EmergencyFilter.unsupervised:
        return Icons.child_care;
      case EmergencyFilter.both:
        return Icons.crisis_alert;
      case EmergencyFilter.none:
      default:
        return Icons.check_circle;
    }
  }

  String _getFilterName(EmergencyFilter filter) {
    switch (filter) {
      case EmergencyFilter.missing:
        return 'missing orphans';
      case EmergencyFilter.unsupervised:
        return 'unsupervised orphans';
      case EmergencyFilter.both:
        return 'missing & unsupervised orphans';
      case EmergencyFilter.none:
      default:
        return 'emergency cases';
    }
  }

  // Helper method to extract recent photo from documentsPath
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
          return file.existsSync() ? file : null;
        }
      }
    } catch (e) {
      print('Error extracting recent photo: $e');
    }
    return null;
  }

  Widget _buildEmergencyStatCard(
      String title, String value, IconData icon, Color color,
      {bool isEmergency = false,
      bool isClickable = false,
      bool isActive = false,
      VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: const EdgeInsets.all(20),
      decoration: isEmergency
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(isDark ? 0.15 : 0.1),
                  color.withOpacity(isDark ? 0.1 : 0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(isActive ? 0.2 : (isDark ? 0.15 : 0.1)),
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
                    color: (isEmergency || isActive)
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
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
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
    );

    return Expanded(
      child: isClickable
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? color
                          : (isEmergency ? color : theme.dividerColor),
                      width: isActive ? 2 : 1,
                    ),
                    color: isActive
                        ? color.withOpacity(isDark ? 0.15 : 0.05)
                        : theme.cardColor,
                  ),
                  child: cardContent,
                ),
              ),
            )
          : Card(
              elevation: isEmergency ? 4 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isEmergency ? color : theme.dividerColor,
                ),
              ),
              child: cardContent,
            ),
    );
  }

  Widget _buildMissingOrphanCard(BuildContext context, Orphan orphan) {
    File? recentPhoto = _getOrphanRecentPhoto(orphan);

    // Generate initials for fallback
    String initials = '';
    if (orphan.firstName.isNotEmpty) {
      initials += orphan.firstName[0];
    }
    if (orphan.fatherName.isNotEmpty) {
      initials += orphan.fatherName[0];
    }
    if (initials.isEmpty) initials = '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.red[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
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
                  backgroundColor: Colors.red[100],
                  child: Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        title: Text(
          '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
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
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'INACTIVE SUPERVISOR',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (orphan.supervisorId != null)
                  Text(
                    'Supervisor ID: ${orphan.supervisorId}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => context.push('/orphan/${orphan.orphanId}'),
        ),
        onTap: () => context.push('/orphan/${orphan.orphanId}'),
      ),
    );
  }

  Widget _buildEmergencyOrphanCard(
      BuildContext context,
      Orphan orphan,
      List<Orphan> missingOrphans,
      List<Supervisor> inactiveSupervisors,
      List<Orphan> unsupervisedOrphans) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMissing = missingOrphans.contains(orphan);
    final isUnsupervised = unsupervisedOrphans.contains(orphan);
    final inactiveSupervisorIds =
        inactiveSupervisors.map((s) => s.supervisorId).toSet();
    final hasInactiveSupervisor = orphan.supervisorId != null &&
        inactiveSupervisorIds.contains(orphan.supervisorId);
    final primaryColor = isMissing
        ? Colors.red
        : (isUnsupervised ? Colors.orange : Colors.orange);

    File? recentPhoto = _getOrphanRecentPhoto(orphan);

    // Generate initials for fallback
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
            ? const Color(0xFF21262D) // Slightly different from card color
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? primaryColor.withOpacity(0.5) : primaryColor[200]!,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
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
                  backgroundColor: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  child: Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        title: Text(
          '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (isMissing)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'MISSING',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (hasInactiveSupervisor)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'INACTIVE SUPERVISOR',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (isMissing &&
                orphan.lastSeenLocation != null &&
                orphan.lastSeenLocation!.isNotEmpty)
              Text(
                'Last seen: ${orphan.lastSeenLocation}',
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
            if (hasInactiveSupervisor && orphan.supervisorId != null)
              Builder(
                builder: (context) {
                  final supervisor = inactiveSupervisors.firstWhere(
                    (s) => s.supervisorId == orphan.supervisorId,
                    orElse: () => Supervisor(
                      supervisorId: '',
                      firstName: 'Unknown',
                      lastName: '',
                      familyName: 'Supervisor',
                      phoneNumber: '',
                      publicKey: '',
                      address: '',
                      city: '',
                      position: '',
                      dateJoined: DateTime.now(),
                      active: false,
                    ),
                  );
                  return Text(
                    'Supervisor: ${supervisor.firstName} ${supervisor.familyName}',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  );
                },
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.iconTheme.color,
          ),
          onPressed: () => context.push('/orphan/${orphan.orphanId}'),
        ),
        onTap: () => context.push('/orphan/${orphan.orphanId}'),
      ),
    );
  }
}
