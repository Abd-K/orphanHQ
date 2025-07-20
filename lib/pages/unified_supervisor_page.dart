import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../database.dart';
import '../repositories/supervisor_repository.dart';
import '../repositories/orphan_repository.dart';

class UnifiedSupervisorPage extends StatefulWidget {
  final String? supervisorId; // null for create mode, id for view mode

  const UnifiedSupervisorPage({super.key, this.supervisorId});

  @override
  State<UnifiedSupervisorPage> createState() => _UnifiedSupervisorPageState();
}

class _UnifiedSupervisorPageState extends State<UnifiedSupervisorPage> {
  bool get isCreateMode => widget.supervisorId == null;
  bool get isViewMode => !isCreateMode;

  final _formKey = GlobalKey<FormState>();

  // Personal Details Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  bool _isActive = true; // Status field

  // Contact Details Controllers
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternateContactController = TextEditingController();

  // Address Details Controllers
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();

  // Professional Details Controllers
  final _positionController = TextEditingController();
  final _organizationController = TextEditingController();

  // Additional Info Controllers
  final _notesController = TextEditingController();

  // Comments controllers for each section
  final _personalInfoCommentsController = TextEditingController();
  final _contactInfoCommentsController = TextEditingController();
  final _addressInfoCommentsController = TextEditingController();
  final _professionalInfoCommentsController = TextEditingController();

  // Section expansion states for create mode
  final Map<String, bool> _sectionExpanded = {
    'personal': true, // First section starts expanded
    'contact': false,
    'address': false,
    'professional': false,
    'additional': false,
  };

  // Edit states for view mode
  final Map<String, bool> _sectionEditing = {
    'personal': false,
    'contact': false,
    'address': false,
    'professional': false,
    'additional': false,
  };

