import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/image_service.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

class OrphanDetailsPage extends StatefulWidget {
  final String? orphanId; // Nullable for add mode

  const OrphanDetailsPage({super.key, this.orphanId});

  @override
  State<OrphanDetailsPage> createState() => _OrphanDetailsPageState();
}

class _OrphanDetailsPageState extends State<OrphanDetailsPage> {
  // Track which sections are in edit mode
  final Map<String, bool> _editingSections = {};

  // Scroll controller to maintain position
  final ScrollController _scrollController = ScrollController();

  // Check if we're in add mode (no orphanId provided)
  bool get isAddMode => widget.orphanId == null;

  // Controllers for 4-part Arabic name structure
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _grandfatherNameController =
      TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();

  // Family section controllers
  final TextEditingController _fatherFirstNameController =
      TextEditingController();
  final TextEditingController _fatherCauseOfDeathController =
      TextEditingController();
  final TextEditingController _fatherWorkController = TextEditingController();
  final TextEditingController _motherFirstNameController =
      TextEditingController();
  final TextEditingController _motherCauseOfDeathController =
      TextEditingController();
  final TextEditingController _motherWorkController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianRelationshipController =
      TextEditingController();

  // Education section controllers
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  // Health section controllers
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  // Address section controllers
  final TextEditingController _currentCountryController =
      TextEditingController();
  final TextEditingController _currentGovernorateController =
      TextEditingController();
  final TextEditingController _currentCityController = TextEditingController();
  final TextEditingController _currentNeighborhoodController =
      TextEditingController();
  final TextEditingController _currentCampController = TextEditingController();
  final TextEditingController _currentStreetController =
      TextEditingController();
  final TextEditingController _currentPhoneNumberController =
      TextEditingController();

  // Accommodation section controllers
  final TextEditingController _accommodationAddressController =
      TextEditingController();
  final TextEditingController _accommodationConditionController =
      TextEditingController();
  final TextEditingController _accommodationOwnershipController =
      TextEditingController();

  // Islamic education controllers
  final TextEditingController _quranMemorizationController =
      TextEditingController();
  final TextEditingController _islamicEducationLevelController =
      TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _aspirationsController = TextEditingController();

  // Siblings controllers
  final TextEditingController _numberOfSiblingsController =
      TextEditingController();
  final TextEditingController _siblingsDetailsController =
      TextEditingController();

  // Additional information controllers
  final TextEditingController _additionalNotesController =
      TextEditingController();
  final TextEditingController _urgentNeedsController = TextEditingController();
  final TextEditingController _specialCircumstancesController =
      TextEditingController();

  // Additional Comments Controllers for each section
  final TextEditingController _orphanDetailsCommentsController =
      TextEditingController();
  final TextEditingController _fatherDetailsCommentsController =
      TextEditingController();
  final TextEditingController _motherDetailsCommentsController =
      TextEditingController();
  final TextEditingController _carerDetailsCommentsController =
      TextEditingController();
  final TextEditingController _educationCommentsController =
      TextEditingController();
  final TextEditingController _healthCommentsController =
      TextEditingController();
  final TextEditingController _accommodationCommentsController =
      TextEditingController();
  final TextEditingController _islamicEducationCommentsController =
      TextEditingController();
  final TextEditingController _hobbiesCommentsController =
      TextEditingController();
  final TextEditingController _siblingsCommentsController =
      TextEditingController();

  // Document attachment variables
  File? _birthCertificatePhoto;
  File? _deathCertificatePhoto;
  File? _orphanIdPhoto;
  File? _fatherIdPhoto;
  File? _motherIdPhoto;
  File? _familyIdPhoto;
  File? _passportPhoto;
  File? _recentPhoto;
  List<File> _additionalDocuments = [];

  Gender? _selectedGender;
  OrphanStatus? _selectedStatus;
  DateTime? _selectedBirthDate;
  DateTime? _fatherDateOfDeath;
  DateTime? _motherDateOfDeath;
  bool? _motherAlive;
  EducationLevel? _selectedEducationLevel;
  HealthStatus? _selectedHealthStatus;
  bool? _needsMedicalSupport;
  AccommodationType? _selectedAccommodationType;
  bool? _needsHousingSupport;
  bool? _attendsIslamicSchool;

  @override
  void initState() {
    super.initState();
    // Initialize sections - in add mode, start with basic info in edit mode
    if (isAddMode) {
      // In add mode, all sections start in edit mode
      _editingSections['basic'] = true;
      _editingSections['family'] = true;
      _editingSections['education'] = true;
      _editingSections['health'] = true;
      _editingSections['address'] = true;
      _editingSections['accommodation'] = true;
      _editingSections['islamic'] = true;
      _editingSections['siblings'] = true;
      _editingSections['additional'] = true;
    } else {
      // In view mode, all sections start in view mode
      _editingSections['basic'] = false;
      _editingSections['family'] = false;
      _editingSections['education'] = false;
      _editingSections['health'] = false;
      _editingSections['address'] = false;
      _editingSections['accommodation'] = false;
      _editingSections['islamic'] = false;
      _editingSections['siblings'] = false;
      _editingSections['additional'] = false;
    }
  }

  @override
  void dispose() {
    // Basic info controllers
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _familyNameController.dispose();

    // Family section controllers
    _fatherFirstNameController.dispose();
    _fatherCauseOfDeathController.dispose();
    _fatherWorkController.dispose();
    _motherFirstNameController.dispose();
    _motherCauseOfDeathController.dispose();
    _motherWorkController.dispose();
    _guardianNameController.dispose();
    _guardianRelationshipController.dispose();

    // Education section controllers
    _schoolNameController.dispose();
    _gradeController.dispose();

    // Health section controllers
    _medicalConditionsController.dispose();
    _medicationsController.dispose();

    // Scroll controller
    _scrollController.dispose();

    super.dispose();
  }

