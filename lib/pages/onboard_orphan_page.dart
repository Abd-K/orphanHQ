import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:provider/provider.dart';

class OnboardOrphanPage extends StatefulWidget {
  const OnboardOrphanPage({super.key});

  @override
  State<OnboardOrphanPage> createState() => _OnboardOrphanPageState();
}

class _OnboardOrphanPageState extends State<OnboardOrphanPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  String? _selectedSupervisorId;
  OrphanStatus _selectedStatus = OrphanStatus.active;

  @override
  Widget build(BuildContext context) {
    final supervisorRepository = context.read<SupervisorRepository>();
    final orphanRepository = context.read<OrphanRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboard New Orphan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dayController,
                      decoration: const InputDecoration(labelText: 'Day (DD)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (value.length != 2) return 'Must be 2 digits';
                        final day = int.tryParse(value);
                        if (day == null || day < 1 || day > 31) return '01-31';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _monthController,
                      decoration:
                          const InputDecoration(labelText: 'Month (MM)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (value.length != 2) return 'Must be 2 digits';
                        final month = int.tryParse(value);
                        if (month == null || month < 1 || month > 12)
                          return '01-12';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      decoration:
                          const InputDecoration(labelText: 'Year (YYYY)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (value.length != 4) return 'Must be 4 digits';
                        final year = int.tryParse(value);
                        if (year == null ||
                            year < 1900 ||
                            year > DateTime.now().year) {
                          return '1900-${DateTime.now().year}';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
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
                    decoration: const InputDecoration(labelText: 'Supervisor'),
                    items: supervisors.map((supervisor) {
                      return DropdownMenuItem(
                        value: supervisor.supervisorId,
                        child: Text(supervisor.fullName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupervisorId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a supervisor';
                      }
                      return null;
                    },
                  );
                },
              ),
              DropdownButtonFormField<OrphanStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: OrphanStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final day = int.parse(_dayController.text);
                      final month = int.parse(_monthController.text);
                      final year = int.parse(_yearController.text);
                      final dob = DateTime(year, month, day);
                      final fullName =
                          '${_firstNameController.text} ${_lastNameController.text}';

                      final newOrphan = OrphansCompanion.insert(
                        fullName: fullName,
                        dateOfBirth: dob,
                        status: _selectedStatus,
                        lastUpdated: DateTime.now(),
                        supervisorId: _selectedSupervisorId!,
                      );
                      await orphanRepository.createOrphan(newOrphan);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Orphan created successfully!')),
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create orphan: $e')),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
