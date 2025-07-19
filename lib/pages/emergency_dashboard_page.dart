import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/layouts/desktop_layout.dart';
import 'package:provider/provider.dart';

class EmergencyDashboardPage extends StatelessWidget {
  const EmergencyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();

    return DesktopLayout(
      currentRoute: '/emergency',
      pageTitle: 'Emergency Dashboard',
      actions: [
        // Emergency-specific action
        ElevatedButton.icon(
          onPressed: () {
            // Could add functionality to export emergency report
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Emergency report feature coming soon')),
            );
          },
          icon: const Icon(Icons.file_download),
          label: const Text('Export Report'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
      child: StreamBuilder<List<Orphan>>(
        stream: orphanRepository.getMissingOrphans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
          }

          final orphans = snapshot.data!;
          return _buildEmergencyContent(context, orphans, orphanRepository);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green[400]),
          const SizedBox(height: 16),
          Text(
            'No Emergency Cases',
            style: TextStyle(fontSize: 24, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'All orphans are accounted for',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContent(BuildContext context, List<Orphan> orphans,
      OrphanRepository orphanRepository) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Stats
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.red[200]!),
            ),
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(Icons.warning, color: Colors.red[700], size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${orphans.length}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        Text(
                          'Missing Orphans Requiring Immediate Attention',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Missing Orphans List
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.list, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Missing Orphans',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orphans.length,
                      itemBuilder: (context, index) {
                        final orphan = orphans[index];
                        return _buildEmergencyOrphanCard(
                            context, orphan, orphanRepository);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOrphanCard(
      BuildContext context, Orphan orphan, OrphanRepository orphanRepository) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.red[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Urgency indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),

            // Orphan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        orphan.lastSeenLocation ?? 'No location specified',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Last updated: ${_formatDate(orphan.lastUpdated)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action button
            ElevatedButton.icon(
              onPressed: () {
                orphanRepository.updateOrphanStatus(
                    orphan.orphanId, OrphanStatus.found);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${orphan.firstName} marked as found'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Mark as Found'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
