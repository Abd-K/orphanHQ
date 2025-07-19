import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/image_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

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
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Implement edit functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit functionality coming soon')),
              );
            },
            tooltip: 'Edit Details',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // TODO: Implement delete from details page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Delete functionality coming soon')),
              );
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card with Basic Info
                    _buildHeaderCard(context, orphan, supervisor),
                    const SizedBox(height: 16),

                    // Family Information
                    _buildFamilySection(orphan),
                    const SizedBox(height: 16),

                    // Education Information
                    _buildEducationSection(orphan),
                    const SizedBox(height: 16),

                    // Health Information
                    _buildHealthSection(orphan),
                    const SizedBox(height: 16),

                    // Accommodation Information
                    _buildAccommodationSection(orphan),
                    const SizedBox(height: 16),

                    // Islamic Education & Personal
                    _buildPersonalSection(orphan),
                    const SizedBox(height: 16),

                    // Hobbies & Aspirations
                    _buildHobbiesSection(orphan),
                    const SizedBox(height: 16),

                    // Siblings Information
                    _buildSiblingsSection(orphan),
                    const SizedBox(height: 16),

                    // Additional Information
                    _buildAdditionalSection(orphan),
                    const SizedBox(height: 16),

                    // Attached Documents
                    _buildDocumentsSection(orphan),
                    const SizedBox(height: 16),

                    // Action Buttons
                    _buildActionButtons(context, orphan, orphanRepository,
                        supervisorRepository),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(
      BuildContext context, Orphan orphan, Supervisor? supervisor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    orphan.firstName.isNotEmpty
                        ? orphan.firstName[0].toUpperCase()
                        : 'O',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${orphan.firstName} ${orphan.lastName}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Family: ${orphan.familyName}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(orphan.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orphan.status.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickInfo('Gender',
                      orphan.gender.toString().split('.').last.toUpperCase()),
                ),
                Expanded(
                  child: _buildQuickInfo(
                      'Date of Birth', _formatDate(orphan.dateOfBirth)),
                ),
                Expanded(
                  child: _buildQuickInfo(
                      'Age', _calculateAge(orphan.dateOfBirth).toString()),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Supervisor', supervisor?.fullName ?? 'Unknown'),
            if (supervisor != null) ...[
              _buildDetailRow('Supervisor Contact', supervisor.contactInfo),
              _buildDetailRow('Supervisor Location', supervisor.location),
            ],
            _buildDetailRow('Last Updated', _formatDate(orphan.lastUpdated)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySection(Orphan orphan) {
    return _buildSectionCard('Family Information', Icons.family_restroom, [
      _buildDetailRow(
          'Father\'s Name', orphan.fatherFirstName ?? 'Not specified'),
      if (orphan.fatherDateOfDeath != null)
        _buildDetailRow(
            'Father\'s Date of Death', _formatDate(orphan.fatherDateOfDeath!)),
      _buildDetailRow('Father\'s Cause of Death',
          orphan.fatherCauseOfDeath ?? 'Not specified'),
      _buildDetailRow('Father\'s Work', orphan.fatherWork ?? 'Not specified'),
      const SizedBox(height: 8),
      _buildDetailRow(
          'Mother\'s Name', orphan.motherFirstName ?? 'Not specified'),
      _buildDetailRow(
          'Mother Alive',
          orphan.motherAlive != null
              ? (orphan.motherAlive! ? 'Yes' : 'No')
              : 'Unknown'),
      if (orphan.motherDateOfDeath != null)
        _buildDetailRow(
            'Mother\'s Date of Death', _formatDate(orphan.motherDateOfDeath!)),
      _buildDetailRow('Mother\'s Cause of Death',
          orphan.motherCauseOfDeath ?? 'Not specified'),
      _buildDetailRow('Mother\'s Work', orphan.motherWork ?? 'Not specified'),
      const SizedBox(height: 8),
      _buildDetailRow(
          'Guardian/Carer Name', orphan.guardianName ?? 'Not specified'),
      _buildDetailRow('Guardian Relationship',
          orphan.guardianRelationship ?? 'Not specified'),
    ]);
  }

  Widget _buildEducationSection(Orphan orphan) {
    return _buildSectionCard('Education', Icons.school, [
      _buildDetailRow('Education Level',
          orphan.educationLevel?.toString().split('.').last ?? 'Not specified'),
      _buildDetailRow('School Name', orphan.schoolName ?? 'Not specified'),
      _buildDetailRow('Grade/Class', orphan.grade ?? 'Not specified'),
    ]);
  }

  Widget _buildHealthSection(Orphan orphan) {
    return _buildSectionCard('Health Information', Icons.health_and_safety, [
      _buildDetailRow('Health Status',
          orphan.healthStatus?.toString().split('.').last ?? 'Not specified'),
      _buildDetailRow(
          'Medical Conditions', orphan.medicalConditions ?? 'None specified'),
      _buildDetailRow('Medications', orphan.medications ?? 'None specified'),
      _buildDetailRow(
          'Needs Medical Support',
          orphan.needsMedicalSupport != null
              ? (orphan.needsMedicalSupport! ? 'Yes' : 'No')
              : 'Unknown'),
    ]);
  }

  Widget _buildAccommodationSection(Orphan orphan) {
    return _buildSectionCard('Accommodation', Icons.home, [
      _buildDetailRow(
          'Accommodation Type',
          orphan.accommodationType?.toString().split('.').last ??
              'Not specified'),
      _buildDetailRow(
          'Address', orphan.accommodationAddress ?? 'Not specified'),
      _buildDetailRow(
          'Needs Housing Support',
          orphan.needsHousingSupport != null
              ? (orphan.needsHousingSupport! ? 'Yes' : 'No')
              : 'Unknown'),
    ]);
  }

  Widget _buildPersonalSection(Orphan orphan) {
    return _buildSectionCard(
        'Islamic Education & Personal', Icons.auto_stories, [
      _buildDetailRow(
          'Quran Memorization', orphan.quranMemorization ?? 'Not specified'),
      _buildDetailRow(
          'Attends Islamic School',
          orphan.attendsIslamicSchool != null
              ? (orphan.attendsIslamicSchool! ? 'Yes' : 'No')
              : 'Unknown'),
      _buildDetailRow('Islamic Education Level',
          orphan.islamicEducationLevel ?? 'Not specified'),
    ]);
  }

  Widget _buildHobbiesSection(Orphan orphan) {
    return _buildSectionCard('Interests & Aspirations', Icons.sports_soccer, [
      _buildDetailRow('Hobbies', orphan.hobbies ?? 'Not specified'),
      _buildDetailRow('Skills', orphan.skills ?? 'Not specified'),
      _buildDetailRow('Aspirations', orphan.aspirations ?? 'Not specified'),
    ]);
  }

  Widget _buildSiblingsSection(Orphan orphan) {
    return _buildSectionCard('Siblings Information', Icons.people, [
      _buildDetailRow('Number of Siblings',
          orphan.numberOfSiblings?.toString() ?? 'Not specified'),
      _buildDetailRow(
          'Siblings Details', orphan.siblingsDetails ?? 'Not specified'),
    ]);
  }

  Widget _buildAdditionalSection(Orphan orphan) {
    return _buildSectionCard('Additional Information', Icons.info, [
      _buildDetailRow('Additional Notes', orphan.additionalNotes ?? 'None'),
      _buildDetailRow('Urgent Needs', orphan.urgentNeeds ?? 'None'),
    ]);
  }

  Widget _buildDocumentsSection(Orphan orphan) {
    if (orphan.documentsPath == null || orphan.documentsPath!.isEmpty) {
      return _buildSectionCard('Attached Documents', Icons.attach_file, [
        const Text(
          'No documents attached',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ]);
    }

    final documents = orphan.documentsPath!.split(',');
    return _buildSectionCard('Attached Documents', Icons.attach_file, [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final docParts = documents[index].split(':');
          final docType = docParts.length > 1 ? docParts[0] : 'document';
          final docPath = docParts.length > 1 ? docParts[1] : documents[index];

          return _buildDocumentTile(docType, docPath);
        },
      ),
    ]);
  }

  Widget _buildDocumentTile(String docType, String docPath) {
    String getDocumentName(String type) {
      switch (type) {
        case 'birth_cert':
          return 'Birth Certificate';
        case 'death_cert':
          return 'Death Certificate';
        case 'orphan_id':
          return 'Orphan ID';
        case 'father_id':
          return 'Father ID';
        case 'mother_id':
          return 'Mother ID';
        case 'family_id':
          return 'Family ID';
        case 'passport_photo':
          return 'Passport Photo';
        case 'recent_photo':
          return 'Recent Photo';
        default:
          return 'Document';
      }
    }

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () => _showDocumentPreview(docPath),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                  future: ImageService.documentPhotoExists(docPath),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(docPath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                getDocumentName(docType),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentPreview(String imagePath) {
    // TODO: Implement document preview dialog
    print('Show document preview for: $imagePath');
  }

  Widget _buildActionButtons(
      BuildContext context,
      Orphan orphan,
      OrphanRepository orphanRepository,
      SupervisorRepository supervisorRepository) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showChangeSupervisorDialog(context, orphan,
                        orphanRepository, supervisorRepository);
                  },
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Change Supervisor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (orphan.status == OrphanStatus.missing)
                  ElevatedButton.icon(
                    onPressed: () {
                      orphanRepository.updateOrphanStatus(
                          orphan.orphanId, OrphanStatus.found);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${orphan.firstName} ${orphan.lastName} marked as found'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark as Found'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Export/share orphan details
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Export functionality coming soon')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showChangeSupervisorDialog(
      BuildContext context,
      Orphan orphan,
      OrphanRepository orphanRepository,
      SupervisorRepository supervisorRepository) {
    // Implementation for changing supervisor dialog
    // (keeping existing implementation)
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Change Supervisor'),
        content: Text('This functionality will be implemented'),
      ),
    );
  }
}