  Supervisor? _supervisor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (isViewMode) {
      _loadSupervisor();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadSupervisor() async {
    final supervisorRepository = context.read<SupervisorRepository>();

    final allSupervisors = await supervisorRepository.getAllSupervisors();
    final supervisor = allSupervisors
        .where((s) => s.supervisorId == widget.supervisorId)
        .firstOrNull;

    if (supervisor != null) {
      setState(() {
        _supervisor = supervisor;
        _populateControllers(supervisor);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateControllers(Supervisor supervisor) {
    _firstNameController.text = supervisor.firstName;
    _lastNameController.text = supervisor.lastName;
    _familyNameController.text = supervisor.familyName;
    _isActive = supervisor.active;

    // Contact details
    _phoneNumberController.text = supervisor.phoneNumber;
    _emailController.text = supervisor.email ?? '';
    _alternateContactController.text = supervisor.alternateContact ?? '';

    // Address details
    _addressController.text = supervisor.address;
    _cityController.text = supervisor.city;
    _districtController.text = supervisor.district ?? '';

    // Professional details
    _positionController.text = supervisor.position;
    _organizationController.text = supervisor.organization ?? '';

    // Additional info
    _notesController.text = supervisor.notes ?? '';
  }

  @override
  void dispose() {
    // Dispose all controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _familyNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _alternateContactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _positionController.dispose();
    _organizationController.dispose();
    _notesController.dispose();
    _personalInfoCommentsController.dispose();
    _contactInfoCommentsController.dispose();
    _addressInfoCommentsController.dispose();
    _professionalInfoCommentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreateMode ? 'Add New Supervisor' : 'Supervisor Details'),
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade700,
        actions: isCreateMode
            ? [
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
              ]
            : [
                if (isViewMode)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context),
                    tooltip: 'Delete Supervisor',
                  ),
              ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (isViewMode && _supervisor != null) ...[
                    _buildProfileHeader(),
                    const SizedBox(height: 16),
                  ],
                  _buildPersonalDetailsSection(),
                  const SizedBox(height: 16),
                  _buildContactDetailsSection(),
                  const SizedBox(height: 16),
                  _buildAddressDetailsSection(),
                  const SizedBox(height: 16),
                  _buildProfessionalDetailsSection(),
                  const SizedBox(height: 16),
                  _buildAdditionalInfoSection(),
                  if (isViewMode) ...[
                    const SizedBox(height: 16),
                    _buildAssignedOrphansSection(),
                  ],
                  if (isCreateMode) ...[
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
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
                  color: Colors.blue.shade50,
                  borderRadius: isExpanded
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )
                      : BorderRadius.circular(12),
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
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.blue.shade700,
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
    if (_supervisor != null) {
      _populateControllers(_supervisor!);
    }
  }

  Future<void> _saveSection(String key) async {
    if (_supervisor != null) {
      await _updateSupervisor();
      await _loadSupervisor();

      setState(() {
        _sectionEditing[key] = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final supervisorRepository = context.read<SupervisorRepository>();

    final companion = SupervisorsCompanion.insert(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      familyName: _familyNameController.text,
      phoneNumber: _phoneNumberController.text,
      email: drift.Value(
          _emailController.text.isEmpty ? null : _emailController.text),
      alternateContact: drift.Value(_alternateContactController.text.isEmpty
          ? null
          : _alternateContactController.text),
      address: _addressController.text,
      city: _cityController.text,
      district: drift.Value(
          _districtController.text.isEmpty ? null : _districtController.text),
      position: _positionController.text,
      organization: drift.Value(_organizationController.text.isEmpty
          ? null
          : _organizationController.text),
      notes: drift.Value(
          _notesController.text.isEmpty ? null : _notesController.text),
      active: drift.Value(_isActive),
      publicKey:
          'temp_key_${DateTime.now().millisecondsSinceEpoch}', // Temporary implementation
    );

    await supervisorRepository.createSupervisor(companion);

    if (mounted) {
      context.go('/supervisors');
    }
  }

  Future<void> _updateSupervisor() async {
    if (_supervisor == null) return;

    final supervisorRepository = context.read<SupervisorRepository>();

    final updatedSupervisor = _supervisor!.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      familyName: _familyNameController.text,
      phoneNumber: _phoneNumberController.text,
      email: drift.Value(
          _emailController.text.isEmpty ? null : _emailController.text),
      alternateContact: drift.Value(_alternateContactController.text.isEmpty
          ? null
          : _alternateContactController.text),
      address: _addressController.text,
      city: _cityController.text,
      district: drift.Value(
          _districtController.text.isEmpty ? null : _districtController.text),
      position: _positionController.text,
      organization: drift.Value(_organizationController.text.isEmpty
          ? null
          : _organizationController.text),
      notes: drift.Value(
          _notesController.text.isEmpty ? null : _notesController.text),
      active: _isActive,
    );

    await supervisorRepository.updateSupervisor(updatedSupervisor);
  }

  Widget _buildPersonalDetailsSection() {
    return _buildSection(
      key: 'personal',
      title: 'Personal Information',
      icon: Icons.person,
      content: _buildPersonalDetailsContent(),
      tooltip: 'المعلومات الشخصية',
    );
  }

  Widget _buildPersonalDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['personal'] ?? false);

    if (isEditing) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name *'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name *'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _familyNameController,
            decoration: const InputDecoration(labelText: 'Family Name *'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _isActive,
            decoration: const InputDecoration(labelText: 'Active Status'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Active')),
              DropdownMenuItem(value: false, child: Text('Inactive')),
            ],
            onChanged: (value) {
              setState(() {
                _isActive = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _personalInfoCommentsController,
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.person, 'First Name', _firstNameController.text),
          _buildInfoRow(
              Icons.person_outline, 'Last Name', _lastNameController.text),
          _buildInfoRow(
              Icons.family_restroom, 'Family Name', _familyNameController.text),
          _buildInfoRow(
            Icons.check_circle,
            'Status',
            _isActive ? 'Active' : 'Inactive',
            valueColor: _isActive ? Colors.green : Colors.orange,
          ),
          if (_personalInfoCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _personalInfoCommentsController.text),
        ],
      );
    }
  }

  Widget _buildContactDetailsSection() {
    return _buildSection(
      key: 'contact',
      title: 'Contact Information',
      icon: Icons.phone,
      content: _buildContactDetailsContent(),
      tooltip: 'معلومات الاتصال',
    );
  }

  Widget _buildContactDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['contact'] ?? false);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number *'),
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email (Optional)'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _alternateContactController,
            decoration: const InputDecoration(
                labelText: 'Alternate Contact (Optional)'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contactInfoCommentsController,
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(
              Icons.phone, 'Phone Number', _phoneNumberController.text),
          _buildInfoRow(Icons.email, 'Email', _emailController.text),
          _buildInfoRow(Icons.contact_phone, 'Alternate Contact',
              _alternateContactController.text),
          if (_contactInfoCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _contactInfoCommentsController.text),
        ],
      );
    }
  }

  Widget _buildAddressDetailsSection() {
    return _buildSection(
      key: 'address',
      title: 'Address Information',
      icon: Icons.location_on,
      content: _buildAddressDetailsContent(),
      tooltip: 'معلومات العنوان',
    );
  }

  Widget _buildAddressDetailsContent() {
    final isEditing = isCreateMode || (_sectionEditing['address'] ?? false);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address *'),
            maxLines: 2,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City *'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _districtController,
                  decoration:
                      const InputDecoration(labelText: 'District (Optional)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressInfoCommentsController,
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.location_on, 'Address', _addressController.text),
          _buildInfoRow(Icons.location_city, 'City', _cityController.text),
          _buildInfoRow(Icons.map, 'District', _districtController.text),
          if (_addressInfoCommentsController.text.isNotEmpty)
            _buildInfoRow(
                Icons.comment, 'Comments', _addressInfoCommentsController.text),
        ],
      );
    }
  }

  Widget _buildProfessionalDetailsSection() {
    return _buildSection(
      key: 'professional',
      title: 'Professional Information',
      icon: Icons.work,
      content: _buildProfessionalDetailsContent(),
      tooltip: 'المعلومات المهنية',
    );
  }

  Widget _buildProfessionalDetailsContent() {
    final isEditing =
        isCreateMode || (_sectionEditing['professional'] ?? false);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _positionController,
            decoration: const InputDecoration(labelText: 'Position/Role *'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _organizationController,
            decoration:
                const InputDecoration(labelText: 'Organization (Optional)'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _professionalInfoCommentsController,
            decoration: const InputDecoration(labelText: 'Additional Comments'),
            maxLines: 3,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.work, 'Position/Role', _positionController.text),
          _buildInfoRow(
              Icons.business, 'Organization', _organizationController.text),
          if (_professionalInfoCommentsController.text.isNotEmpty)
            _buildInfoRow(Icons.comment, 'Comments',
                _professionalInfoCommentsController.text),
        ],
      );
    }
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSection(
      key: 'additional',
      title: 'Additional Information',
      icon: Icons.note,
      content: _buildAdditionalInfoContent(),
      tooltip: 'معلومات إضافية',
    );
  }

  Widget _buildAdditionalInfoContent() {
    final isEditing = isCreateMode || (_sectionEditing['additional'] ?? false);

    if (isEditing) {
      return Column(
        children: [
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (Optional)'),
            maxLines: 5,
          ),
        ],
      );
    } else {
      // Compact view mode
      return Column(
        children: [
          _buildInfoRow(Icons.note, 'Notes', _notesController.text),
        ],
      );
    }
  }

  Widget _buildAssignedOrphansSection() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
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
                Icon(Icons.family_restroom, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Assigned Orphans',
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildAssignedOrphansContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedOrphansContent() {
    final orphanRepository = context.watch<OrphanRepository>();

    return StreamBuilder<List<Orphan>>(
      stream: orphanRepository.getOrphansBySupervisor(widget.supervisorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(
            'No orphans assigned to this supervisor',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        final orphans = snapshot.data!;
        return Column(
          children: [
            Text(
              '${orphans.length} orphan${orphans.length != 1 ? 's' : ''} assigned',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...orphans.map((orphan) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        '${orphan.firstName.isNotEmpty ? orphan.firstName[0] : '?'}${orphan.fatherName.isNotEmpty ? orphan.fatherName[0] : '?'}'
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                        '${orphan.firstName.isNotEmpty ? orphan.firstName : 'Unknown'} ${orphan.fatherName.isNotEmpty ? orphan.fatherName : ''} ${orphan.grandfatherName.isNotEmpty ? orphan.grandfatherName : ''} ${orphan.familyName.isNotEmpty ? orphan.familyName : ''}'
                            .trim()),
                    subtitle: Text(
                      'Status: ${orphan.status.toString().split('.').last}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push('/orphan/${orphan.orphanId}');
                    },
                  ),
                )),
          ],
        );
      },
    );
  }

  // Helper method for compact view display
  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: TextStyle(
                color: value.isEmpty
                    ? Colors.grey.shade400
                    : (valueColor ?? Colors.black87),
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

  Widget _buildProfileHeader() {
    if (_supervisor == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor:
                  _isActive ? Colors.blue.shade600 : Colors.grey.shade600,
              child: Text(
                SupervisorRepository.getFullName(_supervisor!)
                    .split(' ')
                    .map((name) => name.isNotEmpty ? name[0] : '')
                    .take(2)
                    .join()
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              SupervisorRepository.getFullName(_supervisor!),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _positionController.text.isNotEmpty
                  ? _positionController.text
                  : 'Position not specified',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontStyle: _positionController.text.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
            if (_organizationController.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _organizationController.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    _isActive ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _isActive ? 'ACTIVE' : 'INACTIVE',
                style: TextStyle(
                  color: _isActive
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) async {
    if (_supervisor == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supervisor'),
        content: Text(
            'Are you sure you want to delete ${SupervisorRepository.getFullName(_supervisor!)}? This action cannot be undone and will affect any associated orphans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final supervisorRepository =
                    context.read<SupervisorRepository>();
                await supervisorRepository
                    .deleteSupervisor(_supervisor!.supervisorId);
                Navigator.of(context).pop(); // Close dialog
                context.go('/supervisors'); // Go back to supervisor list
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '${SupervisorRepository.getFullName(_supervisor!)} deleted successfully')));
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete supervisor: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
