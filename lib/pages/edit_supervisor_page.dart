import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

class EditSupervisorPage extends StatefulWidget {
  final String supervisorId;

  const EditSupervisorPage({super.key, required this.supervisorId});

  @override
  State<EditSupervisorPage> createState() => _EditSupervisorPageState();
}

class _EditSupervisorPageState extends State<EditSupervisorPage> {
  final _formKey = GlobalKey<FormState>();

  // Name fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _familyNameController = TextEditingController();

  // Contact fields
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternateContactController = TextEditingController();

  // Address fields
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();

  // Professional fields
  final _positionController = TextEditingController();
  final _organizationController = TextEditingController();

  // Additional fields
  final _notesController = TextEditingController();

  Supervisor? _supervisor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSupervisor();
  }

  void _loadSupervisor() async {
    try {
      final supervisorRepository = context.read<SupervisorRepository>();
      final supervisors = await supervisorRepository.getAllSupervisors();
      final supervisor = supervisors.firstWhere(
        (s) => s.supervisorId == widget.supervisorId,
      );

      setState(() {
        _supervisor = supervisor;
        _populateFields(supervisor);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading supervisor: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading supervisor: $e')),
      );
    }
  }

  void _populateFields(Supervisor supervisor) {
    _firstNameController.text = supervisor.firstName;
    _lastNameController.text = supervisor.lastName;
    _familyNameController.text = supervisor.familyName;
    _phoneNumberController.text = supervisor.phoneNumber;
    _emailController.text = supervisor.email ?? '';
    _alternateContactController.text = supervisor.alternateContact ?? '';
    _addressController.text = supervisor.address;
    _cityController.text = supervisor.city;
    _districtController.text = supervisor.district ?? '';
    _positionController.text = supervisor.position;
    _organizationController.text = supervisor.organization ?? '';
    _notesController.text = supervisor.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Supervisor'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: () => _submitForm(),
              child: const Text(
                'Save',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPersonalSection(),
                    const SizedBox(height: 16),
                    _buildContactSection(),
                    const SizedBox(height: 16),
                    _buildAddressSection(),
                    const SizedBox(height: 16),
                    _buildProfessionalSection(),
                    const SizedBox(height: 16),
                    _buildNotesSection(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPersonalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _familyNameController,
              decoration: const InputDecoration(labelText: 'Family Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position/Role'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _organizationController,
              decoration:
                  const InputDecoration(labelText: 'Organization (Optional)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Update Supervisor'),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _supervisor != null) {
      try {
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
          district: drift.Value(_districtController.text.isEmpty
              ? null
              : _districtController.text),
          position: _positionController.text,
          organization: drift.Value(_organizationController.text.isEmpty
              ? null
              : _organizationController.text),
          notes: drift.Value(
              _notesController.text.isEmpty ? null : _notesController.text),
        );

        await supervisorRepository.updateSupervisor(updatedSupervisor);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supervisor updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        context.pop();
      } catch (e) {
        print('Error updating supervisor: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update supervisor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
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
    super.dispose();
  }
}
