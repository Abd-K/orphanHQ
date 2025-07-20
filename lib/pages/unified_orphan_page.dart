import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:io';
import 'package:path/path.dart' as path;
import '../database.dart';
import '../repositories/orphan_repository.dart';
import '../repositories/supervisor_repository.dart';
import '../services/image_service.dart';
import '../services/qr_code_service.dart';
import '../widgets/qr_code_widget.dart';

class UnifiedOrphanPage extends StatefulWidget {
  final String? orphanId; // null for create mode, id for view mode

  const UnifiedOrphanPage({super.key, this.orphanId});

  @override
  State<UnifiedOrphanPage> createState() => _UnifiedOrphanPageState();
}

class _UnifiedOrphanPageState extends State<UnifiedOrphanPage> {
  bool get isCreateMode => widget.orphanId == null;
  bool get isViewMode => !isCreateMode;

  final _formKey = GlobalKey<FormState>();

  // Basic Details Controllers - 4-part Arabic naming
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _grandfatherNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  String? _selectedSupervisorId;
  OrphanStatus _selectedStatus = OrphanStatus.active;

  // Father Details Controllers
  final _fatherDeathDayController = TextEditingController();
  final _fatherDeathMonthController = TextEditingController();
  final _fatherDeathYearController = TextEditingController();
  final _fatherCauseOfDeathController = TextEditingController();
  final _fatherOccupationController = TextEditingController();

  // Mother Details Controllers
  final _motherNameController = TextEditingController();
  bool? _motherAlive;
  final _motherDeathDayController = TextEditingController();
  final _motherDeathMonthController = TextEditingController();
  final _motherDeathYearController = TextEditingController();
  final _motherCauseOfDeathController = TextEditingController();
  final _motherOccupationController = TextEditingController();

  // Carer Details Controllers
  final _carerNameController = TextEditingController();
  final _carerRelationshipController = TextEditingController();
  final _carerContactController = TextEditingController();
  final _carerAddressController = TextEditingController();

  // Education Controllers
  EducationLevel? _educationLevel;
  final _schoolNameController = TextEditingController();
  final _gradeController = TextEditingController();
  bool? _needsEducationalSupport;

  // Health Controllers
  HealthStatus? _healthStatus;
  final _medicalConditionsController = TextEditingController();
  final _medicationsController = TextEditingController();
  bool? _needsMedicalSupport;

  // Accommodation Controllers
  AccommodationType? _accommodationType;
  final _accommodationAddressController = TextEditingController();
  bool? _needsHousingSupport;

  // Islamic Education Controllers
  final _quranMemorizationController = TextEditingController();
  bool? _attendsIslamicSchool;
  final _islamicEducationLevelController = TextEditingController();

  // Hobbies Controllers
  final _hobbiesController = TextEditingController();
  final _skillsController = TextEditingController();
  final _aspirationsController = TextEditingController();

  // Siblings Controllers
  final _numberOfSiblingsController = TextEditingController();
  final _siblingsDetailsController = TextEditingController();

  // Additional Info Controllers
  final _additionalNotesController = TextEditingController();
  final _urgentNeedsController = TextEditingController();

  // Additional Comments Controllers for each section
  final _orphanDetailsCommentsController = TextEditingController();
  final _fatherDetailsCommentsController = TextEditingController();
  final _motherDetailsCommentsController = TextEditingController();
  final _carerDetailsCommentsController = TextEditingController();
  final _educationCommentsController = TextEditingController();
  final _healthCommentsController = TextEditingController();
  final _accommodationCommentsController = TextEditingController();
  final _islamicEducationCommentsController = TextEditingController();
  final _hobbiesCommentsController = TextEditingController();
  final _siblingsCommentsController = TextEditingController();

  // Document attachments management - specific documents
  File? _birthCertificatePhoto;
  File? _deathCertificatePhoto;
  File? _orphanIdPhoto;
  File? _fatherIdPhoto;
  File? _motherIdPhoto;
  File? _familyIdPhoto;
  File? _passportPhoto;
  File? _recentPhoto;
  List<File> _additionalDocuments = [];

  // Tooltip management
  OverlayEntry? _tooltipOverlay;

  // Section expansion states for create mode
  final Map<String, bool> _sectionExpanded = {
    'orphan': true, // First section starts expanded
    'father': false,
    'mother': false,
    'carer': false,
    'education': false,
    'health': false,
    'accommodation': false,
    'islamic': false,
    'hobbies': false,
    'siblings': false,
    'additional': false,
    'attachments': false,
  };

  // Edit states for view mode
  final Map<String, bool> _sectionEditing = {
    'orphan': false,
    'father': false,
    'mother': false,
    'carer': false,
    'education': false,
    'health': false,
    'accommodation': false,
    'islamic': false,
    'hobbies': false,
    'siblings': false,
    'additional': false,
  };

  Orphan? _orphan;
  bool _isLoading = true;
  String? _qrCodeData;

