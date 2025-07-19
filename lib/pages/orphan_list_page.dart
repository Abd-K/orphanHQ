import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

class OrphanListPage extends StatelessWidget {
  const OrphanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphan List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              context.push('/onboard');
            },
            tooltip: 'Add Orphan',
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              context.push('/supervisors');
            },
            tooltip: 'View Supervisors',
          ),
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              context.push('/emergency');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Orphan>>(
        stream: orphanRepository.getAllOrphans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orphans found.'));
          }
          final orphans = snapshot.data!;
          return ListView.builder(
            itemCount: orphans.length,
            itemBuilder: (context, index) {
              final orphan = orphans[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(orphan.fullName),
                  subtitle: Text(
                      'Status: ${orphan.status.toString().split('.').last}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteOrphanDialog(
                          context, orphan, orphanRepository);
                    },
                  ),
                  onTap: () {
                    context.push('/orphan/${orphan.orphanId}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteOrphanDialog(
      BuildContext context, Orphan orphan, OrphanRepository orphanRepository) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Orphan'),
          content: Text(
              'Are you sure you want to delete ${orphan.fullName}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await orphanRepository.deleteOrphan(orphan.orphanId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('${orphan.fullName} deleted successfully')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete orphan: $e')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
