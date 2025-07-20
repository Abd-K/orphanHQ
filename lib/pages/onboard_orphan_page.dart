import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/image_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class OnboardOrphanPage extends StatefulWidget {
  const OnboardOrphanPage({super.key});

  @override
  State<OnboardOrphanPage> createState() => _OnboardOrphanPageState();
}

class _OnboardOrphanPageState extends State<OnboardOrphanPage> {
  final _formKey = GlobalKey<FormState>();

  // Basic Details Controllers - 4-part Arabic naming
  final _firstNameController = TextEditingController();

  final _grandfatherNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  String? _selectedSupervisorId;
  OrphanStatus _selectedStatus = OrphanStatus.active;

  // Father Details Controllers
  final _fatherNameController = TextEditingController();
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
  final List<File> _additionalDocuments = [];

  @override
  Widget build(BuildContext context) {
    final supervisorRepository = context.read<SupervisorRepository>();
    final orphanRepository = context.read<OrphanRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboard New Orphan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildOrphanDetailsSection(),
            _buildFatherDetailsSection(),
            _buildMotherDetailsSection(),
            _buildCarerDetailsSection(),
            _buildEducationSection(),
            _buildHealthSection(),
            _buildAccommodationSection(),
            _buildIslamicEducationSection(),
            _buildHobbiesSection(),
            _buildSiblingsSection(),
            _buildAdditionalInfoSection(),
            _buildAttachmentsSection(),
            _buildSupervisorSection(supervisorRepository),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _submitForm(orphanRepository),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32), // Professional green
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: initiallyExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanDetailsSection() {
    return _buildCollapsibleSection(
      title: 'Orphan Details',
      initiallyExpanded: true,
      children: [
        // 4-part Arabic name structure
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'First Name *'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherNameController,
          decoration: const InputDecoration(labelText: "Father's Name *"),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _grandfatherNameController,
          decoration: const InputDecoration(labelText: "Grandfather's Name *"),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _familyNameController,
          decoration: const InputDecoration(labelText: 'Family Name *'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        const Text('Date of Birth *',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildDateField('Day (DD)', _dayController)),
              const SizedBox(width: 8),
              Expanded(child: _buildDateField('Month (MM)', _monthController)),
              const SizedBox(width: 8),
              Expanded(child: _buildYearField('Year (YYYY)', _yearController)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<OrphanStatus>(
          value: _selectedStatus,
          decoration: const InputDecoration(labelText: 'Status'),
          items: OrphanStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.toString().split('.').last.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedStatus = value!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _orphanDetailsCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildFatherDetailsSection() {
    return _buildCollapsibleSection(
      title: 'Father Details',
      children: [
        TextFormField(
          controller: _fatherNameController,
          decoration: const InputDecoration(labelText: 'Father\'s Name'),
        ),
        const SizedBox(height: 16),
        const Text('Date of Death',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                  child: _buildDateField('Day', _fatherDeathDayController,
                      required: false)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildDateField('Month', _fatherDeathMonthController,
                      required: false)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildYearField('Year', _fatherDeathYearController,
                      required: false)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherCauseOfDeathController,
          decoration: const InputDecoration(labelText: 'Cause of Death'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherOccupationController,
          decoration: const InputDecoration(labelText: 'Occupation'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fatherDetailsCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildMotherDetailsSection() {
    return _buildCollapsibleSection(
      title: 'Mother Details',
      children: [
        TextFormField(
          controller: _motherNameController,
          decoration: const InputDecoration(labelText: 'Mother\'s Name'),
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
        if (_motherAlive == false) ...[
          const SizedBox(height: 16),
          const Text('Date of Death',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    child: _buildDateField('Day', _motherDeathDayController,
                        required: false)),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildDateField('Month', _motherDeathMonthController,
                        required: false)),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildYearField('Year', _motherDeathYearController,
                        required: false)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _motherCauseOfDeathController,
            decoration: const InputDecoration(labelText: 'Cause of Death'),
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: _motherOccupationController,
          decoration: const InputDecoration(labelText: 'Occupation'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _motherDetailsCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildCarerDetailsSection() {
    return _buildCollapsibleSection(
      title: 'Carer Details',
      children: [
        TextFormField(
          controller: _carerNameController,
          decoration: const InputDecoration(labelText: 'Carer Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _carerRelationshipController,
          decoration:
              const InputDecoration(labelText: 'Relationship to Orphan'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _carerContactController,
          decoration: const InputDecoration(labelText: 'Contact Information'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _carerAddressController,
          decoration: const InputDecoration(labelText: 'Address'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _carerDetailsCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return _buildCollapsibleSection(
      title: 'Education Level',
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
          decoration: const InputDecoration(labelText: 'School Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _gradeController,
          decoration: const InputDecoration(labelText: 'Grade/Class'),
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
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildHealthSection() {
    return _buildCollapsibleSection(
      title: 'Health',
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
          decoration: const InputDecoration(labelText: 'Medical Conditions'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _medicationsController,
          decoration: const InputDecoration(labelText: 'Current Medications'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<bool>(
          value: _needsMedicalSupport,
          decoration: const InputDecoration(labelText: 'Needs Medical Support'),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) => setState(() => _needsMedicalSupport = value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _healthCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAccommodationSection() {
    return _buildCollapsibleSection(
      title: 'Accommodation',
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
          decoration: const InputDecoration(labelText: 'Address'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<bool>(
          value: _needsHousingSupport,
          decoration: const InputDecoration(labelText: 'Needs Housing Support'),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) => setState(() => _needsHousingSupport = value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accommodationCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildIslamicEducationSection() {
    return _buildCollapsibleSection(
      title: 'Islamic Education',
      children: [
        TextFormField(
          controller: _quranMemorizationController,
          decoration: const InputDecoration(
              labelText: 'Quran Memorization (e.g., 5 Juz)'),
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
          decoration:
              const InputDecoration(labelText: 'Islamic Education Level'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _islamicEducationCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildHobbiesSection() {
    return _buildCollapsibleSection(
      title: 'Hobbies',
      children: [
        TextFormField(
          controller: _hobbiesController,
          decoration: const InputDecoration(labelText: 'Hobbies & Interests'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _skillsController,
          decoration: const InputDecoration(labelText: 'Skills & Talents'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _aspirationsController,
          decoration: const InputDecoration(labelText: 'Aspirations & Dreams'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _hobbiesCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSiblingsSection() {
    return _buildCollapsibleSection(
      title: 'Siblings',
      children: [
        TextFormField(
          controller: _numberOfSiblingsController,
          decoration: const InputDecoration(labelText: 'Number of Siblings'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _siblingsDetailsController,
          decoration: const InputDecoration(
              labelText: 'Siblings Details (names, ages, status)'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _siblingsCommentsController,
          decoration: const InputDecoration(labelText: 'Additional Comments'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return _buildCollapsibleSection(
      title: 'Additional Info',
      children: [
        TextFormField(
          controller: _additionalNotesController,
          decoration: const InputDecoration(labelText: 'Additional Notes'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _urgentNeedsController,
          decoration: const InputDecoration(labelText: 'Urgent Needs'),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return _buildCollapsibleSection(
      title: 'Required Documents',
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
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(_additionalDocuments.isEmpty
                        ? 'Add Additional Document'
                        : 'Add Another Document'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade600),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                if (_additionalDocuments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_additionalDocuments.length} additional document${_additionalDocuments.length > 1 ? 's' : ''} attached',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildSupervisorSection(SupervisorRepository supervisorRepository) {
    return _buildCollapsibleSection(
      title: 'Supervisor Assignment',
      initiallyExpanded: true,
      children: [
        FutureBuilder<List<Supervisor>>(
          future: supervisorRepository.getAllSupervisors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No supervisors available.');
            }
            final supervisors = snapshot.data!;
            return DropdownButtonFormField<String>(
              value: _selectedSupervisorId,
              decoration: const InputDecoration(labelText: 'Supervisor *'),
              items: supervisors.map((supervisor) {
                return DropdownMenuItem(
                  value: supervisor.supervisorId,
                  child:
                      Text('${supervisor.firstName} ${supervisor.familyName}'),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedSupervisorId = value),
              validator: (value) =>
                  value == null ? 'Please select a supervisor' : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      {bool required = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 2,
      validator: required
          ? (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (value!.length != 2) return '2 digits';
              final num = int.tryParse(value);
              if (label.contains('Day') && (num == null || num < 1 || num > 31))
                return '01-31';
              if (label.contains('Month') &&
                  (num == null || num < 1 || num > 12)) return '01-12';
              return null;
            }
          : null,
    );
  }

  Widget _buildYearField(String label, TextEditingController controller,
      {bool required = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 4,
      validator: required
          ? (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (value!.length != 4) return '4 digits';
              final year = int.tryParse(value);
              if (year == null || year < 1900 || year > DateTime.now().year) {
                return '1900-${DateTime.now().year}';
              }
              return null;
            }
          : null,
    );
  }

  Future<void> _selectDocumentPhoto(String documentType) async {
    print('DEBUG: _selectDocumentPhoto called for type: $documentType');
    try {
      print('DEBUG: Calling ImageService.selectPhoto()');
      final File? photoFile = await ImageService.selectPhoto();
      print('DEBUG: ImageService.selectPhoto() returned: ${photoFile?.path}');
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
          SnackBar(content: Text('Document attached successfully!')),
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

  Future<void> _submitForm(OrphanRepository orphanRepository) async {
    if (!_formKey.currentState!.validate()) return;

    // Declare allDocumentPaths outside try block for cleanup access
    List<String> allDocumentPaths = [];

    try {
      final day = int.parse(_dayController.text);
      final month = int.parse(_monthController.text);
      final year = int.parse(_yearController.text);
      final dob = DateTime(year, month, day);

      // Generate orphan ID for document saving
      final orphanId = DateTime.now().millisecondsSinceEpoch.toString();

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

      // Store document paths as comma-separated string (simple approach)
      final documentsPathString =
          allDocumentPaths.isNotEmpty ? allDocumentPaths.join(',') : null;

      DateTime? fatherDeathDate;
      if (_fatherDeathDayController.text.isNotEmpty &&
          _fatherDeathMonthController.text.isNotEmpty &&
          _fatherDeathYearController.text.isNotEmpty) {
        fatherDeathDate = DateTime(
          int.parse(_fatherDeathYearController.text),
          int.parse(_fatherDeathMonthController.text),
          int.parse(_fatherDeathDayController.text),
        );
      }

      DateTime? motherDeathDate;
      if (_motherDeathDayController.text.isNotEmpty &&
          _motherDeathMonthController.text.isNotEmpty &&
          _motherDeathYearController.text.isNotEmpty) {
        motherDeathDate = DateTime(
          int.parse(_motherDeathYearController.text),
          int.parse(_motherDeathMonthController.text),
          int.parse(_motherDeathDayController.text),
        );
      }

      final newOrphan = OrphansCompanion.insert(
        firstName: _firstNameController.text,
        fatherName: _fatherNameController.text,
        grandfatherName: _grandfatherNameController.text,
        familyName: _familyNameController.text.isEmpty
            ? 'Unknown'
            : _familyNameController.text, // Required field
        gender: Gender.male, // Required field, use default gender
        dateOfBirth: dob,
        status: _selectedStatus,
        lastUpdated: DateTime.now(),
        supervisorId: _selectedSupervisorId!,
        // Father details
        fatherFirstName: drift.Value(_fatherNameController.text.isEmpty
            ? null
            : _fatherNameController.text),
        fatherDateOfDeath: drift.Value(fatherDeathDate),
        fatherCauseOfDeath: drift.Value(
            _fatherCauseOfDeathController.text.isEmpty
                ? null
                : _fatherCauseOfDeathController.text),
        fatherWork: drift.Value(_fatherOccupationController.text.isEmpty
            ? null
            : _fatherOccupationController.text),
        // Mother details
        motherFirstName: drift.Value(_motherNameController.text.isEmpty
            ? null
            : _motherNameController.text),
        motherAlive: drift.Value(_motherAlive),
        motherDateOfDeath: drift.Value(motherDeathDate),
        motherCauseOfDeath: drift.Value(
            _motherCauseOfDeathController.text.isEmpty
                ? null
                : _motherCauseOfDeathController.text),
        motherWork: drift.Value(_motherOccupationController.text.isEmpty
            ? null
            : _motherOccupationController.text),
        // Guardian details (renamed from carer)
        guardianName: drift.Value(_carerNameController.text.isEmpty
            ? null
            : _carerNameController.text),
        guardianRelationship: drift.Value(
            _carerRelationshipController.text.isEmpty
                ? null
                : _carerRelationshipController.text),
        // Education
        educationLevel: drift.Value(_educationLevel),
        schoolName: drift.Value(_schoolNameController.text.isEmpty
            ? null
            : _schoolNameController.text),
        grade: drift.Value(
            _gradeController.text.isEmpty ? null : _gradeController.text),
        // Health
        healthStatus: drift.Value(_healthStatus),
        medicalConditions: drift.Value(_medicalConditionsController.text.isEmpty
            ? null
            : _medicalConditionsController.text),
        medications: drift.Value(_medicationsController.text.isEmpty
            ? null
            : _medicationsController.text),
        needsMedicalSupport: drift.Value(_needsMedicalSupport),
        // Accommodation
        accommodationType: drift.Value(_accommodationType),
        accommodationAddress: drift.Value(
            _accommodationAddressController.text.isEmpty
                ? null
                : _accommodationAddressController.text),
        needsHousingSupport: drift.Value(_needsHousingSupport),
        // Islamic education
        quranMemorization: drift.Value(_quranMemorizationController.text.isEmpty
            ? null
            : _quranMemorizationController.text),
        attendsIslamicSchool: drift.Value(_attendsIslamicSchool),
        islamicEducationLevel: drift.Value(
            _islamicEducationLevelController.text.isEmpty
                ? null
                : _islamicEducationLevelController.text),
        // Hobbies
        hobbies: drift.Value(
            _hobbiesController.text.isEmpty ? null : _hobbiesController.text),
        skills: drift.Value(
            _skillsController.text.isEmpty ? null : _skillsController.text),
        aspirations: drift.Value(_aspirationsController.text.isEmpty
            ? null
            : _aspirationsController.text),
        // Siblings
        numberOfSiblings: drift.Value(_numberOfSiblingsController.text.isEmpty
            ? null
            : int.tryParse(_numberOfSiblingsController.text)),
        siblingsDetails: drift.Value(_siblingsDetailsController.text.isEmpty
            ? null
            : _siblingsDetailsController.text),
        // Additional info
        additionalNotes: drift.Value(_additionalNotesController.text.isEmpty
            ? null
            : _additionalNotesController.text),
        urgentNeeds: drift.Value(_urgentNeedsController.text.isEmpty
            ? null
            : _urgentNeedsController.text),
        // Documents path
        documentsPath: drift.Value(documentsPathString),
      );

      await orphanRepository.createOrphan(newOrphan);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(allDocumentPaths.isNotEmpty
              ? 'Orphan created with ${allDocumentPaths.length} document(s)!'
              : 'Orphan created successfully!'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error creating orphan: $e'); // Console logging
      // Clean up document photos if orphan creation failed
      for (final docPath in allDocumentPaths) {
        final path =
            docPath.split(':').length > 1 ? docPath.split(':')[1] : docPath;
        await ImageService.deleteDocumentPhoto(path);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create orphan: $e')),
      );
    }
  }
}
