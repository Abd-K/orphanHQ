import 'package:orphan_hq/database.dart';

class SupervisorRepository {
  final AppDb _db;

  SupervisorRepository(this._db);

  Future<List<Supervisor>> getAllSupervisors() {
    return (_db.select(_db.supervisors)
          ..where((tbl) => tbl.active.equals(true)))
        .get();
  }

  Stream<List<Supervisor>> watchAllSupervisors() {
    return (_db.select(_db.supervisors)
          ..where((tbl) => tbl.active.equals(true)))
        .watch();
  }

  Future<int> createSupervisor(SupervisorsCompanion supervisor) {
    return _db.into(_db.supervisors).insert(supervisor);
  }

  Future<int> deleteSupervisor(String supervisorId) {
    return (_db.delete(_db.supervisors)
          ..where((tbl) => tbl.supervisorId.equals(supervisorId)))
        .go();
  }
}
