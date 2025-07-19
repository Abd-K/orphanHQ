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

  Future<void> updateOrphanStatus(String orphanId, OrphanStatus status) {
    return (_db.update(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphanId)))
        .write(
      OrphansCompanion(
        status: drift.Value(status),
      ),
    );
  }

  Future<int> deleteOrphan(String orphanId) {
    return (_db.delete(_db.orphans)
          ..where((tbl) => tbl.orphanId.equals(orphanId)))
        .go();
  }
}
