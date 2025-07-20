import 'package:drift/drift.dart' as drift;
import 'package:orphan_hq/database.dart';

class SupervisorRepository {
  final AppDb _db;

  SupervisorRepository(this._db);

  Future<List<Supervisor>> getAllSupervisors() {
    return _db.select(_db.supervisors).get();
  }

  Stream<List<Supervisor>> watchAllSupervisors() {
    return _db.select(_db.supervisors).watch();
  }

  Future<List<Supervisor>> getActiveSupervisors() {
    return (_db.select(_db.supervisors)
          ..where((tbl) => tbl.active.equals(true)))
        .get();
  }

  Stream<List<Supervisor>> watchActiveSupervisors() {
    return (_db.select(_db.supervisors)
          ..where((tbl) => tbl.active.equals(true)))
        .watch();
  }

  Future<int> createSupervisor(SupervisorsCompanion supervisor) {
    return _db.into(_db.supervisors).insert(supervisor);
  }

  Future<int> updateSupervisor(Supervisor supervisor) {
    return (_db.update(_db.supervisors)
          ..where((tbl) => tbl.supervisorId.equals(supervisor.supervisorId)))
        .write(SupervisorsCompanion(
      firstName: drift.Value(supervisor.firstName),
      lastName: drift.Value(supervisor.lastName),
      familyName: drift.Value(supervisor.familyName),
      phoneNumber: drift.Value(supervisor.phoneNumber),
      email: drift.Value(supervisor.email),
      alternateContact: drift.Value(supervisor.alternateContact),
      address: drift.Value(supervisor.address),
      city: drift.Value(supervisor.city),
      district: drift.Value(supervisor.district),
      position: drift.Value(supervisor.position),
      organization: drift.Value(supervisor.organization),
      notes: drift.Value(supervisor.notes),
    ));
  }

  Future<int> deleteSupervisor(String supervisorId) {
    return (_db.delete(_db.supervisors)
          ..where((tbl) => tbl.supervisorId.equals(supervisorId)))
        .go();
  }

  // Helper method to get full name from supervisor
  static String getFullName(Supervisor supervisor) {
    return '${supervisor.firstName} ${supervisor.lastName}';
  }

  // Helper method to get contact info from supervisor
  static String getContactInfo(Supervisor supervisor) {
    return supervisor.phoneNumber;
  }

  // Helper method to get location from supervisor
  static String getLocation(Supervisor supervisor) {
    return '${supervisor.city}${supervisor.district != null ? ', ${supervisor.district}' : ''}';
  }

  Future<Supervisor?> getSupervisorById(String supervisorId) async {
    final query = _db.select(_db.supervisors)
      ..where((tbl) => tbl.supervisorId.equals(supervisorId));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  }
}
