import 'dart:io';
import '../lib/database.dart';
import '../lib/services/data_seeder.dart';

Future<void> main() async {
  print('🌱 Orphan HQ Data Seeder');
  print('========================');

  try {
    final database = AppDb();
    final seeder = DataSeeder(database);

    print('This will clear existing data and create:');
    print('- 4 supervisors');
    print('- 8 orphans with realistic data');
    print('- Placeholder images');
    print('');

    stdout.write('Continue? (y/N): ');
    final response = stdin.readLineSync()?.toLowerCase();

    if (response == 'y' || response == 'yes') {
      await seeder.seedData();
      print('');
      print('✅ Data seeding completed successfully!');
      print('You can now run the app to see the test data.');
    } else {
      print('❌ Data seeding cancelled.');
    }

    await database.close();
  } catch (e, stackTrace) {
    print('❌ Error during data seeding: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}
