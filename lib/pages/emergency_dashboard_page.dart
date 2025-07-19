import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:provider/provider.dart';

class EmergencyDashboardPage extends StatelessWidget {
  const EmergencyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();

    return Column(
      children: [
        // Action Bar
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Page Title
              const Expanded(
                child: Text(
                  'Emergency Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Page Actions
              ElevatedButton.icon(
                onPressed: () => context.push('/emergency-report'),
                icon: const Icon(Icons.report),
                label: const Text('Report Emergency'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              final missingOrphans = orphans
                  .where((o) => o.status == OrphanStatus.missing)
                  .toList();

              return _buildEmergencyDashboard(context, missingOrphans, orphans);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No emergency data',
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

  Widget _buildEmergencyDashboard(BuildContext context,
      List<Orphan> missingOrphans, List<Orphan> allOrphans) {
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
              ),
              const SizedBox(width: 16),
              _buildEmergencyStatCard(
                'Total Orphans',
                allOrphans.length.toString(),
                Icons.child_care,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildEmergencyStatCard(
                'Active Orphans',
                allOrphans
                    .where((o) => o.status == OrphanStatus.active)
                    .length
                    .toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Missing Orphans List
          if (missingOrphans.isNotEmpty) ...[
            Text(
              'Missing Orphans (${missingOrphans.length})',
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
                  itemCount: missingOrphans.length,
                  itemBuilder: (context, index) {
                    final orphan = missingOrphans[index];
                    return _buildMissingOrphanCard(context, orphan);
                  },
                ),
              ),
            ),
          ] else ...[
            // All Clear Message
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        size: 80, color: Colors.green[400]),
                    const SizedBox(height: 16),
                    Text(
                      'All Clear!',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All orphans are accounted for and safe',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyStatCard(
      String title, String value, IconData icon, Color color,
      {bool isEmergency = false}) {
    return Expanded(
      child: Card(
        elevation: isEmergency ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isEmergency ? color : Colors.grey[300]!),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: isEmergency
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
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
                  color: color.withOpacity(0.1),
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
                        color: isEmergency ? color : null,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingOrphanCard(BuildContext context, Orphan orphan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.red[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.red[100],
          child: Text(
            '${orphan.firstName.isNotEmpty ? orphan.firstName[0] : '?'}${orphan.familyName.isNotEmpty ? orphan.familyName[0] : '?'}',
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
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
                    'MISSING',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (orphan.lastSeenLocation != null &&
                    orphan.lastSeenLocation!.isNotEmpty)
                  Text(
                    'Last seen: ${orphan.lastSeenLocation}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
}
