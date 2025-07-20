import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:provider/provider.dart';

class SupervisorDetailsPage extends StatelessWidget {
  final String supervisorId;

  const SupervisorDetailsPage({super.key, required this.supervisorId});

  @override
  Widget build(BuildContext context) {
    final supervisorRepository = context.watch<SupervisorRepository>();
    final orphanRepository = context.watch<OrphanRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Details'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmation(context, supervisorRepository);
            },
            tooltip: 'Delete Supervisor',
          ),
        ],
      ),
      body: FutureBuilder<List<Supervisor>>(
        future: supervisorRepository.getAllSupervisors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final supervisor = snapshot.data?.firstWhere(
            (s) => s.supervisorId == supervisorId,
            orElse: () => throw Exception('Supervisor not found'),
          );

          if (supervisor == null) {
            return const Center(child: Text('Supervisor not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, supervisor),
                const SizedBox(height: 16),
                _buildContactCard(context, supervisor),
                const SizedBox(height: 16),
                _buildProfessionalCard(context, supervisor),
                const SizedBox(height: 16),
                _buildAssignedOrphansCard(context, orphanRepository),
                if (supervisor.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  _buildNotesCard(context, supervisor),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Supervisor supervisor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade600,
              child: Text(
                SupervisorRepository.getFullName(supervisor)
                    .split(' ')
                    .map((name) => name.isNotEmpty ? name[0] : '')
                    .take(2)
                    .join()
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              SupervisorRepository.getFullName(supervisor),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              supervisor.position,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (supervisor.organization?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                supervisor.organization!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white60
                      : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Supervisor supervisor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
                context, Icons.phone, 'Phone', supervisor.phoneNumber),
            if (supervisor.email?.isNotEmpty == true)
              _buildInfoRow(context, Icons.email, 'Email', supervisor.email!),
            if (supervisor.alternateContact?.isNotEmpty == true)
              _buildInfoRow(context, Icons.contact_phone, 'Alternate Contact',
                  supervisor.alternateContact!),
            _buildInfoRow(
                context, Icons.location_on, 'Address', supervisor.address),
            _buildInfoRow(
                context, Icons.location_city, 'City', supervisor.city),
            if (supervisor.district?.isNotEmpty == true)
              _buildInfoRow(
                  context, Icons.map, 'District', supervisor.district!),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalCard(BuildContext context, Supervisor supervisor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(context, Icons.work, 'Position', supervisor.position),
            if (supervisor.organization?.isNotEmpty == true)
              _buildInfoRow(context, Icons.business, 'Organization',
                  supervisor.organization!),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Date Joined',
              '${supervisor.dateJoined.day}/${supervisor.dateJoined.month}/${supervisor.dateJoined.year}',
            ),
            _buildInfoRow(
              context,
              Icons.check_circle,
              'Status',
              supervisor.active ? 'Active' : 'Inactive',
              valueColor: supervisor.active ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedOrphansCard(
      BuildContext context, OrphanRepository orphanRepository) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned Orphans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<Orphan>>(
              stream: orphanRepository.getOrphansBySupervisor(supervisorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    'No orphans assigned to this supervisor',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white60
                          : Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                final orphans = snapshot.data!;
                return Column(
                  children: [
                    Text(
                      '${orphans.length} orphan${orphans.length != 1 ? 's' : ''} assigned',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...orphans.map((orphan) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                '${orphan.firstName.isNotEmpty ? orphan.firstName[0] : '?'}${orphan.fatherName.isNotEmpty ? orphan.fatherName[0] : '?'}'
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '${orphan.firstName.isNotEmpty ? orphan.firstName : 'Unknown'} ${orphan.fatherName.isNotEmpty ? orphan.fatherName : ''} ${orphan.grandfatherName.isNotEmpty ? orphan.grandfatherName : ''} ${orphan.familyName.isNotEmpty ? orphan.familyName : ''}'
                                  .trim(),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${orphan.status.toString().split('.').last}',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              context.push('/orphan/${orphan.orphanId}');
                            },
                          ),
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, Supervisor supervisor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              supervisor.notes!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87),
                fontWeight:
                    valueColor != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, SupervisorRepository supervisorRepository) async {
    // First get the supervisor data
    final supervisors = await supervisorRepository.getAllSupervisors();
    final supervisor = supervisors.firstWhere(
      (s) => s.supervisorId == supervisorId,
      orElse: () => throw Exception('Supervisor not found'),
    );

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supervisor'),
        content: Text(
            'Are you sure you want to delete ${SupervisorRepository.getFullName(supervisor)}? This action cannot be undone and will affect any associated orphans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await supervisorRepository
                    .deleteSupervisor(supervisor.supervisorId);
                Navigator.of(context).pop(); // Close dialog
                context.pop(); // Go back to supervisor list
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '${SupervisorRepository.getFullName(supervisor)} deleted successfully')));
              } catch (e) {
                print('Error deleting supervisor: $e');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete supervisor: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