  @override
  void initState() {
    super.initState();
    if (isViewMode) {
      _loadOrphan();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadOrphan() async {
    final orphanRepository = context.read<OrphanRepository>();

    final allOrphans = await orphanRepository.getAllOrphans().first;
    final orphan =
        allOrphans.where((o) => o.orphanId == widget.orphanId).firstOrNull;

    if (orphan != null) {
      setState(() {
        _orphan = orphan;
        _populateControllers(orphan);
        _isLoading = false;
      });

      // Load QR code data and file
      await _loadQRCodeData(orphan);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadQRCodeData(Orphan orphan) async {
    try {
      // Generate QR code data
      _qrCodeData = QRCodeService.createQRData(orphan);

      // Try to load existing QR code data
      final existingQRData = await QRCodeService.getQRCodeData(orphan.orphanId);

      // If no QR code data exists, generate one
      if (existingQRData == null && orphan.qrCodePath == null) {
        final orphanRepository = context.read<OrphanRepository>();
        await orphanRepository.regenerateQRCode(orphan.orphanId);
      }

      setState(() {});
    } catch (e) {
      print('Error loading QR code data: $e');
    }
  }

  void _populateControllers(Orphan orphan) {
    _firstNameController.text = orphan.firstName;
    _fatherNameController.text = orphan.fatherName;
    _grandfatherNameController.text = orphan.grandfatherName;
    _familyNameController.text = orphan.familyName;

    // Parse date of birth
    final dob = orphan.dateOfBirth;
    _dayController.text = dob.day.toString();
    _monthController.text = dob.month.toString();
    _yearController.text = dob.year.toString();

    _selectedStatus = orphan.status;
    _selectedSupervisorId = orphan.supervisorId;

    // Father details
    if (orphan.fatherDateOfDeath != null) {
      final fatherDeath = orphan.fatherDateOfDeath!;
      _fatherDeathDayController.text = fatherDeath.day.toString();
      _fatherDeathMonthController.text = fatherDeath.month.toString();
      _fatherDeathYearController.text = fatherDeath.year.toString();
    }
    _fatherCauseOfDeathController.text = orphan.fatherCauseOfDeath ?? '';
    _fatherOccupationController.text = orphan.fatherWork ?? '';

    // Mother details
    _motherNameController.text = orphan.motherFirstName ?? '';
    _motherAlive = orphan.motherAlive;
    if (orphan.motherDateOfDeath != null) {
      final motherDeath = orphan.motherDateOfDeath!;
      _motherDeathDayController.text = motherDeath.day.toString();
      _motherDeathMonthController.text = motherDeath.month.toString();
      _motherDeathYearController.text = motherDeath.year.toString();
    }
    _motherCauseOfDeathController.text = orphan.motherCauseOfDeath ?? '';
    _motherOccupationController.text = orphan.motherWork ?? '';

    // Guardian/Carer details
    _carerNameController.text = orphan.guardianName ?? '';
    _carerRelationshipController.text = orphan.guardianRelationship ?? '';

    // Education
    _educationLevel = orphan.educationLevel;
    _schoolNameController.text = orphan.schoolName ?? '';
    _gradeController.text = orphan.grade ?? '';

    // Health
    _healthStatus = orphan.healthStatus;
    _medicalConditionsController.text = orphan.medicalConditions ?? '';
    _medicationsController.text = orphan.medications ?? '';
    _needsMedicalSupport = orphan.needsMedicalSupport;

    // Accommodation
    _accommodationType = orphan.accommodationType;
    _accommodationAddressController.text = orphan.accommodationAddress ?? '';
    _needsHousingSupport = orphan.needsHousingSupport;

    // Islamic Education & Hobbies
    _quranMemorizationController.text = orphan.quranMemorization ?? '';
    _attendsIslamicSchool = orphan.attendsIslamicSchool;
    _islamicEducationLevelController.text = orphan.islamicEducationLevel ?? '';
    _hobbiesController.text = orphan.hobbies ?? '';
    _skillsController.text = orphan.skills ?? '';
    _aspirationsController.text = orphan.aspirations ?? '';

    // Siblings & Additional
    _numberOfSiblingsController.text =
        orphan.numberOfSiblings?.toString() ?? '';
    _siblingsDetailsController.text = orphan.siblingsDetails ?? '';
    _additionalNotesController.text = orphan.additionalNotes ?? '';
    _urgentNeedsController.text = orphan.urgentNeeds ?? '';

    // Load document attachments
    _loadDocumentAttachments(orphan);
  }

  @override
  void dispose() {
    // Dispose all controllers
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _familyNameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _fatherDeathDayController.dispose();
    _fatherDeathMonthController.dispose();
    _fatherDeathYearController.dispose();
    _fatherCauseOfDeathController.dispose();
    _fatherOccupationController.dispose();
    _motherNameController.dispose();
    _motherDeathDayController.dispose();
    _motherDeathMonthController.dispose();
    _motherDeathYearController.dispose();
    _motherCauseOfDeathController.dispose();
    _motherOccupationController.dispose();
    _carerNameController.dispose();
    _carerRelationshipController.dispose();
    _carerContactController.dispose();
    _carerAddressController.dispose();
    _schoolNameController.dispose();
    _gradeController.dispose();
    _medicalConditionsController.dispose();
    _medicationsController.dispose();
    _accommodationAddressController.dispose();
    _quranMemorizationController.dispose();
    _islamicEducationLevelController.dispose();
    _hobbiesController.dispose();
    _skillsController.dispose();
    _aspirationsController.dispose();
    _numberOfSiblingsController.dispose();
    _siblingsDetailsController.dispose();
    _additionalNotesController.dispose();
    _urgentNeedsController.dispose();
    _orphanDetailsCommentsController.dispose();
    _fatherDetailsCommentsController.dispose();
    _motherDetailsCommentsController.dispose();
    _carerDetailsCommentsController.dispose();
    _educationCommentsController.dispose();
    _healthCommentsController.dispose();
    _accommodationCommentsController.dispose();
    _islamicEducationCommentsController.dispose();
    _hobbiesCommentsController.dispose();
    _siblingsCommentsController.dispose();
    _hideTooltip(); // Clean up any active tooltip
    super.dispose();
  }

  // Tooltip helper methods for cursor-following tooltips
  void _showTooltip(BuildContext context, Offset position, String message) {
    _hideTooltip(); // Remove any existing tooltip

    _tooltipOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 10, // Small offset from cursor
        top: position.dy - 30, // Show above cursor
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_tooltipOverlay!);
  }

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  // Helper method for compact view display
  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF8B949E) : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF8B949E) : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: TextStyle(
                color: value.isEmpty
                    ? (isDark ? const Color(0xFF6E7681) : Colors.grey.shade400)
                    : (valueColor ??
                        (isDark ? const Color(0xFFF0F6FC) : Colors.black87)),
                fontWeight:
                    valueColor != null ? FontWeight.w500 : FontWeight.normal,
                fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanProfileHeader() {
    if (_orphan == null) return const SizedBox.shrink();

    String fullName =
        '${_firstNameController.text} ${_fatherNameController.text} ${_grandfatherNameController.text} ${_familyNameController.text}'
            .trim();
    if (fullName.isEmpty) fullName = 'Unknown Orphan';

    // Get initials for fallback
    String initials = '';
    if (_firstNameController.text.isNotEmpty) {
      initials += _firstNameController.text[0];
    }
    if (_fatherNameController.text.isNotEmpty) {
      initials += _fatherNameController.text[0];
    }
    if (initials.isEmpty) initials = '?';

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Centered profile content (unaffected by QR code)
            Center(
              child: Column(
                children: [
                  // Profile Picture or Avatar
                  Container(
                    width: 250,
                    height: 250,
                    child: _recentPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(125),
                            child: Image.file(
                              _recentPhoto!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return CircleAvatar(
                                  radius: 125,
                                  backgroundColor: Colors.grey.shade400,
                                  child: const Icon(
                                    Icons.error,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          )
                        : CircleAvatar(
                            radius: 125,
                            backgroundColor:
                                _selectedStatus == OrphanStatus.active
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade600,
                            child: Text(
                              initials.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Date of birth
                  Text(
                    'Born ${_dayController.text}/${_monthController.text}/${_yearController.text}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedStatus == OrphanStatus.active
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF0D4429)
                              : Colors.green.shade100)
                          : _selectedStatus == OrphanStatus.missing
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2D1B1B)
                                  : Colors.red.shade100)
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF3D1B1B)
                                  : Colors.orange.shade100),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _selectedStatus.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        color: _selectedStatus == OrphanStatus.active
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF3FB950)
                                : Colors.green.shade700)
                            : _selectedStatus == OrphanStatus.missing
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFFF78166)
                                    : Colors.red.shade700)
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFFF78166)
                                    : Colors.orange.shade700),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Supervisor info
                  if (_selectedSupervisorId != null) ...[
                    const SizedBox(height: 12),
                    FutureBuilder<Supervisor?>(
                      future: context
                          .read<SupervisorRepository>()
                          .getSupervisorById(_selectedSupervisorId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final supervisor = snapshot.data!;
                          return Text(
                            'Supervisor: ${supervisor.firstName} ${supervisor.familyName}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ],
              ),
            ),
            // QR Code positioned absolutely in top-right corner
            if (_qrCodeData != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[600]!
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QRCodeWidget(
                        orphanId: _orphan!.orphanId,
                        qrData: _qrCodeData!,
                        size: 180.0,
                        showBorder: false,
                        showDownloadButton: true,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QR Code',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to view',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isCreateMode ? 'Add New Orphan' : 'Orphan Details'),
        actions: isCreateMode
            ? [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (isViewMode && _orphan != null) ...[
                    _buildOrphanProfileHeader(),
                    const SizedBox(height: 16),
                  ],
                  _buildOrphanDetailsSection(),
                  const SizedBox(height: 16),
                  _buildSupervisorSection(),
                  const SizedBox(height: 16),
                  _buildFatherDetailsSection(),
                  const SizedBox(height: 16),
                  _buildMotherDetailsSection(),
                  const SizedBox(height: 16),
                  _buildCarerDetailsSection(),
                  const SizedBox(height: 16),
                  _buildEducationSection(),
                  const SizedBox(height: 16),
                  _buildHealthSection(),
                  const SizedBox(height: 16),
                  _buildAccommodationSection(),
                  const SizedBox(height: 16),
                  _buildIslamicEducationSection(),
                  const SizedBox(height: 16),
                  _buildHobbiesSection(),
                  const SizedBox(height: 16),
                  _buildSiblingsSection(),
                  const SizedBox(height: 16),
                  _buildAdditionalInfoSection(),
                  const SizedBox(height: 16),
                  _buildAttachmentsSection(),
                  if (isCreateMode) ...[
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String key,
    required String title,
    required IconData icon,
    required Widget content,
    bool hasEdit = true,
    String? tooltip,
  }) {
    if (isCreateMode) {
      return _buildCollapsibleSection(key, title, icon, content, tooltip);
    } else {
      return _buildViewSection(key, title, icon, content, hasEdit, tooltip);
    }
  }

  Widget _buildCollapsibleSection(String key, String title, IconData icon,
      Widget content, String? tooltip) {
    final isExpanded = _sectionExpanded[key] ?? false;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          Tooltip(
            message: tooltip ?? title,
            child: InkWell(
              onTap: () {
                setState(() {
                  _sectionExpanded[key] = !isExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF30363D) // Darker header in dark mode
                      : Colors.blue.shade50,
                  borderRadius: isExpanded
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )
                      : BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.blue.shade300
                              : Colors.blue.shade700,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildViewSection(String key, String title, IconData icon,
      Widget content, bool hasEdit, String? tooltip) {
    final isEditing = _sectionEditing[key] ?? false;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          Tooltip(
            message: tooltip ?? title,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF30363D) // Darker header in dark mode
                    : Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.blue.shade300
                            : Colors.blue.shade700,
                      ),
                    ),
                  ),
                  if (hasEdit) ...[
                    if (isEditing) ...[
                      TextButton(
                        onPressed: () => _cancelEdit(key),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _saveSection(key),
                        child: const Text('Save'),
                      ),
                    ] else
                      ElevatedButton(
                        onPressed: () => _startEdit(key),
                        child: const Text('Edit'),
                      ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  void _startEdit(String key) {
    setState(() {
      _sectionEditing[key] = true;
    });
  }

  void _cancelEdit(String key) {
    setState(() {
      _sectionEditing[key] = false;
    });
    if (_orphan != null) {
      _populateControllers(_orphan!);
    }
  }

  Future<void> _saveSection(String key) async {
    if (_orphan != null) {
      await _updateOrphan();
      await _loadOrphan();

      setState(() {
        _sectionEditing[key] = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse date of birth
      final day = int.tryParse(_dayController.text) ?? 1;
      final month = int.tryParse(_monthController.text) ?? 1;
      final year = int.tryParse(_yearController.text) ?? 2000;
      final birthDate = DateTime(year, month, day);

      // Parse father's death date if provided
      DateTime? fatherDeathDate;
      if (_fatherDeathDayController.text.isNotEmpty &&
          _fatherDeathMonthController.text.isNotEmpty &&
          _fatherDeathYearController.text.isNotEmpty) {
        final fatherDeathDay =
            int.tryParse(_fatherDeathDayController.text) ?? 1;
        final fatherDeathMonth =
            int.tryParse(_fatherDeathMonthController.text) ?? 1;
        final fatherDeathYear =
            int.tryParse(_fatherDeathYearController.text) ?? 2000;
        fatherDeathDate =
            DateTime(fatherDeathYear, fatherDeathMonth, fatherDeathDay);
      }

      // Parse mother's death date if provided
      DateTime? motherDeathDate;
      if (_motherDeathDayController.text.isNotEmpty &&
          _motherDeathMonthController.text.isNotEmpty &&
          _motherDeathYearController.text.isNotEmpty) {
        final motherDeathDay =
            int.tryParse(_motherDeathDayController.text) ?? 1;
        final motherDeathMonth =
            int.tryParse(_motherDeathMonthController.text) ?? 1;
        final motherDeathYear =
            int.tryParse(_motherDeathYearController.text) ?? 2000;
        motherDeathDate =
            DateTime(motherDeathYear, motherDeathMonth, motherDeathDay);
      }

      final companion = OrphansCompanion.insert(
        firstName: _firstNameController.text,
        lastName: drift.Value(_familyNameController.text), // Legacy field
        fatherName: _fatherNameController.text,
        grandfatherName: _grandfatherNameController.text,
        familyName: _familyNameController.text,
        gender: Gender.male, // Default - you may want to add gender selection
        dateOfBirth: birthDate,
        status: _selectedStatus,
        lastUpdated: DateTime.now(),
        supervisorId: drift.Value(_selectedSupervisorId),

        // Father details
        fatherDateOfDeath: fatherDeathDate != null
            ? drift.Value(fatherDeathDate)
            : const drift.Value.absent(),
        fatherCauseOfDeath: _fatherCauseOfDeathController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_fatherCauseOfDeathController.text),
        fatherWork: _fatherOccupationController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_fatherOccupationController.text),

        // Mother details
        motherFirstName: _motherNameController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_motherNameController.text),
        motherAlive: _motherAlive != null
            ? drift.Value(_motherAlive!)
            : const drift.Value.absent(),
        motherDateOfDeath: motherDeathDate != null
            ? drift.Value(motherDeathDate)
            : const drift.Value.absent(),
        motherCauseOfDeath: _motherCauseOfDeathController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_motherCauseOfDeathController.text),
        motherWork: _motherOccupationController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_motherOccupationController.text),

        // Guardian details
        guardianName: _carerNameController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_carerNameController.text),
        guardianRelationship: _carerRelationshipController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_carerRelationshipController.text),

        // Education details
        educationLevel: _educationLevel != null
            ? drift.Value(_educationLevel!)
            : const drift.Value.absent(),
        schoolName: _schoolNameController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_schoolNameController.text),
        grade: _gradeController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_gradeController.text),

        // Health details
        healthStatus: _healthStatus != null
            ? drift.Value(_healthStatus!)
            : const drift.Value.absent(),
        medicalConditions: _medicalConditionsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_medicalConditionsController.text),
        medications: _medicationsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_medicationsController.text),
        needsMedicalSupport: _needsMedicalSupport != null
            ? drift.Value(_needsMedicalSupport!)
            : const drift.Value.absent(),

        // Accommodation details
        accommodationType: _accommodationType != null
            ? drift.Value(_accommodationType!)
            : const drift.Value.absent(),
        accommodationAddress: _accommodationAddressController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_accommodationAddressController.text),
        needsHousingSupport: _needsHousingSupport != null
            ? drift.Value(_needsHousingSupport!)
            : const drift.Value.absent(),

