import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

class AddSupervisorPage extends StatefulWidget {
  const AddSupervisorPage({super.key});

  @override
  State<AddSupervisorPage> createState() => _AddSupervisorPageState();
}

class _AddSupervisorPageState extends State<AddSupervisorPage> {
  final _formKey = GlobalKey<FormState>();

  // Arabic tooltips are always shown

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

  // Comments controllers for each section
  final _personalInfoCommentsController = TextEditingController();
  final _contactInfoCommentsController = TextEditingController();
  final _addressInfoCommentsController = TextEditingController();
  final _professionalInfoCommentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final supervisorRepository = context.read<SupervisorRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supervisor'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Personal Information Section
              _buildSectionCard(
                'Personal Information',
                Icons.person,
                [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithTooltip(
                          controller: _firstNameController,
                          labelText: 'First Name',
                          arabicTooltip: 'الاسم الأول',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'First name is required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithTooltip(
                          controller: _lastNameController,
                          labelText: 'Last Name',
                          arabicTooltip: 'اسم العائلة',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Last name is required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _familyNameController,
                    labelText: 'Family Name',
                    arabicTooltip: 'اسم العائلة الكامل',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Family name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _personalInfoCommentsController,
                    labelText: 'Additional Comments',
                    arabicTooltip: 'ملاحظات إضافية',
                    maxLines: 3,
                  ),
                ],
                arabicTooltip: 'المعلومات الشخصية',
              ),

              const SizedBox(height: 16),

              // Contact Information Section
              _buildSectionCard(
                'Contact Information',
                Icons.phone,
                [
                  _buildTextFieldWithTooltip(
                    controller: _phoneNumberController,
                    labelText: 'Phone Number',
                    arabicTooltip: 'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Phone number is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _emailController,
                    labelText: 'Email (Optional)',
                    arabicTooltip: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _alternateContactController,
                    labelText: 'Alternate Contact (Optional)',
                    arabicTooltip: 'جهة اتصال بديلة',
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _contactInfoCommentsController,
                    labelText: 'Additional Comments',
                    arabicTooltip: 'ملاحظات إضافية',
                    maxLines: 3,
                  ),
                ],
                arabicTooltip: 'معلومات الاتصال',
              ),

              const SizedBox(height: 16),

              // Address Information Section
              _buildSectionCard(
                'Address Information',
                Icons.location_on,
                [
                  _buildTextFieldWithTooltip(
                    controller: _addressController,
                    labelText: 'Address',
                    arabicTooltip: 'العنوان',
                    maxLines: 2,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Address is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithTooltip(
                          controller: _cityController,
                          labelText: 'City',
                          arabicTooltip: 'المدينة',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'City is required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithTooltip(
                          controller: _districtController,
                          labelText: 'District (Optional)',
                          arabicTooltip: 'المنطقة',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _addressInfoCommentsController,
                    labelText: 'Additional Comments',
                    arabicTooltip: 'ملاحظات إضافية',
                    maxLines: 3,
                  ),
                ],
                arabicTooltip: 'معلومات العنوان',
              ),

              const SizedBox(height: 16),

              // Professional Information Section
              _buildSectionCard(
                'Professional Information',
                Icons.work,
                [
                  _buildTextFieldWithTooltip(
                    controller: _positionController,
                    labelText: 'Position/Role',
                    arabicTooltip: 'المنصب أو الدور',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Position is required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _organizationController,
                    labelText: 'Organization (Optional)',
                    arabicTooltip: 'المنظمة',
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithTooltip(
                    controller: _professionalInfoCommentsController,
                    labelText: 'Additional Comments',
                    arabicTooltip: 'ملاحظات إضافية',
                    maxLines: 3,
                  ),
                ],
                arabicTooltip: 'المعلومات المهنية',
              ),

              const SizedBox(height: 16),

              // Additional Information Section
              _buildSectionCard(
                'Additional Information',
                Icons.note,
                [
                  _buildTextFieldWithTooltip(
                    controller: _notesController,
                    labelText: 'Notes (Optional)',
                    arabicTooltip: 'ملاحظات إضافية',
                    maxLines: 3,
                  ),
                ],
                arabicTooltip: 'معلومات إضافية',
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(supervisorRepository),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Add Supervisor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children,
      {String? arabicTooltip}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (arabicTooltip != null) ...[
                  const SizedBox(width: 8),
                  Tooltip(
                    message: arabicTooltip,
                    preferBelow: false,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(arabicTooltip),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.translate,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper method to build text field with optional Arabic tooltip
  Widget _buildTextFieldWithTooltip({
    required TextEditingController controller,
    required String labelText,
    required String arabicTooltip,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
            ),
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: arabicTooltip,
          preferBelow: false,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(arabicTooltip),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm(SupervisorRepository supervisorRepository) async {
    if (_formKey.currentState!.validate()) {
      try {
        final newSupervisor = SupervisorsCompanion.insert(
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
          publicKey:
              'temp_key_${DateTime.now().millisecondsSinceEpoch}', // Temporary implementation
          notes: drift.Value(
              _notesController.text.isEmpty ? null : _notesController.text),
        );

        await supervisorRepository.createSupervisor(newSupervisor);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supervisor added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        print('Error creating supervisor: $e'); // Console logging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add supervisor: $e'),
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
