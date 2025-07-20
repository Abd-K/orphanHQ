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

enum Gender {
  male,
  female,
}

enum EducationLevel {
  none,
  primary,
  intermediate,
  secondary,
  university,
  vocational,
}

enum HealthStatus {
  excellent,
  good,
  fair,
  poor,
  special_needs,
}

enum AccommodationType {
  family_home,
  orphanage,
  foster_care,
  relative_care,
  independent,
}

enum NutritionalStatus {
  excellent,
  good,
  moderate,
  weak,
  severe,
}

enum PsychologicalStatus {
  stable,
  anxious,
  depressed,
  disturbed,
}

enum DisabilityType {
  none,
  physical,
  mental,
  hearing,
  visual,
  multiple,
}

@DataClassName('Orphan')
class Orphans extends Table {
  TextColumn get orphanId => text().clientDefault(() => Uuid().v4())();

  // Basic Details (بيانات عن الطفل)
  TextColumn get firstName => text()(); // الاسم الأول
  TextColumn get lastName =>
      text().nullable()(); // Legacy field - use familyName instead
  TextColumn get fatherName => text()(); // اسم الأب
  TextColumn get grandfatherName => text()(); // اسم الجد
  TextColumn get familyName => text()(); // اسم العائلة
  IntColumn get gender => intEnum<Gender>()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get placeOfBirth => text().nullable()(); // مكان الميلاد
  TextColumn get nationality => text().nullable()(); // الجنسية
  TextColumn get idNumber => text().nullable()(); // رقم البطاقة الهوية
  IntColumn get status => intEnum<OrphanStatus>()();
  TextColumn get lastSeenLocation => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get supervisorId =>
      text().nullable().references(Supervisors, #supervisorId)();

  // Current Address (عنوانه الحالي)
  TextColumn get currentCountry => text().nullable()(); // البلد
  TextColumn get currentGovernorate =>
      text().nullable()(); // المحافظة أو الإقليم
  TextColumn get currentCity => text().nullable()(); // المدينة
  TextColumn get currentNeighborhood => text().nullable()(); // القرية
  TextColumn get currentCamp => text().nullable()(); // المخيم
  TextColumn get currentStreet => text().nullable()(); // الحي
  TextColumn get currentPhoneNumber => text().nullable()(); // رقم الهاتف

  // Father Details (والد الطفل)
  TextColumn get fatherFirstName => text().nullable()();
  TextColumn get fatherLastName => text().nullable()();
  DateTimeColumn get fatherDateOfBirth => dateTime().nullable()();
  DateTimeColumn get fatherDateOfDeath => dateTime().nullable()();
  TextColumn get fatherCauseOfDeath => text().nullable()();
  BoolColumn get fatherAlive => boolean().nullable()(); // على قيد الحياة؟
  TextColumn get fatherEducationLevel =>
      text().nullable()(); // المرحلة الدراسية
  TextColumn get fatherWork => text().nullable()(); // يعمل / نوع دخله
  TextColumn get fatherMonthlyIncome => text().nullable()(); // دخله الشهري
  IntColumn get fatherNumberOfWives => integer().nullable()(); // عدد الزوجات
  IntColumn get fatherNumberOfChildren => integer().nullable()(); // عدد الأبناء

  // Mother Details (والدة الطفل)
  TextColumn get motherFirstName => text().nullable()();
  TextColumn get motherLastName => text().nullable()();
  DateTimeColumn get motherDateOfBirth => dateTime().nullable()();
  DateTimeColumn get motherDateOfDeath => dateTime().nullable()();
  TextColumn get motherCauseOfDeath => text().nullable()();
  BoolColumn get motherAlive => boolean().nullable()(); // على قيد الحياة؟
  TextColumn get motherEducationLevel =>
      text().nullable()(); // المرحلة الدراسية
  TextColumn get motherWork => text().nullable()(); // تعمل / نوع العمل
  TextColumn get motherMonthlyIncome => text().nullable()(); // دخلها الشهري
  BoolColumn get motherRemarried =>
      boolean().nullable()(); // إذا كان الطفل يتيم هل الأم متزوجة حالياً؟
  BoolColumn get motherNeedsSupport => boolean().nullable()(); // تحتاج لطفل؟

  // Current Guardian (المعيل الحالي للطفل)
  TextColumn get guardianName => text().nullable()();
  TextColumn get guardianRelationship => text().nullable()(); // صلة القرابة
  TextColumn get guardianEducationLevel =>
      text().nullable()(); // المرحلة الدراسية
  TextColumn get guardianWork => text().nullable()(); // نوع عمله
  IntColumn get guardianNumberOfDependents =>
      integer().nullable()(); // عدد من يعيلهم
  TextColumn get guardianMonthlyIncome => text().nullable()(); // دخله الشهري

  // Educational Status (الحالة التعليمية للطفل)
  IntColumn get educationLevel => intEnum<EducationLevel>().nullable()();
  TextColumn get schoolName => text().nullable()(); // اسم المؤسسة التعليمية
  TextColumn get educationAddress =>
      text().nullable()(); // عنوان المؤسسة التعليمية
  TextColumn get educationCosts => text().nullable()(); // تكاليف الدراسة
  TextColumn get studyYear => text().nullable()(); // السنة الدراسية
  TextColumn get grade => text().nullable()(); // الصف
  TextColumn get educationStage => text().nullable()(); // المرحلة التعليمية
  TextColumn get studyType => text().nullable()(); // نوع الدراسة
  TextColumn get educationAchievement =>
      text().nullable()(); // مستوى التحصيل الدراسي
  TextColumn get lastStudyResult => text().nullable()(); // آخر نتيجة دراسية
  TextColumn get weakSubjects => text().nullable()(); // المواد الضعيف بها
  TextColumn get strongSubjects => text().nullable()(); // المواد المتفوق بها
  TextColumn get studyImprovementActions =>
      text().nullable()(); // الإجراءات لتحسين مستواه الدراسي
  TextColumn get reasonForNotStudying =>
      text().nullable()(); // سبب الضعف في المدرسه
  BoolColumn get stoppedStudying =>
      boolean().nullable()(); // في حال عدم الدراسة هل الأسباب؟
  TextColumn get reasonForStoppingStufy =>
      text().nullable()(); // في حال التوقف عن الدراسة هي الأسباب؟

  // Health Status (الحالة الصحية للطفل)
  IntColumn get healthStatus => intEnum<HealthStatus>().nullable()();
  IntColumn get psychologicalStatus =>
      intEnum<PsychologicalStatus>().nullable()(); // الحالة النفسية للطفل
  IntColumn get behavioralStatus =>
      intEnum<PsychologicalStatus>().nullable()(); // الحالة السلوكية للطفل
  TextColumn get nutritionalStatus =>
      text().nullable()(); // في حال سوء التغذية ما هي الأسباب؟
  TextColumn get disabilityType => text().nullable()(); // نوع الإعاقة
  IntColumn get disabilityLevel =>
      intEnum<DisabilityType>().nullable()(); // الحالة الصحية للطفل
  TextColumn get medicalConditions => text().nullable()();
  TextColumn get medications => text().nullable()();
  BoolColumn get needsMedicalSupport => boolean().nullable()();

  // Living Conditions (الوضع الحالي لسكن الطفل)
  IntColumn get accommodationType => intEnum<AccommodationType>().nullable()();
  TextColumn get accommodationAddress => text().nullable()();
  TextColumn get accommodationCondition =>
      text().nullable()(); // حالة أثاث المنزل
  TextColumn get accommodationOwnership => text().nullable()(); // حالة السكن
  BoolColumn get needsHousingSupport => boolean().nullable()();

  // Islamic Education & Hobbies
  TextColumn get quranMemorization => text().nullable()();
  BoolColumn get attendsIslamicSchool => boolean().nullable()();
  TextColumn get islamicEducationLevel => text().nullable()();
  TextColumn get hobbies => text().nullable()();
  TextColumn get skills => text().nullable()();
  TextColumn get aspirations => text().nullable()();

  // Siblings
  IntColumn get numberOfSiblings => integer().nullable()();
  TextColumn get siblingsDetails => text().nullable()();

  // Additional Info
  TextColumn get additionalNotes => text().nullable()();
  TextColumn get urgentNeeds => text().nullable()();
  TextColumn get specialCircumstances => text().nullable()();

  // Attachments (file paths or references)
  // TextColumn get photoPath => text().nullable()();
  TextColumn get documentsPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {orphanId};
}

class Supervisors extends Table {
  TextColumn get supervisorId => text().clientDefault(() => Uuid().v4())();