  void _initializeControllers(Orphan orphan) {
    // Basic info
    _firstNameController.text = orphan.firstName;
    _fatherNameController.text = orphan.fatherName;
    _grandfatherNameController.text = orphan.grandfatherName;
    _familyNameController.text = orphan.familyName;
    _selectedGender = orphan.gender;
    _selectedStatus = orphan.status;

    // Family info
    _fatherNameController.text = orphan.fatherName ?? '';
    _fatherFirstNameController.text =
        orphan.fatherName ?? ''; // Sync with fatherName
    _fatherCauseOfDeathController.text = orphan.fatherCauseOfDeath ?? '';
    _fatherWorkController.text = orphan.fatherWork ?? '';
    _motherFirstNameController.text = orphan.motherFirstName ?? '';
    _motherCauseOfDeathController.text = orphan.motherCauseOfDeath ?? '';
    _motherWorkController.text = orphan.motherWork ?? '';
    _guardianNameController.text = orphan.guardianName ?? '';
    _guardianRelationshipController.text = orphan.guardianRelationship ?? '';
    _fatherDateOfDeath = orphan.fatherDateOfDeath;
    _motherDateOfDeath = orphan.motherDateOfDeath;
    _motherAlive = orphan.motherAlive;

    // Education info
    _schoolNameController.text = orphan.schoolName ?? '';
    _gradeController.text = orphan.grade ?? '';
    _selectedEducationLevel = orphan.educationLevel;

    // Health info
    _medicalConditionsController.text = orphan.medicalConditions ?? '';
    _medicationsController.text = orphan.medications ?? '';
    _selectedHealthStatus = orphan.healthStatus;
    _needsMedicalSupport = orphan.needsMedicalSupport;
  }