        // Islamic Education details
        quranMemorization: _quranMemorizationController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_quranMemorizationController.text),
        attendsIslamicSchool: _attendsIslamicSchool != null
            ? drift.Value(_attendsIslamicSchool!)
            : const drift.Value.absent(),
        islamicEducationLevel: _islamicEducationLevelController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_islamicEducationLevelController.text),

        // Hobbies and Skills
        hobbies: _hobbiesController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_hobbiesController.text),
        skills: _skillsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_skillsController.text),
        aspirations: _aspirationsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_aspirationsController.text),

        // Siblings
        numberOfSiblings: _numberOfSiblingsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(int.tryParse(_numberOfSiblingsController.text) ?? 0),
        siblingsDetails: _siblingsDetailsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_siblingsDetailsController.text),

        // Additional notes
        additionalNotes: _additionalNotesController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_additionalNotesController.text),
        urgentNeeds: _urgentNeedsController.text.isEmpty
            ? const drift.Value.absent()
            : drift.Value(_urgentNeedsController.text),
      );

      final orphanRepository = context.read<OrphanRepository>();
      final orphanId = await orphanRepository.createOrphan(companion);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Orphan created successfully! QR code generated.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the orphan's profile
        // orphanId is the database row ID, we need to find the actual orphan ID
        final createdOrphan =
            await orphanRepository.findRecentlyCreatedOrphan();
        if (createdOrphan != null) {
          context.push('/orphan/${createdOrphan.orphanId}');
        } else {
          // Fallback to orphan list if we can't find the created orphan
          context.push('/orphans');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating orphan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateOrphan() async {
    if (_orphan == null) return;

    final orphanRepository = context.read<OrphanRepository>();

    // Parse birth date
    final day = int.tryParse(_dayController.text) ?? _orphan!.dateOfBirth.day;
    final month =
        int.tryParse(_monthController.text) ?? _orphan!.dateOfBirth.month;
    final year =
        int.tryParse(_yearController.text) ?? _orphan!.dateOfBirth.year;
    final birthDate = DateTime(year, month, day);

    // Parse father death date if provided
    DateTime? fatherDeathDate;
    if (_fatherDeathDayController.text.isNotEmpty &&
        _fatherDeathMonthController.text.isNotEmpty &&
        _fatherDeathYearController.text.isNotEmpty) {
      final fDay = int.tryParse(_fatherDeathDayController.text) ?? 1;
      final fMonth = int.tryParse(_fatherDeathMonthController.text) ?? 1;
      final fYear = int.tryParse(_fatherDeathYearController.text) ?? 2000;
      fatherDeathDate = DateTime(fYear, fMonth, fDay);
    }

    // Parse mother death date if provided
    DateTime? motherDeathDate;
    if (_motherDeathDayController.text.isNotEmpty &&
        _motherDeathMonthController.text.isNotEmpty &&
        _motherDeathYearController.text.isNotEmpty) {
      final mDay = int.tryParse(_motherDeathDayController.text) ?? 1;
      final mMonth = int.tryParse(_motherDeathMonthController.text) ?? 1;
      final mYear = int.tryParse(_motherDeathYearController.text) ?? 2000;
      motherDeathDate = DateTime(mYear, mMonth, mDay);
    }

    final companion = OrphansCompanion(
      orphanId: drift.Value(_orphan!.orphanId),
      firstName: drift.Value(_firstNameController.text),
      fatherName: drift.Value(_fatherNameController.text),
      grandfatherName: drift.Value(_grandfatherNameController.text),
      familyName: drift.Value(_familyNameController.text),
      dateOfBirth: drift.Value(birthDate),
      status: drift.Value(_selectedStatus),
      lastUpdated: drift.Value(DateTime.now()),
      supervisorId:
          drift.Value(_selectedSupervisorId), // FIX: Include supervisor update

      // Father details
      fatherDateOfDeath: fatherDeathDate != null
          ? drift.Value(fatherDeathDate)
          : const drift.Value.absent(),
      fatherCauseOfDeath: _fatherCauseOfDeathController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_fatherCauseOfDeathController.text),
      fatherWork: _fatherOccupationController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_fatherOccupationController.text),

      // Mother details
      motherFirstName: _motherNameController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_motherNameController.text),
      motherAlive: _motherAlive != null
          ? drift.Value(_motherAlive!)
          : const drift.Value.absent(),
      motherDateOfDeath: motherDeathDate != null
          ? drift.Value(motherDeathDate)
          : const drift.Value.absent(),
      motherCauseOfDeath: _motherCauseOfDeathController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_motherCauseOfDeathController.text),
      motherWork: _motherOccupationController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_motherOccupationController.text),

      // Guardian/Carer details
      guardianName: _carerNameController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_carerNameController.text),
      guardianRelationship: _carerRelationshipController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_carerRelationshipController.text),

      // Education
      educationLevel: _educationLevel != null
          ? drift.Value(_educationLevel!)
          : const drift.Value.absent(),
      schoolName: _schoolNameController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_schoolNameController.text),
      grade: _gradeController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_gradeController.text),

      // Health
      healthStatus: _healthStatus != null
          ? drift.Value(_healthStatus!)
          : const drift.Value.absent(),
      medicalConditions: _medicalConditionsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_medicalConditionsController.text),
      medications: _medicationsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_medicationsController.text),
      needsMedicalSupport: _needsMedicalSupport != null
          ? drift.Value(_needsMedicalSupport!)
          : const drift.Value.absent(),

      // Accommodation
      accommodationType: _accommodationType != null
          ? drift.Value(_accommodationType!)
          : const drift.Value.absent(),
      accommodationAddress: _accommodationAddressController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_accommodationAddressController.text),
      needsHousingSupport: _needsHousingSupport != null
          ? drift.Value(_needsHousingSupport!)
          : const drift.Value.absent(),

      // Islamic Education & Hobbies
      quranMemorization: _quranMemorizationController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_quranMemorizationController.text),
      attendsIslamicSchool: _attendsIslamicSchool != null
          ? drift.Value(_attendsIslamicSchool!)
          : const drift.Value.absent(),
      islamicEducationLevel: _islamicEducationLevelController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_islamicEducationLevelController.text),
      hobbies: _hobbiesController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_hobbiesController.text),
      skills: _skillsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_skillsController.text),
      aspirations: _aspirationsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_aspirationsController.text),

      // Siblings & Additional
      numberOfSiblings: _numberOfSiblingsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(int.tryParse(_numberOfSiblingsController.text)),
      siblingsDetails: _siblingsDetailsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_siblingsDetailsController.text),
      additionalNotes: _additionalNotesController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_additionalNotesController.text),
      urgentNeeds: _urgentNeedsController.text.isEmpty
          ? const drift.Value.absent()
          : drift.Value(_urgentNeedsController.text),
    );

    // Save document attachments first and get the paths
    final documentPaths =
        await _saveDocumentAttachmentsAndGetPaths(_orphan!.orphanId);

    // Update the companion to include document paths if we have any
    final updatedCompanion = documentPaths.isNotEmpty
        ? companion.copyWith(documentsPath: drift.Value(documentPaths))
        : companion;

    await orphanRepository.updateOrphanWithCompanion(updatedCompanion);
  }

  // All section builders with Arabic tooltips
  Widget _buildOrphanDetailsSection() {
    return _buildSection(
      key: 'orphan',
      title: 'Orphan Details',
      icon: Icons.child_care,
      content: _buildOrphanDetailsContent(),
      tooltip: 'تفاصيل اليتيم',
    );
  }

  Widget _buildOrphanDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['orphan'] ?? false);
    final theme = Theme.of(context);

    // Helper function to create styled TextFormField
    Widget _buildStyledTextField({
      required TextEditingController controller,
      required String labelText,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
      int? maxLines,
    }) {
      return TextFormField(
        controller: controller,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(labelText: labelText),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
      );
    }

    if (isEditing) {
      return Column(
        children: [
          // 4-part Arabic name structure
          MouseRegion(
            onEnter: (event) =>
                _showTooltip(context, event.position, 'الاسم الأول'),
            onExit: (event) => _hideTooltip(),
            child: _buildStyledTextField(
              controller: _firstNameController,
              labelText: 'First Name *',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (event) =>
                _showTooltip(context, event.position, 'اسم الوالد'),
            onExit: (event) => _hideTooltip(),
            child: _buildStyledTextField(
              controller: _fatherNameController,
              labelText: "Father's Name *",
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (event) =>
                _showTooltip(context, event.position, 'اسم الجد'),
            onExit: (event) => _hideTooltip(),
            child: _buildStyledTextField(
              controller: _grandfatherNameController,
              labelText: "Grandfather's Name *",
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (event) =>
                _showTooltip(context, event.position, 'اسم العائلة'),
            onExit: (event) => _hideTooltip(),
            child: _buildStyledTextField(
              controller: _familyNameController,
              labelText: 'Family Name *',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Date of Birth *',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    onEnter: (event) =>
                        _showTooltip(context, event.position, 'اليوم'),
                    onExit: (event) => _hideTooltip(),
                    child: _buildStyledTextField(
                      controller: _dayController,
                      labelText: 'Day',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MouseRegion(
                    onEnter: (event) =>
                        _showTooltip(context, event.position, 'الشهر'),
                    onExit: (event) => _hideTooltip(),
                    child: _buildStyledTextField(
                      controller: _monthController,
                      labelText: 'Month',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MouseRegion(
                    onEnter: (event) =>
                        _showTooltip(context, event.position, 'السنة'),
                    onExit: (event) => _hideTooltip(),
                    child: _buildStyledTextField(
                      controller: _yearController,
                      labelText: 'Year',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (event) => _showTooltip(context, event.position, 'الحالة'),
            onExit: (event) => _hideTooltip(),
            child: DropdownButtonFormField<OrphanStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: OrphanStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Tooltip(
            message: 'تعليقات إضافية',
            child: _buildStyledTextField(
              controller: _orphanDetailsCommentsController,
              labelText: 'Additional Comments',
              maxLines: 3,
            ),
          ),
        ],
      );
    } else {
      // Compact view mode
      String dateOfBirth = '';
      if (_dayController.text.isNotEmpty &&
          _monthController.text.isNotEmpty &&
          _yearController.text.isNotEmpty) {
        dateOfBirth =
            '${_dayController.text}/${_monthController.text}/${_yearController.text}';
      }

      return Column(
        children: [
          _buildInfoRow(Icons.person, 'First Name', _firstNameController.text),
          _buildInfoRow(Icons.person_outline, "Father's Name",
              _fatherNameController.text),
          _buildInfoRow(Icons.family_restroom, "Grandfather's Name",
              _grandfatherNameController.text),
          _buildInfoRow(Icons.group, 'Family Name', _familyNameController.text),
          _buildInfoRow(Icons.cake, 'Date of Birth', dateOfBirth),
          _buildInfoRow(
            Icons.check_circle,
            'Status',
            _selectedStatus.toString().split('.').last.toUpperCase(),
            valueColor: _selectedStatus == OrphanStatus.active
                ? Colors.green
                : _selectedStatus == OrphanStatus.missing
                    ? Colors.red
                    : Colors.orange,
          ),
          if (_orphanDetailsCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _orphanDetailsCommentsController.text),
        ],
      );
    }
  }

  Widget _buildFatherDetailsSection() {
    return _buildSection(
      key: 'father',
      title: 'Father Details',
      icon: Icons.person,
      content: _buildFatherDetailsContent(),
      tooltip: 'تفاصيل الوالد',
    );
  }

  Widget _buildFatherDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['father'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          Tooltip(
            message: 'اسم الوالد',
            child: TextFormField(
              controller: _fatherNameController,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
              ),
              decoration: const InputDecoration(labelText: "Father's Name *"),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Date of Death',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _fatherDeathDayController,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    decoration: const InputDecoration(labelText: 'Day'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _fatherDeathMonthController,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    decoration: const InputDecoration(labelText: 'Month'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _fatherDeathYearController,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    decoration: const InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fatherCauseOfDeathController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Cause of Death'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fatherOccupationController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Occupation'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fatherDetailsCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String fatherDeathDate = '';
      if (_fatherDeathDayController.text.isNotEmpty &&
          _fatherDeathMonthController.text.isNotEmpty &&
          _fatherDeathYearController.text.isNotEmpty) {
        fatherDeathDate =
            '${_fatherDeathDayController.text}/${_fatherDeathMonthController.text}/${_fatherDeathYearController.text}';
      }

      return Column(
        children: [
          _buildInfoRow(
              Icons.person, "Father's Name", _fatherNameController.text),
          _buildInfoRow(Icons.calendar_today, 'Date of Death', fatherDeathDate),
          _buildInfoRow(Icons.medical_information, 'Cause of Death',
              _fatherCauseOfDeathController.text),
          _buildInfoRow(
              Icons.work, 'Occupation', _fatherOccupationController.text),
          if (_fatherDetailsCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _fatherDetailsCommentsController.text),
        ],
      );
    }
  }

  Widget _buildMotherDetailsSection() {
    return _buildSection(
      key: 'mother',
      title: 'Mother Details',
      icon: Icons.person_outline,
      content: _buildMotherDetailsContent(),
      tooltip: 'تفاصيل الوالدة',
    );
  }

  Widget _buildMotherDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['mother'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _motherNameController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: "Mother's Name"),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _motherAlive,
            decoration: const InputDecoration(labelText: 'Mother Alive'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) => setState(() => _motherAlive = value),
          ),
          const SizedBox(height: 16),
          if (_motherAlive == false) ...[
            const Text('Date of Death',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _motherDeathDayController,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      decoration: const InputDecoration(labelText: 'Day'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _motherDeathMonthController,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      decoration: const InputDecoration(labelText: 'Month'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _motherDeathYearController,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motherCauseOfDeathController,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
              ),
              decoration: const InputDecoration(labelText: 'Cause of Death'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _motherOccupationController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Occupation'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _motherDetailsCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String motherAliveText =
          _motherAlive == null ? '' : (_motherAlive! ? 'Yes' : 'No');
      String motherDeathDate = '';
      if (_motherDeathDayController.text.isNotEmpty &&
          _motherDeathMonthController.text.isNotEmpty &&
          _motherDeathYearController.text.isNotEmpty) {
        motherDeathDate =
            '${_motherDeathDayController.text}/${_motherDeathMonthController.text}/${_motherDeathYearController.text}';
      }

      return Column(
        children: [
          _buildInfoRow(Icons.person_outline, "Mother's Name",
              _motherNameController.text),
          _buildInfoRow(Icons.favorite, 'Mother Alive', motherAliveText,
              valueColor: _motherAlive == true
                  ? Colors.green
                  : (_motherAlive == false ? Colors.orange : null)),
          if (_motherAlive == false && motherDeathDate.isNotEmpty)
            _buildInfoRow(
                Icons.calendar_today, 'Date of Death', motherDeathDate),
          if (_motherAlive == false &&
              _motherCauseOfDeathController.text.isNotEmpty)
            _buildInfoRow(Icons.medical_information, 'Cause of Death',
                _motherCauseOfDeathController.text),
          _buildInfoRow(
              Icons.work, 'Occupation', _motherOccupationController.text),
          if (_motherDetailsCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _motherDetailsCommentsController.text),
        ],
      );
    }
  }

  Widget _buildCarerDetailsSection() {
    return _buildSection(
      key: 'carer',
      title: 'Carer Details',
      icon: Icons.family_restroom,
      content: _buildCarerDetailsContent(),
      tooltip: 'تفاصيل المُربي',
    );
  }

  Widget _buildCarerDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['carer'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _carerNameController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Carer Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _carerRelationshipController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration:
                const InputDecoration(labelText: 'Relationship to Orphan'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _carerContactController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Contact Information'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _carerAddressController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _carerDetailsCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.person, 'Carer Name', _carerNameController.text),
          _buildInfoRow(Icons.family_restroom, 'Relationship to Orphan',
              _carerRelationshipController.text),
          _buildInfoRow(Icons.contact_phone, 'Contact Information',
              _carerContactController.text),
          _buildInfoRow(
              Icons.location_on, 'Address', _carerAddressController.text),
          if (_carerDetailsCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _carerDetailsCommentsController.text),
        ],
      );
    }
  }

  Widget _buildEducationSection() {
    return _buildSection(
      key: 'education',
      title: 'Education',
      icon: Icons.school,
      content: _buildEducationContent(),
      tooltip: 'التعليم',
    );
  }

  Widget _buildEducationContent() {
    final isEditing = isCreateMode || (_sectionEditing['education'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          DropdownButtonFormField<EducationLevel>(
            value: _educationLevel,
            decoration: const InputDecoration(labelText: 'Education Level'),
            items: EducationLevel.values.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level
                    .toString()
                    .split('.')
                    .last
                    .replaceAll('_', ' ')
                    .toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => setState(() => _educationLevel = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _schoolNameController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'School Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _gradeController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Grade'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _needsEducationalSupport,
            decoration:
                const InputDecoration(labelText: 'Needs Educational Support'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) =>
                setState(() => _needsEducationalSupport = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _educationCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String educationLevelText = _educationLevel
              ?.toString()
              .split('.')
              .last
              .replaceAll('_', ' ')
              .toUpperCase() ??
          '';

      String needsSupport = _needsEducationalSupport == null
          ? ''
          : (_needsEducationalSupport! ? 'Yes' : 'No');

      return Column(
        children: [
          _buildInfoRow(Icons.school, 'Education Level', educationLevelText),
          _buildInfoRow(
              Icons.business, 'School Name', _schoolNameController.text),
          _buildInfoRow(Icons.grade, 'Grade', _gradeController.text),
          _buildInfoRow(Icons.help, 'Needs Educational Support', needsSupport,
              valueColor:
                  _needsEducationalSupport == true ? Colors.orange : null),
          if (_educationCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _educationCommentsController.text),
        ],
      );
    }
  }

  Widget _buildHealthSection() {
    return _buildSection(
      key: 'health',
      title: 'Health',
      icon: Icons.local_hospital,
      content: _buildHealthContent(),
      tooltip: 'الصحة',
    );
  }

  Widget _buildHealthContent() {
    final isEditing = isCreateMode || (_sectionEditing['health'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          DropdownButtonFormField<HealthStatus>(
            value: _healthStatus,
            decoration: const InputDecoration(labelText: 'Health Status'),
            items: HealthStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status
                    .toString()
                    .split('.')
                    .last
                    .replaceAll('_', ' ')
                    .toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => setState(() => _healthStatus = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _medicalConditionsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Medical Conditions'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _medicationsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Current Medications'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _needsMedicalSupport,
            decoration:
                const InputDecoration(labelText: 'Needs Medical Support'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) => setState(() => _needsMedicalSupport = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _healthCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String healthStatusText = _healthStatus
              ?.toString()
              .split('.')
              .last
              .replaceAll('_', ' ')
              .toUpperCase() ??
          '';

      String needsMedicalSupportText = _needsMedicalSupport == null
          ? ''
          : (_needsMedicalSupport! ? 'Yes' : 'No');

      Color? healthStatusColor;
      if (_healthStatus == HealthStatus.good) {
        healthStatusColor = Colors.green;
      } else if (_healthStatus == HealthStatus.fair ||
          _healthStatus == HealthStatus.poor) {
        healthStatusColor = Colors.orange;
      }

      return Column(
        children: [
          _buildInfoRow(Icons.favorite, 'Health Status', healthStatusText,
              valueColor: healthStatusColor),
          _buildInfoRow(Icons.medical_information, 'Medical Conditions',
              _medicalConditionsController.text),
          _buildInfoRow(Icons.medication, 'Current Medications',
              _medicationsController.text),
          _buildInfoRow(
              Icons.help, 'Needs Medical Support', needsMedicalSupportText,
              valueColor: _needsMedicalSupport == true ? Colors.orange : null),
          if (_healthCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _healthCommentsController.text),
        ],
      );
    }
  }

  Widget _buildAccommodationSection() {
    return _buildSection(
      key: 'accommodation',
      title: 'Accommodation',
      icon: Icons.home,
      content: _buildAccommodationContent(),
      tooltip: 'السكن',
    );
  }

  Widget _buildAccommodationContent() {
    final isEditing =
        isCreateMode || (_sectionEditing['accommodation'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          DropdownButtonFormField<AccommodationType>(
            value: _accommodationType,
            decoration: const InputDecoration(labelText: 'Accommodation Type'),
            items: AccommodationType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type
                    .toString()
                    .split('.')
                    .last
                    .replaceAll('_', ' ')
                    .toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => setState(() => _accommodationType = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accommodationAddressController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _needsHousingSupport,
            decoration:
                const InputDecoration(labelText: 'Needs Housing Support'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) => setState(() => _needsHousingSupport = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accommodationCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String accommodationTypeText = _accommodationType
              ?.toString()
              .split('.')
              .last
              .replaceAll('_', ' ')
              .toUpperCase() ??
          '';

      String needsHousingSupportText = _needsHousingSupport == null
          ? ''
          : (_needsHousingSupport! ? 'Yes' : 'No');

      return Column(
        children: [
          _buildInfoRow(
              Icons.home, 'Accommodation Type', accommodationTypeText),
          _buildInfoRow(Icons.location_on, 'Address',
              _accommodationAddressController.text),
          _buildInfoRow(
              Icons.help, 'Needs Housing Support', needsHousingSupportText,
              valueColor: _needsHousingSupport == true ? Colors.orange : null),
          if (_accommodationCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _accommodationCommentsController.text),
        ],
      );
    }
  }

  Widget _buildIslamicEducationSection() {
    return _buildSection(
      key: 'islamic',
      title: 'Islamic Education',
      icon: Icons.menu_book,
      content: _buildIslamicEducationContent(),
      tooltip: 'التعليم الإسلامي',
    );
  }

  Widget _buildIslamicEducationContent() {
    final isEditing = isCreateMode || (_sectionEditing['islamic'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _quranMemorizationController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Quran Memorization'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _attendsIslamicSchool,
            decoration:
                const InputDecoration(labelText: 'Attends Islamic School'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) => setState(() => _attendsIslamicSchool = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _islamicEducationLevelController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration:
                const InputDecoration(labelText: 'Islamic Education Level'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _islamicEducationCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      String attendsIslamicSchoolText = _attendsIslamicSchool == null
          ? ''
          : (_attendsIslamicSchool! ? 'Yes' : 'No');

      return Column(
        children: [
          _buildInfoRow(Icons.menu_book, 'Quran Memorization',
              _quranMemorizationController.text),
          _buildInfoRow(
              Icons.school, 'Attends Islamic School', attendsIslamicSchoolText,
              valueColor: _attendsIslamicSchool == true ? Colors.green : null),
          _buildInfoRow(Icons.grade, 'Islamic Education Level',
              _islamicEducationLevelController.text),
          if (_islamicEducationCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _islamicEducationCommentsController.text),
        ],
      );
    }
  }

  Widget _buildHobbiesSection() {
    return _buildSection(
      key: 'hobbies',
      title: 'Hobbies',
      icon: Icons.sports_esports,
      content: _buildHobbiesContent(),
      tooltip: 'الهوايات',
    );
  }

  Widget _buildHobbiesContent() {
    final isEditing = isCreateMode || (_sectionEditing['hobbies'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _hobbiesController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Hobbies & Interests'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _skillsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Skills & Talents'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _aspirationsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration:
                const InputDecoration(labelText: 'Aspirations & Dreams'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _hobbiesCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.sports_esports, 'Hobbies & Interests',
              _hobbiesController.text),
          _buildInfoRow(Icons.star, 'Skills & Talents', _skillsController.text),
          _buildInfoRow(Icons.rocket_launch, 'Aspirations & Dreams',
              _aspirationsController.text),
          if (_hobbiesCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _hobbiesCommentsController.text),
        ],
      );
    }
  }

  Widget _buildSiblingsSection() {
    return _buildSection(
      key: 'siblings',
      title: 'Siblings',
      icon: Icons.people,
      content: _buildSiblingsContent(),
      tooltip: 'الأشقاء',
    );
  }

  Widget _buildSiblingsContent() {
    final isEditing = isCreateMode || (_sectionEditing['siblings'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _numberOfSiblingsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Number of Siblings'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _siblingsDetailsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(
                labelText: 'Siblings Details (names, ages, status)'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _siblingsCommentsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.people, 'Number of Siblings',
              _numberOfSiblingsController.text),
          _buildInfoRow(Icons.family_restroom, 'Siblings Details',
              _siblingsDetailsController.text),
          if (_siblingsCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _siblingsCommentsController.text),
        ],
      );
    }
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSection(
      key: 'additional',
      title: 'Additional Info',
      icon: Icons.info,
      content: _buildAdditionalInfoContent(),
      tooltip: 'معلومات إضافية',
    );
  }

  Widget _buildAdditionalInfoContent() {
    final isEditing = isCreateMode || (_sectionEditing['additional'] ?? false);
    final theme = Theme.of(context);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _additionalNotesController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Additional Notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _urgentNeedsController,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(labelText: 'Urgent Needs'),
            maxLines: 2,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(
              Icons.note, 'Additional Notes', _additionalNotesController.text),
          _buildInfoRow(
              Icons.priority_high, 'Urgent Needs', _urgentNeedsController.text,
              valueColor:
                  _urgentNeedsController.text.isNotEmpty ? Colors.red : null),
        ],
      );
    }
  }

  Widget _buildSupervisorSection() {
    return _buildSection(
      key: 'supervisor',
      title: 'Supervisor Assignment',
      icon: Icons.supervisor_account,
      content: _buildSupervisorContent(),
      tooltip: 'تعيين المشرف',
    );
  }

  Widget _buildSupervisorContent() {
    final isEditing = isCreateMode || (_sectionEditing['supervisor'] ?? false);
    final supervisorRepository = context.read<SupervisorRepository>();

    return FutureBuilder<List<Supervisor>>(
      future: supervisorRepository.getAllSupervisors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No supervisors available.');
        }
        final supervisors = snapshot.data!;

        // Handle display value for null case (no supervisor assigned)
        String? displayValue = _selectedSupervisorId;

        return Column(
          children: [
            Tooltip(
              message: ' المشرف المعين',
              child: DropdownButtonFormField<String>(
                value: displayValue,
                decoration: InputDecoration(
                  labelText: 'Supervisor *',
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                  helperText: _selectedSupervisorId == null
                      ? 'No supervisor assigned'
                      : null,
                  helperStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.orange[300]
                        : Colors.orange[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(
                              0xFF30363D) // Better border color for dark mode
                          : Colors.grey[400]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(
                              0xFF30363D) // Better border color for dark mode
                          : Colors.grey[400]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF58A6FF) // Better blue for dark mode
                          : Colors.blue[600]!,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(
                          0xFF21262D) // Better fill color for dark mode
                      : Colors.grey[50],
                ),
                items: supervisors.map((supervisor) {
                  final isActive = supervisor.active ?? true;
                  return DropdownMenuItem(
                    value: supervisor.supervisorId,
                    enabled: isActive ||
                        supervisor.supervisorId == _selectedSupervisorId,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            '${supervisor.firstName} ${supervisor.familyName}',
                            style: TextStyle(
                              color: isActive ? null : Colors.grey.shade600,
                              fontWeight: isActive
                                  ? FontWeight.normal
                                  : FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isActive) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.warning_amber,
                            size: 16,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: isEditing
                    ? (value) {
                        if (value == null) {
                          // User cleared selection, set to null
                          setState(() => _selectedSupervisorId = null);
                        } else {
                          // Find the selected supervisor to check if it's active
                          final selectedSupervisor = supervisors.firstWhere(
                            (s) => s.supervisorId == value,
                          );
                          final isActive = selectedSupervisor.active ?? true;

                          // Only allow selection if supervisor is active OR it's the current assignment
                          if (isActive || value == _selectedSupervisorId) {
                            setState(() => _selectedSupervisorId = value);
                          } else {
                            // Show warning for inactive supervisor
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Cannot assign orphan to inactive supervisor: ${selectedSupervisor.firstName} ${selectedSupervisor.familyName}',
                                ),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      }
                    : null,
                validator: (value) =>
                    value == null ? 'Please select a supervisor' : null,
              ),
            ),
            if (_selectedSupervisorId != null) ...[
              const SizedBox(height: 16),
              FutureBuilder<Supervisor?>(
                future: supervisorRepository
                    .getSupervisorById(_selectedSupervisorId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final supervisor = snapshot.data!;
                    final isActive = supervisor.active ?? true;
                    final theme = Theme.of(context);
                    final isDark = theme.brightness == Brightness.dark;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isDark
                                ? const Color(0xFF0D1117)
                                : Colors.blue.shade50)
                            : (isDark
                                ? const Color(0xFF1C1F23)
                                : Colors.orange.shade50),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? (isDark
                                  ? const Color(0xFF58A6FF)
                                  : Colors.blue.shade200)
                              : (isDark
                                  ? const Color(0xFFF78166)
                                  : Colors.orange.shade300),
                          width: isActive ? 1 : 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Warning banner for inactive supervisor
                          if (!isActive) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2D1B1B)
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFFF78166)
                                      : Colors.orange.shade400,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning_amber,
                                      color: isDark
                                          ? const Color(0xFFF78166)
                                          : Colors.orange.shade700,
                                      size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'EMERGENCY: This orphan is assigned to an inactive supervisor',
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFF78166)
                                            : Colors.orange.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.supervisor_account,
                                color: isActive
                                    ? (isDark
                                        ? const Color(0xFF58A6FF)
                                        : Colors.blue.shade600)
                                    : (isDark
                                        ? const Color(0xFFF78166)
                                        : Colors.orange.shade600),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${supervisor.firstName} ${supervisor.familyName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            theme.textTheme.titleMedium?.color,
                                      ),
                                    ),
                                    if (supervisor.phoneNumber?.isNotEmpty ==
                                        true)
                                      Text(
                                        'Phone: ${supervisor.phoneNumber}',
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                    if (supervisor.email?.isNotEmpty == true)
                                      Text(
                                        'Email: ${supervisor.email}',
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAttachmentsSection() {
    return _buildSection(
      key: 'attachments',
      title: 'Required Documents',
      icon: Icons.attach_file,
      content: _buildAttachmentsContent(),
      hasEdit: false, // No edit button for attachments
      tooltip: 'الوثائق المطلوبة',
    );
  }

  Widget _buildAttachmentsContent() {
    return Column(
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
        _buildDocumentAttachment(
          title: 'Birth Certificate of Orphan',
          subtitle: 'Official birth certificate document',
          icon: Icons.child_care,
          photo: _birthCertificatePhoto,
          onSelect: () => _selectDocumentPhoto('birth_certificate'),
          onRemove: () => _removeDocumentPhoto('birth_certificate'),
        ),
        _buildDocumentAttachment(
          title: 'Death Certificate of Father',
          subtitle: 'Official death certificate document',
          icon: Icons.person_off,
          photo: _deathCertificatePhoto,
          onSelect: () => _selectDocumentPhoto('death_certificate'),
          onRemove: () => _removeDocumentPhoto('death_certificate'),
        ),
        _buildDocumentAttachment(
          title: 'ID Card or Other for Orphan',
          subtitle: 'Identity document, passport, or similar',
          icon: Icons.badge,
          photo: _orphanIdPhoto,
          onSelect: () => _selectDocumentPhoto('orphan_id'),
          onRemove: () => _removeDocumentPhoto('orphan_id'),
        ),
        _buildDocumentAttachment(
          title: 'ID Card or Other for Father',
          subtitle: 'Father\'s identity document',
          icon: Icons.badge_outlined,
          photo: _fatherIdPhoto,
          onSelect: () => _selectDocumentPhoto('father_id'),
          onRemove: () => _removeDocumentPhoto('father_id'),
        ),
        _buildDocumentAttachment(
          title: 'ID Card or Other for Mother',
          subtitle: 'Mother\'s identity document',
          icon: Icons.badge_outlined,
          photo: _motherIdPhoto,
          onSelect: () => _selectDocumentPhoto('mother_id'),
          onRemove: () => _removeDocumentPhoto('mother_id'),
        ),
        _buildDocumentAttachment(
          title: 'ID Card or Other for Family',
          subtitle: 'Family member or guardian identity document',
          icon: Icons.family_restroom,
          photo: _familyIdPhoto,
          onSelect: () => _selectDocumentPhoto('family_id'),
          onRemove: () => _removeDocumentPhoto('family_id'),
        ),
        _buildDocumentAttachment(
          title: 'Passport Photo of Orphan',
          subtitle: 'Official passport-style photo',
          icon: Icons.portrait,
          photo: _passportPhoto,
          onSelect: () => _selectDocumentPhoto('passport_photo'),
          onRemove: () => _removeDocumentPhoto('passport_photo'),
        ),
        _buildDocumentAttachment(
          title: 'Recent Photo of Orphan',
          subtitle: 'Current photo for identification',
          icon: Icons.photo_camera,
          photo: _recentPhoto,
          onSelect: () => _selectDocumentPhoto('recent_photo'),
          onRemove: () => _removeDocumentPhoto('recent_photo'),
        ),

        // Additional Documents Section
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildAdditionalDocumentsSection(),
      ],
    );
  }

  Widget _buildAdditionalDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.folder_open, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              'Additional Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Add any other relevant documents (optional)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // Display additional documents
        if (_additionalDocuments.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _additionalDocuments.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
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
                          errorBuilder: (context, error, stackTrace) {
                            print(
                                'Error loading additional document image: $error');
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeAdditionalDocument(index),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
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
          const SizedBox(height: 16),
        ],

        // Add document button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _selectAdditionalDocument,
            icon: const Icon(Icons.add_photo_alternate),
            label: Text(_additionalDocuments.isEmpty
                ? 'Add Additional Documents'
                : 'Add More Documents'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.blue.shade300),
              foregroundColor: Colors.blue.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectAdditionalDocument() async {
    try {
      final File? photoFile = await ImageService.selectPhoto();
      if (photoFile != null) {
        setState(() {
          _additionalDocuments.add(photoFile);
        });

        // If we're in view mode (editing an existing orphan), save the document immediately
        if (isViewMode && _orphan != null) {
          await _saveDocumentAttachments(_orphan!.orphanId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Additional document attached and saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // In create mode, just show attachment confirmation
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Additional document attached successfully!')),
            );
          }
        }
      }
    } catch (e) {
      print('Error selecting additional document: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select photo: $e')),
        );
      }
    }
  }

  void _removeAdditionalDocument(int index) {
    setState(() {
      _additionalDocuments.removeAt(index);
    });

    // If we're in view mode (editing an existing orphan), save the changes immediately
    if (isViewMode && _orphan != null) {
      _saveDocumentAttachments(_orphan!.orphanId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Additional document removed and saved!'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Additional document removed')),
      );
    }
  }

  Widget _buildDocumentAttachment({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? photo,
    required VoidCallback onSelect,
    required VoidCallback onRemove,
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
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
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading document image: $error');
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.error,
                              color: Colors.grey,
                              size: 20,
                            ),
                          );
                        },
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

  Future<Orphan?> _findRecentlyCreatedOrphan() async {
    try {
      final orphanRepository = context.read<OrphanRepository>();
      final orphansStream = orphanRepository.getAllOrphans();
      final orphans = await orphansStream.first;

      // Find the most recent orphan (by lastUpdated)
      if (orphans.isNotEmpty) {
        orphans.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        return orphans.first;
      }
      return null;
    } catch (e) {
      print('Error finding recently created orphan: $e');
      return null;
    }
  }

  Future<void> _loadDocumentAttachments(Orphan orphan) async {
    if (orphan.documentsPath == null || orphan.documentsPath!.isEmpty) {
      return;
    }

    try {
      final documentEntries = orphan.documentsPath!.split(',');

      for (final entry in documentEntries) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final docType = parts[0];
          final docPath = parts[1];

          final file = File(docPath);
          if (await file.exists()) {
            // Validate that the file is an image by checking its extension
            final extension = path.extension(file.path).toLowerCase();
            final validImageExtensions = [
              '.jpg',
              '.jpeg',
              '.png',
              '.gif',
              '.bmp',
              '.webp'
            ];

            if (!validImageExtensions.contains(extension)) {
              print('Warning: Skipping non-image file: ${file.path}');
              continue;
            }

            setState(() {
              switch (docType) {
                case 'birth_cert':
                  _birthCertificatePhoto = file;
                  break;
                case 'death_cert':
                  _deathCertificatePhoto = file;
                  break;
                case 'orphan_id':
                  _orphanIdPhoto = file;
                  break;
                case 'father_id':
                  _fatherIdPhoto = file;
                  break;
                case 'mother_id':
                  _motherIdPhoto = file;
                  break;
                case 'family_id':
                  _familyIdPhoto = file;
                  break;
                case 'passport':
                  _passportPhoto = file;
                  break;
                case 'recent':
                  _recentPhoto = file;
                  break;
                default:
                  // Handle additional documents (additional_0, additional_1, etc.)
                  if (docType.startsWith('additional_')) {
                    _additionalDocuments.add(file);
                  }
                  break;
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error loading document attachments: $e');
    }
  }

  Future<void> _updateOrphanDocumentPaths(
      String orphanId, String documentPaths) async {
    try {
      final orphanRepository = context.read<OrphanRepository>();
      final companion = OrphansCompanion(
        orphanId: drift.Value(orphanId),
        documentsPath: drift.Value(documentPaths),
        lastUpdated: drift.Value(DateTime.now()),
      );
      await orphanRepository.updateOrphanWithCompanion(companion);
      print('Updated document paths for orphan: $orphanId');
    } catch (e) {
      print('Error updating orphan document paths: $e');
    }
  }

  Future<String> _saveDocumentAttachmentsAndGetPaths(String documentId) async {
    try {
      List<String> allDocumentPaths = [];

      // Save specific documents
      if (_birthCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _birthCertificatePhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('birth_cert:$savedPath');
      }

      if (_deathCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _deathCertificatePhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('death_cert:$savedPath');
      }

      if (_orphanIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_orphanIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('orphan_id:$savedPath');
      }

      if (_fatherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_fatherIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('father_id:$savedPath');
      }

      if (_motherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_motherIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('mother_id:$savedPath');
      }

      if (_familyIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_familyIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('family_id:$savedPath');
      }

      if (_passportPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_passportPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('passport:$savedPath');
      }

      if (_recentPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_recentPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('recent:$savedPath');
      }

      // Save additional documents
      for (int i = 0; i < _additionalDocuments.length; i++) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _additionalDocuments[i], documentId);
        if (savedPath != null) allDocumentPaths.add('additional_$i:$savedPath');
      }

      print('Saved ${allDocumentPaths.length} document attachments');
      return allDocumentPaths.join(',');
    } catch (e) {
      print('Error saving document attachments: $e');
      return '';
    }
  }

  Future<void> _saveDocumentAttachments(String documentId) async {
    try {
      List<String> allDocumentPaths = [];

      // Save specific documents
      if (_birthCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _birthCertificatePhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('birth_cert:$savedPath');
      }

      if (_deathCertificatePhoto != null) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _deathCertificatePhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('death_cert:$savedPath');
      }

      if (_orphanIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_orphanIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('orphan_id:$savedPath');
      }

      if (_fatherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_fatherIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('father_id:$savedPath');
      }

      if (_motherIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_motherIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('mother_id:$savedPath');
      }

      if (_familyIdPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_familyIdPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('family_id:$savedPath');
      }

      if (_passportPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_passportPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('passport:$savedPath');
      }

      if (_recentPhoto != null) {
        final savedPath =
            await ImageService.saveDocumentPhoto(_recentPhoto!, documentId);
        if (savedPath != null) allDocumentPaths.add('recent:$savedPath');
      }

      // Save additional documents
      for (int i = 0; i < _additionalDocuments.length; i++) {
        final savedPath = await ImageService.saveDocumentPhoto(
            _additionalDocuments[i], documentId);
        if (savedPath != null) allDocumentPaths.add('additional_$i:$savedPath');
      }

      print('Saved ${allDocumentPaths.length} document attachments');

      // Store document paths in database if we have any attachments
      if (allDocumentPaths.isNotEmpty) {
        await _updateOrphanDocumentPaths(
            documentId, allDocumentPaths.join(','));
      }
    } catch (e) {
      print('Error saving document attachments: $e');
    }
  }

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

        // If we're in view mode (editing an existing orphan), save the document immediately
        if (isViewMode && _orphan != null) {
          await _saveDocumentAttachments(_orphan!.orphanId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Document attached and saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // In create mode, just show attachment confirmation
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document attached successfully!')),
            );
          }
        }
      }
    } catch (e) {
      print('Error selecting document photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select photo: $e')),
        );
      }
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document removed')),
      );
    }
  }
}