  // Name breakdown
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get familyName => text()();

  // Contact details
  TextColumn get phoneNumber => text()();
  TextColumn get email => text().nullable()();
  TextColumn get alternateContact => text().nullable()();

  // Address details
  TextColumn get address => text()();
  TextColumn get city => text()();
  TextColumn get district => text().nullable()();

  // Professional details
  TextColumn get position => text()(); // Position/Role
  TextColumn get organization =>
      text().nullable()(); // Organization they work for
  DateTimeColumn get dateJoined => dateTime().withDefault(currentDateAndTime)();

  // Security and status
  TextColumn get publicKey => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  // Additional information
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {supervisorId};
}

@DriftDatabase(tables: [Orphans, Supervisors])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 6; // Updated for lastName to 4-part name migration

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // NEVER DROP TABLES - Always preserve existing data
          // Instead, use column additions and data migrations

          if (from < 3) {
            // For orphans table, add new columns instead of dropping
            try {
              // Add any missing columns from comprehensive schema
              // Individual column additions would go here
              print('Migrating orphans table from version $from to $to');
            } catch (e) {
              print('Error migrating orphans table: $e');
              // Log error but don't drop data
            }
          }

          if (from < 4) {
            // For supervisors table, add new columns instead of dropping
            try {
              // Only add columns that don't exist
              await m.addColumn(supervisors, supervisors.alternateContact);
              print('Added alternateContact column to supervisors table');
            } catch (e) {
              // Column might already exist, which is fine
              print(
                  'Could not add alternateContact column (might already exist): $e');
            }
          }

