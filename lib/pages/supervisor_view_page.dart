import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

enum SupervisorFilter { all, active, inactive }

class SupervisorViewPage extends StatefulWidget {
  const SupervisorViewPage({super.key});

  @override
  State<SupervisorViewPage> createState() => _SupervisorViewPageState();
}

class _SupervisorViewPageState extends State<SupervisorViewPage> {
  SupervisorFilter _currentFilter = SupervisorFilter.all;

  @override
  Widget build(BuildContext context) {
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
                  'Supervisors',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
              ),

              // Page Actions
              ElevatedButton.icon(
                onPressed: () => context.push('/add-supervisor'),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Supervisor'),
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
          child: StreamBuilder<List<Supervisor>>(
            stream: supervisorRepository.watchAllSupervisors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }

              final supervisors = snapshot.data!;
              return _buildSupervisorGrid(context, supervisors);
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
            Icons.people,
            size: 80,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No supervisors found',
            style: TextStyle(
              fontSize: 24,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get started by adding your first supervisor',
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/add-supervisor'),
            icon: const Icon(Icons.person_add),
            label: const Text('Add First Supervisor'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorGrid(
      BuildContext context, List<Supervisor> supervisors) {
    // Filter supervisors based on current filter
    List<Supervisor> filteredSupervisors;
    switch (_currentFilter) {
      case SupervisorFilter.active:
        filteredSupervisors = supervisors.where((s) => s.active).toList();
        break;
      case SupervisorFilter.inactive:
        filteredSupervisors = supervisors.where((s) => !s.active).toList();
        break;
      case SupervisorFilter.all:
      default:
        filteredSupervisors = supervisors;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              _buildStatCard(
                'Total Supervisors',
                supervisors.length.toString(),
                Icons.people,
                Colors.blue,
                SupervisorFilter.all,
                _currentFilter == SupervisorFilter.all,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Active',
                supervisors.where((s) => s.active).length.toString(),
                Icons.check_circle,
                Colors.green,
                SupervisorFilter.active,
                _currentFilter == SupervisorFilter.active,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Inactive',
                supervisors.where((s) => !s.active).length.toString(),
                Icons.pause_circle,
                Colors.orange,
                SupervisorFilter.inactive,
                _currentFilter == SupervisorFilter.inactive,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter indicator
          if (_currentFilter != SupervisorFilter.all)
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
                    'Showing ${_getFilterName(_currentFilter)} supervisors (${filteredSupervisors.length})',
                    style: TextStyle(
                      color: _getFilterColor(_currentFilter),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _currentFilter = SupervisorFilter.all),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: _getFilterColor(_currentFilter),
                    ),
                  ),
                ],
              ),
            ),

          // Supervisors Grid
          Expanded(
            child: filteredSupervisors.isEmpty
                ? _buildNoResultsState()
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: filteredSupervisors.length,
                    itemBuilder: (context, index) {
                      final supervisor = filteredSupervisors[index];
                      return _buildSupervisorCard(context, supervisor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFilterIcon(_currentFilter),
            size: 64,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_getFilterName(_currentFilter).toLowerCase()} supervisors found',
            style: TextStyle(
              fontSize: 18,
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different filter',
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                setState(() => _currentFilter = SupervisorFilter.all),
            child: const Text('Show All Supervisors'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    SupervisorFilter filter,
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
              if (filter == SupervisorFilter.all) {
                // Always set to "all" when clicking the "all" button
                _currentFilter = SupervisorFilter.all;
              } else if (_currentFilter == filter) {
                // If same filter is clicked, turn it off (go to all)
                _currentFilter = SupervisorFilter.all;
              } else {
                // Otherwise, set the clicked filter
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

  Color _getFilterColor(SupervisorFilter filter) {
    switch (filter) {
      case SupervisorFilter.active:
        return Colors.green;
      case SupervisorFilter.inactive:
        return Colors.orange;
      case SupervisorFilter.all:
      default:
        return Colors.blue;
    }
  }

  IconData _getFilterIcon(SupervisorFilter filter) {
    switch (filter) {
      case SupervisorFilter.active:
        return Icons.check_circle;
      case SupervisorFilter.inactive:
        return Icons.pause_circle;
      case SupervisorFilter.all:
      default:
        return Icons.people;
    }
  }

  String _getFilterName(SupervisorFilter filter) {
    switch (filter) {
      case SupervisorFilter.active:
        return 'Active';
      case SupervisorFilter.inactive:
        return 'Inactive';
      case SupervisorFilter.all:
      default:
        return 'All';
    }
  }

  Widget _buildSupervisorCard(BuildContext context, Supervisor supervisor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color statusColor = _getStatusColor(supervisor.active);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF21262D) // Slightly different from card color
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : Colors.grey[200]!,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/supervisor/${supervisor.supervisorId}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        statusColor.withOpacity(isDark ? 0.2 : 0.1),
                    child: Text(
                      '${supervisor.firstName.isNotEmpty ? supervisor.firstName[0] : '?'}${supervisor.lastName.isNotEmpty ? supervisor.lastName[0] : '?'}',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${supervisor.firstName} ${supervisor.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          supervisor.phoneNumber,
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  supervisor.active ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(bool active) {
    return active ? Colors.green : Colors.orange;
  }
}
