import 'package:drift/drift.dart' as drift;
import 'package:orphan_hq/database.dart';

class OrphanRepository {
  final AppDb _db;

  OrphanRepository(this._db);

  Future<int> createOrphan(OrphansCompanion orphan) {
    return _db.into(_db.orphans).insert(orphan);
  }

  Stream<List<Orphan>> getAllOrphans() {
    return _db.select(_db.orphans).watch();
  }

  Stream<List<Orphan>> getMissingOrphans() {
    return (_db.select(_db.orphans)
          ..where((tbl) => tbl.status.equals(OrphanStatus.missing.index)))
        .watch();
  }

  Stream<List<Orphan>> getOrphansBySupervisor(String supervisorId) {
    return (_db.select(_db.orphans)
          ..where((tbl) => tbl.supervisorId.equals(supervisorId)))
        .watch();
  }

  Future<void> updateOrphanStatus(String orphanId, OrphanStatus status) {
    return (_db.update(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphanId)))
        .write(
      OrphansCompanion(
        status: drift.Value(status),
      ),
    );
  }

  Future<int> updateOrphan(Orphan orphan) {
    return (_db.update(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphan.orphanId)))
        .write(OrphansCompanion(
      firstName: drift.Value(orphan.firstName),
      fatherName: drift.Value(orphan.fatherName),
      grandfatherName: drift.Value(orphan.grandfatherName),
      familyName: drift.Value(orphan.familyName),
      gender: drift.Value(orphan.gender),
      status: drift.Value(orphan.status),
      dateOfBirth: drift.Value(orphan.dateOfBirth),
      lastUpdated: drift.Value(orphan.lastUpdated),
    ));
  }

  Future<int> updateOrphanWithCompanion(OrphansCompanion companion) {
    return (_db.update(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(companion.orphanId.value)))
        .write(companion);
  }

  Future<void> updateOrphanSupervisor(String orphanId, String newSupervisorId) {
    return (_db.update(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphanId)))
        .write(
      OrphansCompanion(
        supervisorId: drift.Value(newSupervisorId),
        lastUpdated: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteOrphan(String orphanId) {
    return (_db.delete(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphanId)))
        .go();
  }

  Future<Orphan?> getOrphanById(String orphanId) async {
    final query = _db.select(_db.orphans)
      ..where((tbl) => tbl.orphanId.equals(orphanId));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  }
}
