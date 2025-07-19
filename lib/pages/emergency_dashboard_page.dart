import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:provider/provider.dart';

class EmergencyDashboardPage extends StatelessWidget {
  const EmergencyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.watch<OrphanRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Dashboard'),
      ),
      body: StreamBuilder<List<Orphan>>(
        stream: orphanRepository.getMissingOrphans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No missing orphans.'));
          }
          final orphans = snapshot.data!;
          return ListView.builder(
            itemCount: orphans.length,
            itemBuilder: (context, index) {
              final orphan = orphans[index];
              return ListTile(
                title: Text(orphan.fullName),
                subtitle:
                    Text(orphan.lastSeenLocation ?? 'No location specified'),
                trailing: ElevatedButton(
                  onPressed: () {
                    orphanRepository.updateOrphanStatus(
                        orphan.orphanId, OrphanStatus.found);
                  },
                  child: const Text('Mark as Found'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
