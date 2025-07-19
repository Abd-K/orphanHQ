import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

class SupervisorOrphansPage extends StatelessWidget {
  final String supervisorId;

  const SupervisorOrphansPage({super.key, required this.supervisorId});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor\'s Orphans'),
      ),
      body: Column(
        children: [
          // Supervisor Info Card
          FutureBuilder<List<Supervisor>>(
            future: supervisorRepository.getAllSupervisors(),
            builder: (context, snapshot) {
              final supervisor = snapshot.data
                  ?.where((s) => s.supervisorId == supervisorId)
                  .firstOrNull;
              if (supervisor == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SupervisorRepository.getFullName(supervisor),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Contact: ${SupervisorRepository.getContactInfo(supervisor)}'),
                      Text(
                          'Location: ${SupervisorRepository.getLocation(supervisor)}'),
                    ],
                  ),
                ),
              );
            },
          ),
          // Orphans list
          Expanded(
            child: StreamBuilder<List<Orphan>>(
              stream: orphanRepository.getOrphansBySupervisor(supervisorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No orphans assigned to this supervisor.'));
                }
                final orphans = snapshot.data!;
                return ListView.builder(
                  itemCount: orphans.length,
                  itemBuilder: (context, index) {
                    final orphan = orphans[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}'),
                        subtitle: Text(
                            'Status: ${orphan.status.toString().split('.').last}'),
                        onTap: () {
                          context.push('/orphan/${orphan.orphanId}');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
