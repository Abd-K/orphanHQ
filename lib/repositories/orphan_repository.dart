import 'package:drift/drift.dart' as drift;
import 'package:orphan_hq/database.dart';
import '../services/qr_code_service.dart';

class OrphanRepository {
  final AppDb _db;

  OrphanRepository(this._db);

  Future<int> createOrphan(OrphansCompanion orphan) async {
    try {
      print('🔵 Creating orphan in repository...');

      // Insert the orphan first
      final orphanId = await _db.into(_db.orphans).insert(orphan);
      print('✅ Orphan inserted with database ID: $orphanId');

      // Get the created orphan to generate QR code
      // Since we're using OrphansCompanion.insert(), the orphanId is auto-generated
      // We need to find the recently created orphan
      final createdOrphan = await findRecentlyCreatedOrphan();
      if (createdOrphan != null) {
        print('✅ Retrieved created orphan with ID: ${createdOrphan.orphanId}');
        await _generateAndUpdateQRCode(createdOrphan);
      } else {
        print('⚠️ Could not retrieve created orphan for QR code generation');
      }

      return orphanId;
    } catch (e, stackTrace) {
      print('❌ Error in createOrphan: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _generateAndUpdateQRCode(Orphan orphan) async {
    try {
      // Generate QR code
      final qrCodePath = await QRCodeService.generateAndSaveQRCode(orphan);

      if (qrCodePath != null) {
        // Update orphan with QR code path
        await (_db.update(_db.orphans)
              ..where((tbl) => tbl.orphanId.equals(orphan.orphanId)))
            .write(OrphansCompanion(
          qrCodePath: drift.Value(qrCodePath),
        ));
      }
    } catch (e) {
      print('Error generating QR code for orphan ${orphan.orphanId}: $e');
    }
  }

  Future<void> regenerateQRCode(String orphanId) async {
    final orphan = await getOrphanById(orphanId);
    if (orphan != null) {
      await _generateAndUpdateQRCode(orphan);
    }
  }

  Future<void> deleteQRCode(String orphanId) async {
    try {
      // Delete QR code file
      await QRCodeService.deleteQRCodeFile(orphanId);

      // Update orphan record to remove QR code path
      await (_db.update(_db.orphans)
            ..where((tbl) => tbl.orphanId.equals(orphanId)))
          .write(OrphansCompanion(
        qrCodePath: const drift.Value.absent(),
      ));
    } catch (e) {
      print('Error deleting QR code for orphan $orphanId: $e');
    }
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
        lastStatusUpdate: drift.Value(DateTime.now()),
        lastUpdated: drift.Value(DateTime.now()),
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

  Future<Orphan?> findRecentlyCreatedOrphan() async {
    try {
      final orphansStream = getAllOrphans();
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
}