          if (from < 5) {
            // Migration for name field changes (version 5)
            try {
              // Add new name columns if they don't exist
              await m.addColumn(orphans, orphans.fatherName);
              await m.addColumn(orphans, orphans.grandfatherName);
              print(
                  'Added fatherName and grandfatherName columns to orphans table');

              // If lastName column existed, migrate data
              // Note: This is for future reference - the data is already lost in this case
              // but this shows how to properly handle schema changes
            } catch (e) {
              print('Could not add name columns (might already exist): $e');
            }
          }

          if (from < 6) {
            // Migration to handle lastName column removal (version 6)
            try {
              // Make last_name column nullable if it exists
              await customStatement(
                  'ALTER TABLE orphans ADD COLUMN last_name_temp TEXT;');
              await customStatement(
                  'UPDATE orphans SET last_name_temp = last_name WHERE last_name IS NOT NULL;');
              print('Migrated lastName data to temporary column');

              // Drop the NOT NULL constraint by recreating without it
              // Note: SQLite doesn't support dropping columns directly,
              // so we'll just make sure new inserts don't require it
            } catch (e) {
              print('lastName column migration handled: $e');
            }
          }

          // Future migrations should follow the same pattern:
          // - Add new columns with addColumn()
          // - Migrate existing data using custom SQL if needed
          // - NEVER drop tables or use recreateAllViews() unless absolutely necessary
          // - Always increment schemaVersion when making changes
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
