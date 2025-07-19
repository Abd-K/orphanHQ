import 'package:drift/drift.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

enum OrphanStatus {
  active,
  missing,
  found,
}

class Orphans extends Table {
  TextColumn get orphanId => text().clientDefault(() => Uuid().v4())();
  TextColumn get fullName => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  IntColumn get status => intEnum<OrphanStatus>()();
  TextColumn get lastSeenLocation => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get supervisorId =>
      text().references(Supervisors, #supervisorId)();

  @override
  Set<Column> get primaryKey => {orphanId};
}

class Supervisors extends Table {
  TextColumn get supervisorId => text().clientDefault(() => Uuid().v4())();
  TextColumn get fullName => text()();
  TextColumn get contactInfo => text()();
  TextColumn get location => text()();
  TextColumn get publicKey => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {supervisorId};
}

@DriftDatabase(tables: [Orphans, Supervisors])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
