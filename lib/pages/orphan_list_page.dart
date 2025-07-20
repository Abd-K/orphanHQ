import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/data_seeder.dart';
import 'package:provider/provider.dart';

class OrphanListPage extends StatelessWidget {
  const OrphanListPage({super.key});

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
                  'Orphans',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Page Actions
              OutlinedButton.icon(
                onPressed: () => _seedTestData(context),
                icon: const Icon(Icons.scatter_plot),
                label: const Text('Seed Test Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => context.push('/onboard'),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Orphan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
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
              return _buildOrphanGrid(context, orphans, supervisorRepository);
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
          Icon(Icons.child_care, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orphans found',
            style: TextStyle(fontSize: 24, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Get started by adding your first orphan',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/onboard'),
            icon: const Icon(Icons.person_add),
            label: const Text('Add First Orphan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanGrid(BuildContext context, List<Orphan> orphans,
      SupervisorRepository supervisorRepository) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              _buildStatCard('Total Orphans', orphans.length.toString(),
                  Icons.child_care, Colors.blue),
              const SizedBox(width: 16),
              _buildStatCard(
                  'Missing',
                  orphans
                      .where((o) => o.status == OrphanStatus.missing)
                      .length
                      .toString(),
                  Icons.warning,
                  Colors.red),
              const SizedBox(width: 16),
              _buildStatCard(
                  'Active',
                  orphans
                      .where((o) => o.status == OrphanStatus.active)
                      .length
                      .toString(),
                  Icons.check_circle,
                  Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          // Orphans List
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orphans.length,
                itemBuilder: (context, index) {
                  final orphan = orphans[index];
                  return _buildOrphanCard(context, orphan);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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

  Widget _buildOrphanCard(BuildContext context, Orphan orphan) {
    Color statusColor = _getStatusColor(orphan.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Text(
            '${orphan.firstName.isNotEmpty ? orphan.firstName[0] : '?'}${orphan.familyName.isNotEmpty ? orphan.familyName[0] : '?'}',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${orphan.firstName.isNotEmpty ? orphan.firstName : 'Unknown'} ${orphan.fatherName.isNotEmpty ? orphan.fatherName : ''} ${orphan.grandfatherName.isNotEmpty ? orphan.grandfatherName : ''} ${orphan.familyName.isNotEmpty ? orphan.familyName : ''}'
              .trim(),
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
                    color: statusColor.withOpacity(0.1),
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: null,
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

  Future<void> _seedTestData(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final database = context.read<AppDb>();
      final seeder = DataSeeder(database);
      await seeder.seedData();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
              '✅ Test data created successfully! (4 supervisors, 8 orphans)'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('❌ Error creating test data: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