  @override
  Widget build(BuildContext context) {
    final orphanRepository = context.read<OrphanRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();

    if (isAddMode) {
      return _buildAddOrphanForm(
          context, orphanRepository, supervisorRepository);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphan Details'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmation(context, orphanRepository);
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

          final orphan = snapshot.data!
              .where((o) => o.orphanId == widget.orphanId)
              .firstOrNull;

          if (orphan == null) {
            return const Center(child: Text('Orphan not found'));
          }

          // Initialize controllers with current data
          _initializeControllers(orphan);

          return FutureBuilder<List<Supervisor>>(
            future: supervisorRepository.getAllSupervisors(),
            builder: (context, supervisorSnapshot) {
              final supervisor = supervisorSnapshot.data
                  ?.where((s) => s.supervisorId == orphan.supervisorId)
                  .firstOrNull;

              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Orphan Details Section
                    _buildEditableSection(
                      'basic',
                      'Orphan Details',
                      Icons.person,
                      () => _buildBasicInfoView(orphan),
                      () => _buildBasicInfoEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Father Details Section
                    _buildEditableSection(
                      'father',
                      'Father Details',
                      Icons.family_restroom,
                      () => _buildFatherDetailsView(orphan),
                      () => _buildFatherDetailsEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Mother Details Section
                    _buildEditableSection(
                      'mother',
                      'Mother Details',
                      Icons.family_restroom,
                      () => _buildMotherDetailsView(orphan),
                      () => _buildMotherDetailsEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Carer Details Section
                    _buildEditableSection(
                      'carer',
                      'Carer Details',
                      Icons.family_restroom,
                      () => _buildCarerDetailsView(orphan),
                      () => _buildCarerDetailsEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Education Section
                    _buildEditableSection(
                      'education',
                      'Education',
                      Icons.school,
                      () => _buildEducationView(orphan),
                      () => _buildEducationEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Health Section
                    _buildEditableSection(
                      'health',
                      'Health',
                      Icons.health_and_safety,
                      () => _buildHealthView(orphan),
                      () => _buildHealthEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Accommodation Section
                    _buildEditableSection(
                      'accommodation',
                      'Accommodation',
                      Icons.home,
                      () => _buildAccommodationView(orphan),
                      () => _buildAccommodationEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Islamic Education Section
                    _buildEditableSection(
                      'islamic',
                      'Islamic Education',
                      Icons.mosque,
                      () => _buildIslamicEducationView(orphan),
                      () => _buildIslamicEducationEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Hobbies Section
                    _buildEditableSection(
                      'hobbies',
                      'Hobbies',
                      Icons.sports_esports,
                      () => _buildHobbiesView(orphan),
                      () => _buildHobbiesEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Siblings Section
                    _buildEditableSection(
                      'siblings',
                      'Siblings',
                      Icons.people,
                      () => _buildSiblingsView(orphan),
                      () => _buildSiblingsEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Additional Info Section
                    _buildEditableSection(
                      'additional',
                      'Additional Info',
                      Icons.note_add,
                      () => _buildAdditionalInfoView(orphan),
                      () => _buildAdditionalInfoEdit(orphan),
                      orphan,
                      orphanRepository,
                    ),
                    const SizedBox(height: 16),

                    // Documents & Attachments Section
                    _buildEditableSection(
                      'attachments',
                      'Required Documents',
                      Icons.attach_file,
                      () => _buildAttachmentsView(orphan),
                      () => _buildAttachmentsView(
                          orphan), // Same for view and edit
                      orphan,
                      orphanRepository,
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

  void _toggleSection(String sectionKey) {
    setState(() {
      _editingSections[sectionKey] = !(_editingSections[sectionKey] ?? false);
    });
  }

  // Placeholder methods for the new section structure
  Widget _buildFatherDetailsEdit(Orphan orphan) => _buildFatherInfoEdit(orphan);
  Widget _buildFatherDetailsView(Orphan orphan) => _buildFatherInfoView(orphan);
  Widget _buildMotherDetailsEdit(Orphan orphan) => _buildMotherInfoEdit(orphan);
  Widget _buildMotherDetailsView(Orphan orphan) => _buildMotherInfoView(orphan);
  Widget _buildCarerDetailsEdit(Orphan orphan) => _buildCarerInfoEdit(orphan);
  Widget _buildCarerDetailsView(Orphan orphan) => _buildCarerInfoView(orphan);
  Widget _buildEducationEdit(Orphan orphan) => _buildEducationInfoEdit(orphan);
  Widget _buildHealthEdit(Orphan orphan) => _buildHealthInfoEdit(orphan);
  Widget _buildIslamicEducationEdit(Orphan orphan) => _buildIslamicEdit(orphan);
  Widget _buildIslamicEducationView(Orphan orphan) => _buildIslamicView(orphan);
  Widget _buildHobbiesEdit(Orphan orphan) => _buildHobbiesInfoEdit(orphan);
  Widget _buildHobbiesView(Orphan orphan) => _buildHobbiesInfoView(orphan);
  Widget _buildAdditionalInfoEdit(Orphan orphan) =>
      _buildAdditionalEdit(orphan);
  Widget _buildAdditionalInfoView(Orphan orphan) =>
      _buildAdditionalView(orphan);
  Widget _buildAttachmentsView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Please attach photos of the following documents:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Birth Certificate of Orphan
        _buildDocumentAttachment(
          title: 'Birth Certificate of Orphan',
          subtitle: 'Official birth certificate document',
          icon: Icons.child_care,
          photo: _birthCertificatePhoto,
          onSelect: () => _selectDocumentPhoto('birth_certificate'),
          onRemove: () => _removeDocumentPhoto('birth_certificate'),
          isRequired: true,
        ),

        // Death Certificate of Father
        _buildDocumentAttachment(
          title: 'Death Certificate of Father',
          subtitle: 'Official death certificate document',
          icon: Icons.person_off,
          photo: _deathCertificatePhoto,
          onSelect: () => _selectDocumentPhoto('death_certificate'),
          onRemove: () => _removeDocumentPhoto('death_certificate'),
          isRequired: true,
        ),

        // ID Card of Orphan
        _buildDocumentAttachment(
          title: 'ID Card or Other for Orphan',
          subtitle: 'Identity document, passport, or similar',
          icon: Icons.badge,
          photo: _orphanIdPhoto,
          onSelect: () => _selectDocumentPhoto('orphan_id'),
          onRemove: () => _removeDocumentPhoto('orphan_id'),
          isRequired: true,
        ),

        // ID Card of Father
        _buildDocumentAttachment(
          title: 'ID Card or Other for Father',
          subtitle: 'Father\'s identity document',
          icon: Icons.badge_outlined,
          photo: _fatherIdPhoto,
          onSelect: () => _selectDocumentPhoto('father_id'),
          onRemove: () => _removeDocumentPhoto('father_id'),
          isRequired: true,
        ),

        // ID Card of Mother
        _buildDocumentAttachment(
          title: 'ID Card or Other for Mother',
          subtitle: 'Mother\'s identity document',
          icon: Icons.badge_outlined,
          photo: _motherIdPhoto,
          onSelect: () => _selectDocumentPhoto('mother_id'),
          onRemove: () => _removeDocumentPhoto('mother_id'),
          isRequired: true,
        ),

        // ID Card of Family
        _buildDocumentAttachment(
          title: 'ID Card or Other for Family',
          subtitle: 'Family member or guardian identity document',
          icon: Icons.family_restroom,
          photo: _familyIdPhoto,
          onSelect: () => _selectDocumentPhoto('family_id'),
          onRemove: () => _removeDocumentPhoto('family_id'),
          isRequired: true,
        ),

        // Passport Photo of Orphan
        _buildDocumentAttachment(
          title: 'Passport Photo of Orphan',
          subtitle: 'Official passport-style photo',
          icon: Icons.portrait,
          photo: _passportPhoto,
          onSelect: () => _selectDocumentPhoto('passport_photo'),
          onRemove: () => _removeDocumentPhoto('passport_photo'),
          isRequired: true,
        ),

        // Recent Photo of Orphan
        _buildDocumentAttachment(
          title: 'Recent Photo of Orphan',
          subtitle: 'Current photo for identification',
          icon: Icons.photo_camera,
          photo: _recentPhoto,
          onSelect: () => _selectDocumentPhoto('recent_photo'),
          onRemove: () => _removeDocumentPhoto('recent_photo'),
          isRequired: true,
        ),

        // Additional Documents
        Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_photo_alternate,
                        color: Colors.blue.shade600),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Documents',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Any other supporting documents (optional)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Additional documents list
                if (_additionalDocuments.isNotEmpty) ...[
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _additionalDocuments.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _additionalDocuments[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => _removeAdditionalDocument(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Add additional document button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _selectAdditionalDocument,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Additional Document'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableSection(
    String sectionKey,
    String title,
    IconData icon,
    Widget Function() viewContent,
    Widget Function() editContent,
    Orphan orphan,
    OrphanRepository repository,
  ) {
    final isEditing = _editingSections[sectionKey] ?? false;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                if (isEditing) ...[
                  TextButton.icon(
                    onPressed: () => _cancelEdit(sectionKey),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Cancel'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _saveSection(sectionKey, orphan, repository),
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ] else
                  IconButton(
                    onPressed: () => _startEdit(sectionKey),
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit $title',
                    color: Colors.blue.shade700,
                  ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: isEditing ? editContent() : viewContent(),
          ),
        ],
      ),
    );
  }

  void _startEdit(String sectionKey) {
    final currentPosition = _scrollController.position.pixels;
    setState(() {
      _editingSections[sectionKey] = true;
    });
    // Restore scroll position after rebuild with a small delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          currentPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _cancelEdit(String sectionKey) {
    setState(() {
      _editingSections[sectionKey] = false;
    });
  }

  Future<void> _saveSection(
      String sectionKey, Orphan orphan, OrphanRepository repository) async {
    try {
      print('Saving section: $sectionKey'); // Debug log
      switch (sectionKey) {
        case 'basic':
          await _saveBasicInfo(orphan, repository);
          break;
        case 'father':
          await _saveFatherInfo(orphan, repository);
          break;
        case 'mother':
          await _saveMotherInfo(orphan, repository);
          break;
        case 'carer':
          await _saveCarerInfo(orphan, repository);
          break;
        case 'education':
          await _saveEducationInfo(orphan, repository);
          break;
        case 'health':
          await _saveHealthInfo(orphan, repository);
          break;
        case 'address':
          await _saveAddressInfo(orphan, repository);
          break;
        case 'accommodation':
          await _saveAccommodationInfo(orphan, repository);
          break;
        case 'islamic':
          await _saveIslamicInfo(orphan, repository);
          break;
        case 'hobbies':
          await _saveHobbiesInfo(orphan, repository);
          break;
        case 'siblings':
          await _saveSiblingsInfo(orphan, repository);
          break;
        case 'additional':
          await _saveAdditionalInfo(orphan, repository);
          break;
        case 'attachments':
          await _saveAttachmentsInfo(orphan, repository);
          break;
        default:
          print('Unknown section key: $sectionKey'); // Debug log
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unknown section: $sectionKey'),
                backgroundColor: Colors.red,
              ),
            );
          }
      }
    } catch (e) {
      print('Error in _saveSection: $e'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving section: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveBasicInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        firstName: drift.Value(_firstNameController.text),
        fatherName: drift.Value(_fatherNameController.text),
        fatherFirstName: drift.Value(_fatherNameController.text.isEmpty
            ? null
            : _fatherNameController.text),
        grandfatherName: drift.Value(_grandfatherNameController.text),
        familyName: drift.Value(_familyNameController.text),
        gender: drift.Value(_selectedGender!),
        status: drift.Value(_selectedStatus!),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['basic'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Basic information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating basic information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveFatherInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        fatherName: drift.Value(_fatherNameController.text),
        fatherFirstName: drift.Value(_fatherNameController.text.isEmpty
            ? null
            : _fatherNameController.text),
        fatherDateOfDeath: drift.Value(_fatherDateOfDeath),
        fatherCauseOfDeath: drift.Value(
            _fatherCauseOfDeathController.text.isEmpty
                ? null
                : _fatherCauseOfDeathController.text),
        fatherWork: drift.Value(_fatherWorkController.text.isEmpty
            ? null
            : _fatherWorkController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['father'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Father information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating father information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveMotherInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        motherFirstName: drift.Value(_motherFirstNameController.text.isEmpty
            ? null
            : _motherFirstNameController.text),
        motherAlive: drift.Value(_motherAlive),
        motherDateOfDeath: drift.Value(_motherDateOfDeath),
        motherCauseOfDeath: drift.Value(
            _motherCauseOfDeathController.text.isEmpty
                ? null
                : _motherCauseOfDeathController.text),
        motherWork: drift.Value(_motherWorkController.text.isEmpty
            ? null
            : _motherWorkController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['mother'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mother information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating mother information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveCarerInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        guardianName: drift.Value(_guardianNameController.text.isEmpty
            ? null
            : _guardianNameController.text),
        guardianRelationship: drift.Value(
            _guardianRelationshipController.text.isEmpty
                ? null
                : _guardianRelationshipController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['carer'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carer information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating carer information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveEducationInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        educationLevel: drift.Value(_selectedEducationLevel),
        schoolName: drift.Value(_schoolNameController.text.isEmpty
            ? null
            : _schoolNameController.text),
        grade: drift.Value(
            _gradeController.text.isEmpty ? null : _gradeController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['education'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Education information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating education information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveHealthInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        healthStatus: drift.Value(_selectedHealthStatus),
        medicalConditions: drift.Value(_medicalConditionsController.text.isEmpty
            ? null
            : _medicalConditionsController.text),
        medications: drift.Value(_medicationsController.text.isEmpty
            ? null
            : _medicationsController.text),
        needsMedicalSupport: drift.Value(_needsMedicalSupport),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['health'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating health information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildBasicInfoView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Full Name',
            '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}'),
        _buildDetailRow('First Name', orphan.firstName),
        _buildDetailRow('Father\'s Name', orphan.fatherName),
        _buildDetailRow('Grandfather\'s Name', orphan.grandfatherName),
        _buildDetailRow('Family Name', orphan.familyName),
        _buildDetailRow(
            'Gender', orphan.gender.toString().split('.').last.toUpperCase()),
        _buildDetailRow('Date of Birth', _formatDate(orphan.dateOfBirth)),
        _buildDetailRow(
            'Status', orphan.status.toString().split('.').last.toUpperCase()),
        _buildDetailRow('Age', _calculateAge(orphan.dateOfBirth).toString()),
        _buildDetailRow('Last Updated', _formatDate(orphan.lastUpdated)),
      ],
    );
  }

  Widget _buildBasicInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fatherNameController,
          decoration: const InputDecoration(
            labelText: 'Father\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _grandfatherNameController,
          decoration: const InputDecoration(
            labelText: 'Grandfather\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _familyNameController,
          decoration: const InputDecoration(
            labelText: 'Family Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Gender>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          items: Gender.values
              .map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g.toString().split('.').last.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<OrphanStatus>(
          value: _selectedStatus,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: OrphanStatus.values
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.toString().split('.').last.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _orphanDetailsCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildFatherInfoView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Father\'s Name', orphan.fatherName ?? 'Not specified'),
        if (orphan.fatherDateOfDeath != null)
          _buildDetailRow('Father\'s Date of Death',
              _formatDate(orphan.fatherDateOfDeath!)),
        _buildDetailRow('Father\'s Cause of Death',
            orphan.fatherCauseOfDeath ?? 'Not specified'),
        _buildDetailRow('Father\'s Work', orphan.fatherWork ?? 'Not specified'),
      ],
    );
  }

  Widget _buildMotherInfoView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            'Mother\'s Name', orphan.motherFirstName ?? 'Not specified'),
        _buildDetailRow(
            'Mother Alive',
            orphan.motherAlive != null
                ? (orphan.motherAlive! ? 'Yes' : 'No')
                : 'Unknown'),
        if (orphan.motherDateOfDeath != null)
          _buildDetailRow('Mother\'s Date of Death',
              _formatDate(orphan.motherDateOfDeath!)),
        _buildDetailRow('Mother\'s Cause of Death',
            orphan.motherCauseOfDeath ?? 'Not specified'),
        _buildDetailRow('Mother\'s Work', orphan.motherWork ?? 'Not specified'),
      ],
    );
  }

  Widget _buildCarerInfoView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            'Guardian/Carer Name', orphan.guardianName ?? 'Not specified'),
        _buildDetailRow('Guardian Relationship',
            orphan.guardianRelationship ?? 'Not specified'),
      ],
    );
  }

  Widget _buildFamilyInfoView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            'Father\'s Name', orphan.fatherFirstName ?? 'Not specified'),
        if (orphan.fatherDateOfDeath != null)
          _buildDetailRow('Father\'s Date of Death',
              _formatDate(orphan.fatherDateOfDeath!)),
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
          _buildDetailRow('Mother\'s Date of Death',
              _formatDate(orphan.motherDateOfDeath!)),
        _buildDetailRow('Mother\'s Cause of Death',
            orphan.motherCauseOfDeath ?? 'Not specified'),
        _buildDetailRow('Mother\'s Work', orphan.motherWork ?? 'Not specified'),
        const SizedBox(height: 8),
        _buildDetailRow(
            'Guardian/Carer Name', orphan.guardianName ?? 'Not specified'),
        _buildDetailRow('Guardian Relationship',
            orphan.guardianRelationship ?? 'Not specified'),
      ],
    );
  }

  Widget _buildEducationView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            'Education Level',
            orphan.educationLevel?.toString().split('.').last ??
                'Not specified'),
        _buildDetailRow('School Name', orphan.schoolName ?? 'Not specified'),
        _buildDetailRow('Grade/Class', orphan.grade ?? 'Not specified'),
      ],
    );
  }

  Widget _buildHealthView(Orphan orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildFatherInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _fatherNameController,
          decoration: const InputDecoration(
            labelText: 'Father\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherCauseOfDeathController,
          decoration: const InputDecoration(
            labelText: 'Cause of Death',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherWorkController,
          decoration: const InputDecoration(
            labelText: 'Occupation',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherDetailsCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildMotherInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _motherFirstNameController,
          decoration: const InputDecoration(
            labelText: 'Mother\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<bool>(
          value: _motherAlive,
          decoration: const InputDecoration(
            labelText: 'Mother Alive',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) {
            setState(() {
              _motherAlive = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _motherCauseOfDeathController,
          decoration: const InputDecoration(
            labelText: 'Cause of Death',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _motherWorkController,
          decoration: const InputDecoration(
            labelText: 'Occupation',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _motherDetailsCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildCarerInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _guardianNameController,
          decoration: const InputDecoration(
            labelText: 'Carer Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _guardianRelationshipController,
          decoration: const InputDecoration(
            labelText: 'Relationship to Orphan',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _carerDetailsCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildFamilyInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Father Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fatherFirstNameController,
          decoration: const InputDecoration(
            labelText: 'Father\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fatherCauseOfDeathController,
          decoration: const InputDecoration(
            labelText: 'Father\'s Cause of Death',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fatherWorkController,
          decoration: const InputDecoration(
            labelText: 'Father\'s Work',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Mother Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        TextFormField(
          controller: _motherFirstNameController,
          decoration: const InputDecoration(
            labelText: 'Mother\'s Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<bool>(
          value: _motherAlive,
          decoration: const InputDecoration(
            labelText: 'Mother Alive',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) {
            setState(() {
              _motherAlive = value;
            });
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _motherCauseOfDeathController,
          decoration: const InputDecoration(
            labelText: 'Mother\'s Cause of Death',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _motherWorkController,
          decoration: const InputDecoration(
            labelText: 'Mother\'s Work',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Guardian Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        TextFormField(
          controller: _guardianNameController,
          decoration: const InputDecoration(
            labelText: 'Guardian/Carer Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _guardianRelationshipController,
          decoration: const InputDecoration(
            labelText: 'Guardian Relationship',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<EducationLevel>(
          value: _selectedEducationLevel,
          decoration: const InputDecoration(
            labelText: 'Education Level',
            border: OutlineInputBorder(),
          ),
          items: EducationLevel.values
              .map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level.toString().split('.').last.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedEducationLevel = value;
            });
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _schoolNameController,
          decoration: const InputDecoration(
            labelText: 'School Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _gradeController,
          decoration: const InputDecoration(
            labelText: 'Grade/Class',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _educationCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildHealthInfoEdit(Orphan? orphan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<HealthStatus>(
          value: _selectedHealthStatus,
          decoration: const InputDecoration(
            labelText: 'Health Status',
            border: OutlineInputBorder(),
          ),
          items: HealthStatus.values
              .map((status) => DropdownMenuItem(
                    value: status,
                    child:
                        Text(status.toString().split('.').last.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedHealthStatus = value;
            });
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _medicalConditionsController,
          decoration: const InputDecoration(
            labelText: 'Medical Conditions',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _medicationsController,
          decoration: const InputDecoration(
            labelText: 'Medications',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<bool>(
          value: _needsMedicalSupport,
          decoration: const InputDecoration(
            labelText: 'Needs Medical Support',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) {
            setState(() {
              _needsMedicalSupport = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _healthCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
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

  // Address Section Methods
  Widget _buildAddressView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow('Country', orphan.currentCountry ?? 'Not specified'),
        _buildDetailRow(
            'Governorate', orphan.currentGovernorate ?? 'Not specified'),
        _buildDetailRow('City', orphan.currentCity ?? 'Not specified'),
        _buildDetailRow(
            'Neighborhood', orphan.currentNeighborhood ?? 'Not specified'),
        _buildDetailRow('Camp', orphan.currentCamp ?? 'Not specified'),
        _buildDetailRow('Street', orphan.currentStreet ?? 'Not specified'),
        _buildDetailRow(
            'Phone Number', orphan.currentPhoneNumber ?? 'Not specified'),
      ],
    );
  }

  Widget _buildAddressEdit(Orphan? orphan) {
    return Column(
      children: [
        TextFormField(
          controller: _currentCountryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentGovernorateController,
          decoration: const InputDecoration(
            labelText: 'Governorate/Region',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentCityController,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentNeighborhoodController,
          decoration: const InputDecoration(
            labelText: 'Neighborhood/Village',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentCampController,
          decoration: const InputDecoration(
            labelText: 'Camp (if applicable)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentStreetController,
          decoration: const InputDecoration(
            labelText: 'Street/District',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentPhoneNumberController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Future<void> _saveAddressInfo(
      Orphan orphan, OrphanRepository repository) async {
    final updatedOrphan = orphan.copyWith(
      currentCountry: _currentCountryController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentCountryController.text.trim()),
      currentGovernorate: _currentGovernorateController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentGovernorateController.text.trim()),
      currentCity: _currentCityController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentCityController.text.trim()),
      currentNeighborhood: _currentNeighborhoodController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentNeighborhoodController.text.trim()),
      currentCamp: _currentCampController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentCampController.text.trim()),
      currentStreet: _currentStreetController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentStreetController.text.trim()),
      currentPhoneNumber: _currentPhoneNumberController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_currentPhoneNumberController.text.trim()),
    );
    await repository.updateOrphan(updatedOrphan);
  }

  // Accommodation Section Methods
  Widget _buildAccommodationView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow(
            'Accommodation Type',
            orphan.accommodationType?.name.replaceAll('_', ' ').toUpperCase() ??
                'Not specified'),
        _buildDetailRow('Accommodation Address',
            orphan.accommodationAddress ?? 'Not specified'),
        _buildDetailRow('Accommodation Condition',
            orphan.accommodationCondition ?? 'Not specified'),
        _buildDetailRow('Accommodation Ownership',
            orphan.accommodationOwnership ?? 'Not specified'),
        _buildDetailRow('Needs Housing Support',
            orphan.needsHousingSupport?.toString() ?? 'Not specified'),
      ],
    );
  }

  Widget _buildAccommodationEdit(Orphan? orphan) {
    return Column(
      children: [
        DropdownButtonFormField<AccommodationType>(
          value: _selectedAccommodationType,
          decoration: const InputDecoration(
            labelText: 'Accommodation Type',
            border: OutlineInputBorder(),
          ),
          items: AccommodationType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.name.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedAccommodationType = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accommodationAddressController,
          decoration: const InputDecoration(
            labelText: 'Accommodation Address',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accommodationConditionController,
          decoration: const InputDecoration(
            labelText: 'Accommodation Condition',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accommodationOwnershipController,
          decoration: const InputDecoration(
            labelText: 'Accommodation Ownership',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Needs Housing Support'),
          value: _needsHousingSupport ?? false,
          onChanged: (value) {
            setState(() {
              _needsHousingSupport = value;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Future<void> _saveAccommodationInfo(
      Orphan orphan, OrphanRepository repository) async {
    final updatedOrphan = orphan.copyWith(
      accommodationType: _selectedAccommodationType == null
          ? drift.Value.absent()
          : drift.Value(_selectedAccommodationType!),
      accommodationAddress: _accommodationAddressController.text.trim().isEmpty
          ? drift.Value.absent()
          : drift.Value(_accommodationAddressController.text.trim()),
      accommodationCondition:
          _accommodationConditionController.text.trim().isEmpty
              ? drift.Value.absent()
              : drift.Value(_accommodationConditionController.text.trim()),
      accommodationOwnership:
          _accommodationOwnershipController.text.trim().isEmpty
              ? drift.Value.absent()
              : drift.Value(_accommodationOwnershipController.text.trim()),
      needsHousingSupport: _needsHousingSupport == null
          ? drift.Value.absent()
          : drift.Value(_needsHousingSupport!),
    );
    await repository.updateOrphan(updatedOrphan);
  }

  // Islamic Education Section Methods
  Widget _buildIslamicView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow(
            'Quran Memorization', orphan.quranMemorization ?? 'Not specified'),
        _buildDetailRow('Attends Islamic School',
            orphan.attendsIslamicSchool?.toString() ?? 'Not specified'),
        _buildDetailRow('Islamic Education Level',
            orphan.islamicEducationLevel ?? 'Not specified'),
      ],
    );
  }

  Widget _buildHobbiesInfoView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow('Hobbies', orphan.hobbies ?? 'Not specified'),
        _buildDetailRow('Skills', orphan.skills ?? 'Not specified'),
        _buildDetailRow('Aspirations', orphan.aspirations ?? 'Not specified'),
      ],
    );
  }

  Widget _buildIslamicEdit(Orphan? orphan) {
    return Column(
      children: [
        TextFormField(
          controller: _quranMemorizationController,
          decoration: const InputDecoration(
            labelText: 'Quran Memorization',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Attends Islamic School'),
          value: _attendsIslamicSchool ?? false,
          onChanged: (value) {
            setState(() {
              _attendsIslamicSchool = value;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _islamicEducationLevelController,
          decoration: const InputDecoration(
            labelText: 'Islamic Education Level',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _islamicEducationCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildHobbiesInfoEdit(Orphan? orphan) {
    return Column(
      children: [
        TextFormField(
          controller: _hobbiesController,
          decoration: const InputDecoration(
            labelText: 'Hobbies & Interests',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _skillsController,
          decoration: const InputDecoration(
            labelText: 'Skills & Talents',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _aspirationsController,
          decoration: const InputDecoration(
            labelText: 'Aspirations & Dreams',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _hobbiesCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _saveIslamicInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        quranMemorization: drift.Value(_quranMemorizationController.text.isEmpty
            ? null
            : _quranMemorizationController.text),
        attendsIslamicSchool: drift.Value(_attendsIslamicSchool),
        islamicEducationLevel: drift.Value(
            _islamicEducationLevelController.text.isEmpty
                ? null
                : _islamicEducationLevelController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['islamic'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Islamic education information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating Islamic education information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveHobbiesInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        hobbies: drift.Value(
            _hobbiesController.text.isEmpty ? null : _hobbiesController.text),
        skills: drift.Value(
            _skillsController.text.isEmpty ? null : _skillsController.text),
        aspirations: drift.Value(_aspirationsController.text.isEmpty
            ? null
            : _aspirationsController.text),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['hobbies'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hobbies information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating hobbies information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Siblings Section Methods
  Widget _buildSiblingsView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow('Number of Siblings',
            orphan.numberOfSiblings?.toString() ?? 'Not specified'),
        _buildDetailRow(
            'Siblings Details', orphan.siblingsDetails ?? 'Not specified'),
      ],
    );
  }

  Widget _buildSiblingsEdit(Orphan? orphan) {
    return Column(
      children: [
        TextFormField(
          controller: _numberOfSiblingsController,
          decoration: const InputDecoration(
            labelText: 'Number of Siblings',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _siblingsDetailsController,
          decoration: const InputDecoration(
            labelText: 'Siblings Details',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _siblingsCommentsController,
          decoration: const InputDecoration(
            labelText: 'Additional Comments',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _saveSiblingsInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        numberOfSiblings: _numberOfSiblingsController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(
                int.tryParse(_numberOfSiblingsController.text.trim())),
        siblingsDetails: _siblingsDetailsController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(_siblingsDetailsController.text.trim()),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['siblings'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Siblings information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating siblings information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Additional Information Section Methods
  Widget _buildAdditionalView(Orphan orphan) {
    return Column(
      children: [
        _buildDetailRow('Additional Notes', orphan.additionalNotes ?? 'None'),
        _buildDetailRow('Urgent Needs', orphan.urgentNeeds ?? 'None'),
        _buildDetailRow(
            'Special Circumstances', orphan.specialCircumstances ?? 'None'),
      ],
    );
  }

  Widget _buildAdditionalEdit(Orphan? orphan) {
    return Column(
      children: [
        TextFormField(
          controller: _additionalNotesController,
          decoration: const InputDecoration(
            labelText: 'Additional Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _urgentNeedsController,
          decoration: const InputDecoration(
            labelText: 'Urgent Needs',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _specialCircumstancesController,
          decoration: const InputDecoration(
            labelText: 'Special Circumstances',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _saveAdditionalInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        additionalNotes: _additionalNotesController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(_additionalNotesController.text.trim()),
        urgentNeeds: _urgentNeedsController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(_urgentNeedsController.text.trim()),
        specialCircumstances:
            _specialCircumstancesController.text.trim().isEmpty
                ? drift.Value.absent()
                : drift.Value(_specialCircumstancesController.text.trim()),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['additional'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Additional information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating additional information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveAttachmentsInfo(
      Orphan orphan, OrphanRepository repository) async {
    try {
      // Generate orphan ID for document saving
      final orphanId = orphan.orphanId;

      // Declare allDocumentPaths outside try block for cleanup access
      List<String> allDocumentPaths = [];

      // Save specific documents
      if (_birthCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _birthCertificatePhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('birth_cert:$savedPath');
      }

      if (_deathCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _deathCertificatePhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('death_cert:$savedPath');
      }

      if (_orphanIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_orphanIdPhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('orphan_id:$savedPath');
      }

      if (_fatherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_fatherIdPhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('father_id:$savedPath');
      }

      if (_motherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_motherIdPhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('mother_id:$savedPath');
      }

      if (_familyIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_familyIdPhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('family_id:$savedPath');
      }

      if (_passportPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_passportPhoto!, orphanId);
        if (savedPath != null)
          allDocumentPaths.add('passport_photo:$savedPath');
      }

      if (_recentPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_recentPhoto!, orphanId);
        if (savedPath != null) allDocumentPaths.add('recent_photo:$savedPath');
      }

      // Save additional documents
      for (int i = 0; i < _additionalDocuments.length; i++) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _additionalDocuments[i], orphanId);
        if (savedPath != null) allDocumentPaths.add('additional_$i:$savedPath');
      }

      // Store document paths as comma-separated string
      final documentsPathString =
          allDocumentPaths.isNotEmpty ? allDocumentPaths.join(',') : null;

      final companion = OrphansCompanion(
        orphanId: drift.Value(orphan.orphanId),
        documentsPath: drift.Value(documentsPathString),
        lastUpdated: drift.Value(DateTime.now()),
      );

      await repository.updateOrphanWithCompanion(companion);

      setState(() {
        _editingSections['attachments'] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating documents: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, OrphanRepository repository) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this orphan? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await repository.deleteOrphan(widget.orphanId!);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Orphan deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting orphan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildAddOrphanForm(
      BuildContext context,
      OrphanRepository orphanRepository,
      SupervisorRepository supervisorRepository) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Orphan'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveNewOrphan(context, orphanRepository),
            tooltip: 'Save Orphan',
          ),
        ],
      ),
      body: FutureBuilder<List<Supervisor>>(
        future: supervisorRepository.getAllSupervisors(),
        builder: (context, supervisorSnapshot) {
          if (supervisorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use the same sections as view mode - truly unified!
                _buildAddModeSection('basic', 'Orphan Details', Icons.person,
                    () => _buildBasicInfoEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('family', 'Family Information',
                    Icons.family_restroom, () => _buildFamilyInfoEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('education', 'Education', Icons.school,
                    () => _buildEducationInfoEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('health', 'Health Information',
                    Icons.health_and_safety, () => _buildHealthInfoEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('address', 'Current Address',
                    Icons.location_on, () => _buildAddressEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('accommodation', 'Living Conditions',
                    Icons.home, () => _buildAccommodationEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection(
                    'islamic',
                    'Islamic Education & Personal Development',
                    Icons.mosque,
                    () => _buildIslamicEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('siblings', 'Siblings Information',
                    Icons.people, () => _buildSiblingsEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('additional', 'Additional Information',
                    Icons.note_add, () => _buildAdditionalEdit(null)),
                const SizedBox(height: 16),

                _buildAddModeSection('attachments', 'Documents & Attachments',
                    Icons.attach_file, () => _buildAttachmentsEdit()),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveNewOrphan(context, orphanRepository),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Create Orphan Record',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddBasicInfoForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Father\'s Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _grandfatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Grandfather\'s Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _familyNameController,
                decoration: const InputDecoration(
                  labelText: 'Family Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Gender>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 365 * 5)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedBirthDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedBirthDate != null
                        ? _formatDate(_selectedBirthDate!)
                        : 'Select Date',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddModeSection(String sectionKey, String title, IconData icon,
      Widget Function() editContent) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          // Section Header - simpler for add mode
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Content - always in edit mode for add
          Padding(
            padding: const EdgeInsets.all(16),
            child: editContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsEdit() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Documents Path',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: () {
                      // TODO: Implement file picker for documents
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('File picker not implemented yet')),
                      );
                    },
                  ),
                ),
                controller:
                    TextEditingController(), // TODO: Add proper controller
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement photo capture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Photo capture not implemented yet')),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement document upload
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Document upload not implemented yet')),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Documents'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddAddressForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _currentCountryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _currentCityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentPhoneNumberController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Future<void> _saveNewOrphan(
      BuildContext context, OrphanRepository repository) async {
    try {
      // Create new orphan with all the form data
      final newOrphan = OrphansCompanion.insert(
        firstName: _firstNameController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        grandfatherName: _grandfatherNameController.text.trim(),
        familyName: _familyNameController.text.trim(),
        gender: _selectedGender ?? Gender.male,
        dateOfBirth: _selectedBirthDate ?? DateTime.now(),
        status: _selectedStatus ?? OrphanStatus.active,
        supervisorId:
            'default-supervisor-id', // You'll need to handle supervisor selection
        lastUpdated: DateTime.now(),
        // Add all the other optional fields with drift.Value.absent() or actual values
        currentCountry: _currentCountryController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(_currentCountryController.text.trim()),
        currentCity: _currentCityController.text.trim().isEmpty
            ? drift.Value.absent()
            : drift.Value(_currentCityController.text.trim()),
        // Add more fields as needed...
      );

      await repository.createOrphan(newOrphan);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orphan created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating orphan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Document attachment methods
  Future<void> _selectDocumentPhoto(String documentType) async {
    try {
      final File? photoFile = await ImageService.selectPhoto();
      if (photoFile != null) {
        setState(() {
          switch (documentType) {
            case 'birth_certificate':
              _birthCertificatePhoto = photoFile;
              break;
            case 'death_certificate':
              _deathCertificatePhoto = photoFile;
              break;
            case 'orphan_id':
              _orphanIdPhoto = photoFile;
              break;
            case 'father_id':
              _fatherIdPhoto = photoFile;
              break;
            case 'mother_id':
              _motherIdPhoto = photoFile;
              break;
            case 'family_id':
              _familyIdPhoto = photoFile;
              break;
            case 'passport_photo':
              _passportPhoto = photoFile;
              break;
            case 'recent_photo':
              _recentPhoto = photoFile;
              break;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document attached successfully!')),
        );
      }
    } catch (e) {
      print('Error selecting document photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select photo: $e')),
      );
    }
  }

  void _removeDocumentPhoto(String documentType) {
    setState(() {
      switch (documentType) {
        case 'birth_certificate':
          _birthCertificatePhoto = null;
          break;
        case 'death_certificate':
          _deathCertificatePhoto = null;
          break;
        case 'orphan_id':
          _orphanIdPhoto = null;
          break;
        case 'father_id':
          _fatherIdPhoto = null;
          break;
        case 'mother_id':
          _motherIdPhoto = null;
          break;
        case 'family_id':
          _familyIdPhoto = null;
          break;
        case 'passport_photo':
          _passportPhoto = null;
          break;
        case 'recent_photo':
          _recentPhoto = null;
          break;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document removed')),
    );
  }

  Future<void> _selectAdditionalDocument() async {
    try {
      final File? photoFile = await ImageService.selectPhoto();
      if (photoFile != null) {
        setState(() {
          _additionalDocuments.add(photoFile);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Additional document attached!')),
        );
      }
    } catch (e) {
      print('Error selecting additional document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select photo: $e')),
      );
    }
  }

  void _removeAdditionalDocument(int index) {
    setState(() {
      _additionalDocuments.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Additional document removed')),
    );
  }

  Widget _buildDocumentAttachment({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? photo,
    required VoidCallback onSelect,
    required VoidCallback onRemove,
    required bool isRequired,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue.shade600, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (photo != null) ...[
              // Show attached photo preview
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        photo,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
            ] else ...[
              // Show attach button
              ElevatedButton.icon(
                onPressed: onSelect,
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Attach'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(80, 36),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
