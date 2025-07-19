import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

class OrphanDetailsPage extends StatelessWidget {
  final String orphanId;

  const OrphanDetailsPage({super.key, required this.orphanId});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphan Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // We'll implement delete from details page
            },
            tooltip: 'Delete Orphan',
          ),
        ],
      ),
      body: StreamBuilder<List<Orphan>>(
        stream: orphanRepository.getAllOrphans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final orphan =
              snapshot.data!.where((o) => o.orphanId == orphanId).firstOrNull;

          if (orphan == null) {
            return const Center(child: Text('Orphan not found'));
          }

          return FutureBuilder<List<Supervisor>>(
            future: supervisorRepository.getAllSupervisors(),
            builder: (context, supervisorSnapshot) {
              final supervisor = supervisorSnapshot.data
                  ?.where((s) => s.supervisorId == orphan.supervisorId)
                  .firstOrNull;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orphan.fullName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Date of Birth',
                                '${orphan.dateOfBirth.day.toString().padLeft(2, '0')}/${orphan.dateOfBirth.month.toString().padLeft(2, '0')}/${orphan.dateOfBirth.year}'),
                            _buildDetailRow(
                                'Status',
                                orphan.status
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase()),
                            _buildDetailRow('Last Seen Location',
                                orphan.lastSeenLocation ?? 'Not specified'),
                            _buildDetailRow('Last Updated',
                                '${orphan.lastUpdated.day.toString().padLeft(2, '0')}/${orphan.lastUpdated.month.toString().padLeft(2, '0')}/${orphan.lastUpdated.year}'),
                            _buildDetailRow('Supervisor',
                                supervisor?.fullName ?? 'Unknown'),
                            if (supervisor != null) ...[
                              _buildDetailRow(
                                  'Supervisor Contact', supervisor.contactInfo),
                              _buildDetailRow(
                                  'Supervisor Location', supervisor.location),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (orphan.status == OrphanStatus.missing)
                      ElevatedButton.icon(
                        onPressed: () {
                          orphanRepository.updateOrphanStatus(
                              orphan.orphanId, OrphanStatus.found);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${orphan.fullName} marked as found')),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Found'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
