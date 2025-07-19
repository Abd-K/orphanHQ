import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

class SupervisorViewPage extends StatelessWidget {
  const SupervisorViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supervisorRepository = context.watch<SupervisorRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              context.push('/add-supervisor');
            },
            tooltip: 'Add Supervisor',
          ),
        ],
      ),
      body: StreamBuilder<List<Supervisor>>(
        stream: supervisorRepository.watchAllSupervisors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No supervisors found.'));
          }
          final supervisors = snapshot.data!;
          return ListView.builder(
            itemCount: supervisors.length,
            itemBuilder: (context, index) {
              final supervisor = supervisors[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(supervisor.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact: ${supervisor.contactInfo}'),
                      Text('Location: ${supervisor.location}'),
                      Text(
                          'Status: ${supervisor.active ? "Active" : "Inactive"}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteSupervisorDialog(
                          context, supervisor, supervisorRepository);
                    },
                  ),
                  isThreeLine: true,
                  onTap: () {
                    context
                        .push('/supervisor/${supervisor.supervisorId}/orphans');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteSupervisorDialog(BuildContext context, Supervisor supervisor,
      SupervisorRepository supervisorRepository) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Supervisor'),
          content: Text(
              'Are you sure you want to delete ${supervisor.fullName}? This action cannot be undone and will affect any associated orphans.'),
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
                  await supervisorRepository
                      .deleteSupervisor(supervisor.supervisorId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${supervisor.fullName} deleted successfully')),
                  );
                } catch (e) {
                  print('Error deleting supervisor: $e'); // Console logging
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete supervisor: $e')),
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
