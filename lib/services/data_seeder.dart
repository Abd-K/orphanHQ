import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../database.dart';

class DataSeeder {
  final AppDb database;
  final Random _random = Random();

  DataSeeder(this.database);

  String _getGazaAddress(int index, bool isArabic) {
    final gazaAddresses = isArabic
        ? [
            'شارع عمر المختار، غزة',
            'حي الرمال، غزة',
            'شارع الوحدة، خان يونس',
            'مخيم جباليا، جباليا',
            'حي الشجاعية، غزة',
            'البلدة القديمة، غزة',
            'شارع صلاح الدين، رفح',
            'حي الصبرة، غزة'
          ]
        : [
            'Omar Al-Mukhtar Street, Gaza',
            'Al-Rimal District, Gaza',
            'Al-Wahda Street, Khan Younis',
            'Jabalia Camp, Jabalia',
            'Al-Shuja\'iyya District, Gaza',
            'Old City, Gaza',
            'Salah al-Din Street, Rafah',
            'Al-Sabra District, Gaza'
          ];

    return gazaAddresses[index % gazaAddresses.length];
  }

  String _getMedicalConditions(bool isEnglish) {
    final conditions = isEnglish
        ? [
            'No known conditions',
            'Asthma',
            'Diabetes Type 1',
            'Epilepsy',
            'Heart condition',
            'Vision problems',
            'Hearing impairment',
            'Malnutrition',
            'Chronic cough',
            'Skin conditions'
          ]
        : [
            'لا توجد حالات مرضية معروفة',
            'الربو',
            'السكري النوع الأول',
            'الصرع',
            'مشاكل في القلب',
            'مشاكل في البصر',
            'ضعف السمع',
            'سوء التغذية',
            'سعال مزمن',
            'أمراض جلدية'
          ];
    return conditions[_random.nextInt(conditions.length)];
  }

  String _getMedications(bool isEnglish) {
    final medications = isEnglish
        ? [
            'None',
            'Insulin',
            'Inhaler for asthma',
            'Anti-seizure medication',
            'Vitamins',
            'Iron supplements',
            'Eye drops',
            'Pain relievers as needed'
          ]
        : [
            'لا يوجد',
            'الأنسولين',
            'بخاخ للربو',
            'أدوية مضادة للصرع',
            'فيتامينات',
            'مكملات الحديد',
            'قطرات العين',
            'مسكنات عند الحاجة'
          ];
    return medications[_random.nextInt(medications.length)];
  }

  String _getSchoolName(bool isEnglish) {
    final schools = isEnglish
        ? [
            'Gaza Elementary School',
            'Al-Azhar School',
            'Khan Younis Primary',
            'Rafah Educational Center',
            'Jabalia School Complex',
            'Deir al-Balah Academy',
            'Gaza Girls School',
            'Islamic Educational Institute'
          ]
        : [
            'مدرسة غزة الابتدائية',
            'مدرسة الأزهر',
            'مدرسة خان يونس الأساسية',
            'مركز رفح التعليمي',
            'مجمع مدارس جباليا',
            'أكاديمية دير البلح',
            'مدرسة غزة للبنات',
            'المعهد التعليمي الإسلامي'
          ];
    return schools[_random.nextInt(schools.length)];
  }

  String _getAccommodationAddress(bool isEnglish) {
    final addresses = isEnglish
        ? [
            'Refugee camp, Block A',
            'Temporary shelter, Gaza',
            'With relatives, Khan Younis',
            'Orphanage facility, Rafah',
            'Foster family home',
            'Community center housing',
            'Extended family residence',
            'Charitable organization shelter'
          ]
        : [
            'مخيم اللاجئين، المبنى أ',
            'مأوى مؤقت، غزة',
            'مع الأقارب، خان يونس',
            'دار الأيتام، رفح',
            'منزل عائلة حاضنة',
            'سكن المركز المجتمعي',
            'منزل العائلة الممتدة',
            'مأوى المنظمة الخيرية'
          ];
    return addresses[_random.nextInt(addresses.length)];
  }

  String _getQuranMemorization(bool isEnglish) {
    final levels = isEnglish
        ? [
            'Al-Fatiha only',
            'Short surahs (Juz Amma)',
            '2-3 Juz memorized',
            '5 Juz memorized',
            'Half Quran memorized',
            'Working on memorization',
            'Can recite basic prayers',
            'Advanced memorization'
          ]
        : [
            'الفاتحة فقط',
            'السور القصيرة (جزء عم)',
            'حفظ ٢-٣ أجزاء',
            'حفظ ٥ أجزاء',
            'حفظ نصف القرآن',
            'يعمل على الحفظ',
            'يحفظ الصلوات الأساسية',
            'حفظ متقدم'
          ];
    return levels[_random.nextInt(levels.length)];
  }

  String _getIslamicEducationLevel(bool isEnglish) {
    final levels = isEnglish
        ? [
            'Basic Islamic knowledge',
            'Intermediate level',
            'Advanced studies',
            'Quran recitation',
            'Islamic history',
            'Fiqh studies',
            'Arabic language',
            'Hadith studies'
          ]
        : [
            'معرفة إسلامية أساسية',
            'مستوى متوسط',
            'دراسات متقدمة',
            'تلاوة القرآن',
            'التاريخ الإسلامي',
            'دراسات الفقه',
            'اللغة العربية',
            'دراسات الحديث'
          ];
    return levels[_random.nextInt(levels.length)];
  }

  String _getHobbies(bool isEnglish) {
    final hobbies = isEnglish
        ? [
            'Reading, drawing',
            'Football, sports',
            'Cooking, helping family',
            'Music, singing',
            'Crafts, sewing',
            'Computer games',
            'Gardening',
            'Photography',
            'Writing stories',
            'Playing with friends'
          ]
        : [
            'القراءة، الرسم',
            'كرة القدم، الرياضة',
            'الطبخ، مساعدة العائلة',
            'الموسيقى، الغناء',
            'الحرف اليدوية، الخياطة',
            'ألعاب الكمبيوتر',
            'البستنة',
            'التصوير',
            'كتابة القصص',
            'اللعب مع الأصدقاء'
          ];
    return hobbies[_random.nextInt(hobbies.length)];
  }

  String _getSkills(bool isEnglish) {
    final skills = isEnglish
        ? [
            'Good at mathematics',
            'Excellent memory',
            'Leadership qualities',
            'Artistic abilities',
            'Good with technology',
            'Strong communication',
            'Problem solving',
            'Creative thinking',
            'Language skills',
            'Manual dexterity'
          ]
        : [
            'جيد في الرياضيات',
            'ذاكرة ممتازة',
            'صفات قيادية',
            'قدرات فنية',
            'جيد مع التكنولوجيا',
            'تواصل قوي',
            'حل المشاكل',
            'التفكير الإبداعي',
            'مهارات لغوية',
            'مهارة يدوية'
          ];
    return skills[_random.nextInt(skills.length)];
  }

  String _getAspirations(bool isEnglish) {
    final aspirations = isEnglish
        ? [
            'Become a doctor',
            'Study engineering',
            'Be a teacher',
            'Help other children',
            'Study computer science',
            'Become a pilot',
            'Work in medicine',
            'Be a journalist',
            'Study law',
            'Help rebuild Gaza'
          ]
        : [
            'أن يصبح طبيباً',
            'دراسة الهندسة',
            'أن يكون معلماً',
            'مساعدة الأطفال الآخرين',
            'دراسة علوم الكمبيوتر',
            'أن يصبح طياراً',
            'العمل في الطب',
            'أن يكون صحفياً',
            'دراسة القانون',
            'المساعدة في إعادة بناء غزة'
          ];
    return aspirations[_random.nextInt(aspirations.length)];
  }

  String _getSiblingsDetails(bool isEnglish) {
    final numSiblings = _random.nextInt(6) + 1;
    if (isEnglish) {
      final details = [
        'Older brother (${15 + _random.nextInt(10)} years old)',
        'Younger sister (${5 + _random.nextInt(8)} years old)',
        'Twin brother',
        'Two younger siblings',
        'Older sister studying in university',
        'Three siblings all in school',
        'One sibling with special needs',
        'Siblings living with different relatives'
      ];
      return 'Has $numSiblings siblings. ${details[_random.nextInt(details.length)]}';
    } else {
      final details = [
        'أخ أكبر (${15 + _random.nextInt(10)} سنة)',
        'أخت أصغر (${5 + _random.nextInt(8)} سنوات)',
        'أخ توأم',
        'شقيقان أصغر',
        'أخت كبرى تدرس في الجامعة',
        'ثلاثة أشقاء جميعهم في المدرسة',
        'شقيق واحد ذو احتياجات خاصة',
        'أشقاء يعيشون مع أقارب مختلفين'
      ];
      return 'لديه $numSiblings أشقاء. ${details[_random.nextInt(details.length)]}';
    }
  }

  String _getGuardianName(bool isEnglish) {
    final names = isEnglish
        ? [
            'Ahmed Al-Hassan (Uncle)',
            'Fatima Al-Ahmad (Aunt)',
            'Omar Al-Said (Grandfather)',
            'Khadija Al-Mohammed (Grandmother)',
            'Youssef Al-Ali (Family friend)',
            'Maryam Al-Khatib (Cousin)',
            'Ibrahim Al-Najjar (Uncle)',
            'Safiya Al-Hussein (Aunt)'
          ]
        : [
            'أحمد الحسن (العم)',
            'فاطمة الأحمد (العمة)',
            'عمر السيد (الجد)',
            'خديجة المحمد (الجدة)',
            'يوسف العلي (صديق العائلة)',
            'مريم الخطيب (ابنة العم)',
            'إبراهيم النجار (العم)',
            'صفية الحسين (الخالة)'
          ];
    return names[_random.nextInt(names.length)];
  }

  String _getGuardianRelationship(bool isEnglish) {
    final relationships = isEnglish
        ? [
            'Uncle (Father\'s brother)',
            'Aunt (Mother\'s sister)',
            'Grandfather (Paternal)',
            'Grandmother (Maternal)',
            'Family friend',
            'Cousin',
            'Uncle (Mother\'s brother)',
            'Aunt (Father\'s sister)'
          ]
        : [
            'العم (أخو الأب)',
            'الخالة (أخت الأم)',
            'الجد (من جهة الأب)',
            'الجدة (من جهة الأم)',
            'صديق العائلة',
            'ابن/بنت العم',
            'الخال (أخو الأم)',
            'العمة (أخت الأب)'
          ];
    return relationships[_random.nextInt(relationships.length)];
  }

  String _getAdditionalNotes(bool isEnglish) {
    final notes = isEnglish
        ? [
            'Very intelligent and eager to learn. Shows great potential in studies.',
            'Quiet child who needs encouragement. Responds well to positive reinforcement.',
            'Active and helpful. Often takes care of younger siblings.',
            'Talented in arts and crafts. Enjoys creative activities.',
            'Good student with strong memory. Excels in Quran memorization.',
            'Friendly and social. Gets along well with other children.',
            'Requires special attention due to past trauma. Shows improvement with care.',
            'Hardworking and responsible. Helps with household duties.'
          ]
        : [
            'طفل ذكي جداً ومتحمس للتعلم. يظهر إمكانيات كبيرة في الدراسة.',
            'طفل هادئ يحتاج للتشجيع. يستجيب جيداً للتعزيز الإيجابي.',
            'نشيط ومفيد. غالباً ما يعتني بالأشقاء الأصغر.',
            'موهوب في الفنون والحرف. يستمتع بالأنشطة الإبداعية.',
            'طالب جيد بذاكرة قوية. يتفوق في حفظ القرآن.',
            'ودود واجتماعي. يتعامل جيداً مع الأطفال الآخرين.',
            'يحتاج عناية خاصة بسبب الصدمة السابقة. يظهر تحسناً مع الرعاية.',
            'مجتهد ومسؤول. يساعد في الأعمال المنزلية.'
          ];
    return notes[_random.nextInt(notes.length)];
  }

  String _getUrgentNeeds(bool isEnglish) {
    final needs = isEnglish
        ? [
            'Winter clothing and shoes',
            'Medical check-up and treatment',
            'School supplies and books',
            'Nutritional support',
            'Psychological counseling',
            'Safe accommodation',
            'Educational support',
            'Medical equipment',
            'Warm blankets and bedding',
            'Regular meals and nutrition'
          ]
        : [
            'ملابس شتوية وأحذية',
            'فحص طبي وعلاج',
            'مستلزمات مدرسية وكتب',
            'دعم غذائي',
            'استشارة نفسية',
            'سكن آمن',
            'دعم تعليمي',
            'معدات طبية',
            'بطانيات دافئة وفراش',
            'وجبات منتظمة وتغذية'
          ];
    return needs[_random.nextInt(needs.length)];
  }

  Future<void> _createSampleDocuments(
      String documentId, int orphanIndex) async {
    try {
      // Get app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final documentsDir =
          Directory(p.join(appDocDir.path, 'orphan_documents'));

      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // Create sample document files (using placeholder text files for now)
      final sampleDocs = [
        'birth_cert:${p.join(documentsDir.path, '${documentId}_birth_cert.txt')}',
        'orphan_id:${p.join(documentsDir.path, '${documentId}_orphan_id.txt')}',
        'recent:${p.join(documentsDir.path, '${documentId}_recent_photo.txt')}',
      ];

      // Create the actual files
      for (final docPath in sampleDocs) {
        final parts = docPath.split(':');
        final docType = parts[0];
        final filePath = parts[1];

        final file = File(filePath);
        final content =
            'Sample $docType document for orphan $orphanIndex\nCreated: ${DateTime.now()}';
        await file.writeAsString(content);
      }

      print(
          'Created ${sampleDocs.length} sample documents for orphan $orphanIndex');
    } catch (e) {
      print('Error creating sample documents: $e');
    }
  }

  Future<void> _updateOrphanDocuments(
      String documentId, int orphanIndex) async {
    try {
      // Get app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final documentsDir =
          Directory(p.join(appDocDir.path, 'orphan_documents'));

      // Build document paths string
      final documentPaths = [
        'birth_cert:${p.join(documentsDir.path, '${documentId}_birth_cert.txt')}',
        'orphan_id:${p.join(documentsDir.path, '${documentId}_orphan_id.txt')}',
        'recent:${p.join(documentsDir.path, '${documentId}_recent_photo.txt')}',
      ].join(',');

      // Update the orphan record with document paths
      // Find the orphan by matching fields since we can't easily get the UUID
      final orphans = await database.select(database.orphans).get();
      if (orphans.length > orphanIndex) {
        final orphan = orphans[orphanIndex];
        await (database.update(database.orphans)
              ..where((tbl) => tbl.orphanId.equals(orphan.orphanId)))
            .write(OrphansCompanion(
          documentsPath: Value(documentPaths),
          lastUpdated: Value(DateTime.now()),
        ));

        print('Updated document paths for orphan $orphanIndex');
      }
    } catch (e) {
      print('Error updating orphan documents: $e');
    }
  }

  // Separate Arabic and English name sets for consistency
  static const List<String> arabicFirstNames = [
    'أحمد',
    'محمد',
    'علي',
    'عبدالله',
    'عبدالرحمن',
    'يوسف',
    'إبراهيم',
    'عمر',
    'فاطمة',
    'عائشة',
    'خديجة',
    'زينب',
    'مريم',
    'سارة',
    'ليلى',
    'نور'
  ];

  static const List<String> englishFirstNames = [
    'Ahmad',
    'Mohammed',
    'Ali',
    'Abdullah',
    'Omar',
    'Youssef',
    'Ibrahim',
    'Hassan',
    'Fatima',
    'Aisha',
    'Zeinab',
    'Sarah',
    'Layla',
    'Nour',
    'Mariam',
    'Khadija'
  ];

  static const List<String> arabicFatherNames = [
    'عبدالله',
    'محمد',
    'أحمد',
    'علي',
    'حسن',
    'حسين',
    'إبراهيم',
    'عمر'
  ];

  static const List<String> englishFatherNames = [
    'Abdullah',
    'Mohammed',
    'Ahmad',
    'Ali',
    'Hassan',
    'Hussein',
    'Ibrahim',
    'Omar'
  ];

  static const List<String> arabicGrandfatherNames = [
    'عبدالرحمن',
    'عبدالله',
    'محمد',
    'أحمد',
    'علي',
    'حسن',
    'إبراهيم',
    'عمر'
  ];

  static const List<String> englishGrandfatherNames = [
    'Abdulrahman',
    'Abdullah',
    'Mohammed',
    'Ahmad',
    'Ali',
    'Hassan',
    'Ibrahim',
    'Omar'
  ];

  static const List<String> arabicFamilyNames = [
    'الأحمد',
    'المحمد',
    'العلي',
    'الحسن',
    'الحسين',
    'السيد',
    'الخطيب',
    'النجار',
    'الحداد',
    'الطبيب',
    'الشاعر',
    'الكاتب',
    'السلامة',
    'الأمين',
    'الصالح',
    'الرشيد'
  ];

  static const List<String> englishFamilyNames = [
    'Al-Ahmad',
    'Al-Mohammed',
    'Al-Ali',
    'Al-Hassan',
    'Al-Hussein',
    'Al-Saeed',
    'Al-Khatib',
    'Al-Najjar',
    'Al-Haddad',
    'Al-Tabeeb',
    'Al-Shaer',
    'Al-Katib'
  ];

  static const List<String> gazaCities = [
    'غزة',
    'خان يونس',
    'رفح',
    'جباليا',
    'بيت حانون',
    'بيت لاهيا',
    'دير البلح',
    'الزوايدة',
    'Gaza City',
    'Khan Younis',
    'Rafah',
    'Jabalia',
    'Beit Hanoun',
    'Beit Lahia',
    'Deir al-Balah',
    'Al-Zawayda'
  ];

  static const List<String> phoneNumbers = [
    '+963-11-1234567',
    '+963-21-2345678',
    '+963-31-3456789',
    '+963-41-4567890',
    '+963-51-5678901',
    '+963-61-6789012',
    '+963-71-7890123',
    '+963-81-8901234'
  ];

  static const List<String> educationLevels = [
    'لا يوجد',
    'ابتدائية',
    'إعدادية',
    'ثانوية',
    'جامعة',
    'مهنية',
    'None',
    'Primary',
    'Middle',
    'Secondary',
    'University',
    'Vocational'
  ];

  static const List<String> occupations = [
    'موظف',
    'مدرس',
    'طبيب',
    'مهندس',
    'عامل',
    'تاجر',
    'ربة منزل',
    'متقاعد',
    'Employee',
    'Teacher',
    'Doctor',
    'Engineer',
    'Worker',
    'Merchant',
    'Housewife',
    'Retired'
  ];

  static const List<String> healthConditions = [
    'ممتازة',
    'جيدة',
    'متوسطة',
    'ضعيفة',
    'احتياجات خاصة',
    'Excellent',
    'Good',
    'Fair',
    'Poor',
    'Special needs'
  ];

  static const List<String> hobbies = [
    'كرة القدم',
    'الرسم',
    'القراءة',
    'الموسيقى',
    'السباحة',
    'الطبخ',
    'Football',
    'Drawing',
    'Reading',
    'Music',
    'Swimming',
    'Cooking'
  ];

  Future<void> seedData() async {
    try {
      print('🌱 Starting data seeding...');

      // Clear existing data first
      await _clearExistingData();

      // Create supervisors first
      final supervisors = await _createSupervisors();
      print('✅ Created ${supervisors.length} supervisors');

      // Create orphans
      await _createOrphans(supervisors);
      print('✅ Created 8 orphans');

      print('🎉 Data seeding completed successfully!');
    } catch (e) {
      print('❌ SEEDER ERROR: $e');
      rethrow; // Re-throw so UI can handle it
    }
  }

  Future<void> _clearExistingData() async {
    print('🧹 Clearing existing data...');
    await database.delete(database.orphans).go();
    await database.delete(database.supervisors).go();
  }

  Future<List<Supervisor>> _createSupervisors() async {
    final supervisors = <Supervisor>[];

    for (int i = 0; i < 4; i++) {
      // Mix Arabic and English names, make supervisor 3 inactive
      final isArabic = i < 2;
      final isActive = i != 2; // Make supervisor 3 inactive

      final supervisor = SupervisorsCompanion.insert(
        supervisorId: Value(Uuid().v4()), // Explicitly generate UUID
        firstName: isArabic
            ? arabicFirstNames[i % arabicFirstNames.length]
            : englishFirstNames[i % englishFirstNames.length],
        lastName: isArabic
            ? arabicFamilyNames[i % arabicFamilyNames.length]
            : englishFamilyNames[i % englishFamilyNames.length],
        familyName: isArabic
            ? arabicFamilyNames[i % arabicFamilyNames.length]
            : englishFamilyNames[i % englishFamilyNames.length],
        phoneNumber: phoneNumbers[i],
        email: Value('supervisor${i + 1}@orphanhq.org'),
        alternateContact: Value(phoneNumbers[i + 4]),
        address:
            isArabic ? _getGazaAddress(i, true) : _getGazaAddress(i, false),
        city: gazaCities[i % gazaCities.length],
        district: Value(isArabic ? 'المركز' : 'Central District'),
        position: i.isEven
            ? (isArabic ? 'مدير حالات' : 'Case Manager')
            : (isArabic ? 'مختص نفسي' : 'Psychologist'),
        organization:
            Value(isArabic ? 'دار الأيتام الخيرية' : 'Orphan Care Foundation'),
        publicKey: 'public_key_${i + 1}',
        notes: Value(isArabic
            ? 'مشرف/ة متخصص/ة في رعاية الأطفال الأيتام'
            : 'Specialized supervisor in orphan care'),
        active: Value(isActive),
      );

      try {
        final createdSupervisor = await database
            .into(database.supervisors)
            .insertReturning(supervisor);
        supervisors.add(createdSupervisor);
        print('✅ Created supervisor ${i + 1}');
      } catch (e) {
        print('❌ Error creating supervisor ${i + 1}: $e');
        rethrow;
      }
    }

    return supervisors;
  }

  Future<void> _createOrphans(List<Supervisor> supervisors) async {
    for (int i = 0; i < 8; i++) {
      final isGirl = i.isEven;

      // Supervisor assignment logic:
      // - Orphan 7 (index 7) → inactive supervisor (index 2)
      // - Orphans 5, 6, 8 (indices 4, 5, 7) → no supervisor (unsupervised)
      // - Others → active supervisors
      String? assignedSupervisorId;
      if (i == 7) {
        // Assign to inactive supervisor
        assignedSupervisorId = supervisors[2].supervisorId;
      } else if (i >= 4 && i <= 6) {
        // Leave unsupervised (no supervisor assigned)
        assignedSupervisorId = null;
      } else {
        // Assign to active supervisors (cycling through available ones)
        final activeSupervisors =
            supervisors.where((s) => s.active ?? true).toList();
        assignedSupervisorId =
            activeSupervisors[i % activeSupervisors.length].supervisorId;
      }

      // Generate realistic dates
      final birthDate = DateTime.now().subtract(Duration(
          days: (5 * 365) + _random.nextInt(10 * 365))); // 5-15 years old

      // Vary orphan status - most active, some missing, some found
      OrphanStatus orphanStatus;
      if (i < 5) {
        orphanStatus = OrphanStatus.active;
      } else if (i == 6) {
        orphanStatus = OrphanStatus.missing;
      } else {
        orphanStatus = OrphanStatus.found;
      }

      // Consistent language per entry (half English, half Arabic)
      final isEnglish = i >= 4;
      final fatherDeathDate =
          birthDate.add(Duration(days: _random.nextInt(2 * 365)));

      final orphan = OrphansCompanion.insert(
        orphanId: Value(Uuid().v4()), // Explicitly generate UUID
        firstName: isEnglish
            ? englishFirstNames[_random.nextInt(englishFirstNames.length)]
            : arabicFirstNames[_random.nextInt(arabicFirstNames.length)],
        lastName: Value(isEnglish
            ? englishFamilyNames[_random.nextInt(englishFamilyNames.length)]
            : arabicFamilyNames[_random.nextInt(arabicFamilyNames.length)]),
        fatherName: isEnglish
            ? englishFatherNames[_random.nextInt(englishFatherNames.length)]
            : arabicFatherNames[_random.nextInt(arabicFatherNames.length)],
        grandfatherName: isEnglish
            ? englishGrandfatherNames[
                _random.nextInt(englishGrandfatherNames.length)]
            : arabicGrandfatherNames[
                _random.nextInt(arabicGrandfatherNames.length)],
        familyName: isEnglish
            ? englishFamilyNames[_random.nextInt(englishFamilyNames.length)]
            : arabicFamilyNames[_random.nextInt(arabicFamilyNames.length)],
        gender: isGirl ? Gender.female : Gender.male,
        dateOfBirth: birthDate,
        placeOfBirth: Value(gazaCities[_random.nextInt(gazaCities.length)]),
        nationality: Value(isEnglish ? 'Syrian' : 'سورية'),
        idNumber: Value('ID${1000000 + _random.nextInt(9000000)}'),
        status: orphanStatus,
        lastUpdated: DateTime.now(),
        supervisorId: Value(assignedSupervisorId), // Now properly nullable

        // Address details
        currentCountry: Value(isEnglish ? 'Syria' : 'سوريا'),
        currentGovernorate: Value('Gaza Strip'),
        currentCity: Value(gazaCities[_random.nextInt(gazaCities.length)]),
        currentNeighborhood:
            Value(isEnglish ? 'Central District' : 'حي المركز'),
        currentStreet: Value(isEnglish ? 'Main Street' : 'الشارع الرئيسي'),
        currentPhoneNumber:
            Value(phoneNumbers[_random.nextInt(phoneNumbers.length)]),

        // Father details
        fatherFirstName: Value(isEnglish
            ? englishFatherNames[_random.nextInt(englishFatherNames.length)]
            : arabicFatherNames[_random.nextInt(arabicFatherNames.length)]),
        fatherLastName: Value(isEnglish
            ? englishFamilyNames[_random.nextInt(englishFamilyNames.length)]
            : arabicFamilyNames[_random.nextInt(arabicFamilyNames.length)]),
        fatherDateOfBirth: Value(birthDate.subtract(Duration(days: 25 * 365))),
        fatherDateOfDeath: Value(fatherDeathDate),
        fatherCauseOfDeath: Value(isEnglish ? 'Illness' : 'مرض'),
        fatherAlive: const Value(false),
        fatherEducationLevel:
            Value(educationLevels[_random.nextInt(educationLevels.length)]),
        fatherWork: Value(occupations[_random.nextInt(occupations.length)]),
        fatherMonthlyIncome: Value(
            '${500 + _random.nextInt(2000)} ${isEnglish ? "SYP" : "ليرة سورية"}'),
        fatherNumberOfWives: Value(1 + _random.nextInt(2)),
        fatherNumberOfChildren: Value(2 + _random.nextInt(5)),

        // Mother details
        motherFirstName: Value(isEnglish
            ? englishFirstNames[8 + _random.nextInt(8)] // Female names
            : arabicFirstNames[8 + _random.nextInt(8)]), // Female names
        motherLastName: Value(isEnglish
            ? englishFamilyNames[_random.nextInt(englishFamilyNames.length)]
            : arabicFamilyNames[_random.nextInt(arabicFamilyNames.length)]),
        motherDateOfBirth: Value(birthDate.subtract(Duration(days: 22 * 365))),
        motherAlive: Value(_random.nextBool()),
        motherEducationLevel:
            Value(educationLevels[_random.nextInt(educationLevels.length)]),
        motherWork: Value(occupations[_random.nextInt(occupations.length)]),
        motherMonthlyIncome: Value(
            '${200 + _random.nextInt(1000)} ${isEnglish ? "SYP" : "ليرة سورية"}'),

        // Health
        healthStatus: Value(
            HealthStatus.values[_random.nextInt(HealthStatus.values.length)]),
        medicalConditions: Value(_getMedicalConditions(isEnglish)),
        medications: Value(_getMedications(isEnglish)),
        needsMedicalSupport: Value(_random.nextBool()),

        // Education
        educationLevel: Value(EducationLevel
            .values[_random.nextInt(EducationLevel.values.length)]),
        schoolName: Value(_getSchoolName(isEnglish)),
        grade: Value('${_random.nextInt(12) + 1}'),

        // Accommodation
        accommodationType: Value(AccommodationType
            .values[_random.nextInt(AccommodationType.values.length)]),
        accommodationAddress: Value(_getAccommodationAddress(isEnglish)),
        needsHousingSupport: Value(_random.nextBool()),

        // Islamic Education & Personal
        quranMemorization: Value(_getQuranMemorization(isEnglish)),
        attendsIslamicSchool: Value(_random.nextBool()),
        islamicEducationLevel: Value(_getIslamicEducationLevel(isEnglish)),
        hobbies: Value(_getHobbies(isEnglish)),
        skills: Value(_getSkills(isEnglish)),
        aspirations: Value(_getAspirations(isEnglish)),

        // Siblings & Family
        numberOfSiblings: Value(_random.nextInt(6) + 1), // 1-6 siblings
        siblingsDetails: Value(_getSiblingsDetails(isEnglish)),

        // Guardian/Carer details
        guardianName: Value(_getGuardianName(isEnglish)),
        guardianRelationship: Value(_getGuardianRelationship(isEnglish)),

        // Additional information
        additionalNotes: Value(_getAdditionalNotes(isEnglish)),
        urgentNeeds: Value(_getUrgentNeeds(isEnglish)),
      );

      try {
        // Insert the orphan first
        await database.into(database.orphans).insert(orphan);
        print('✅ Created orphan ${i + 1}');

        // Create sample document attachments for this orphan
        // Use a simple document ID since we can't easily get the orphan UUID back
        final documentId =
            'orphan_${i + 1}_${DateTime.now().millisecondsSinceEpoch}';
        await _createSampleDocuments(documentId, i + 1);

        // Update the orphan with document paths
        await _updateOrphanDocuments(documentId, i);

        // Copy a placeholder image for this orphan
        await _copyPlaceholderImage(i + 1);
      } catch (e) {
        print('❌ Error creating orphan ${i + 1}: $e');
        rethrow;
      }
    }
  }

  Future<void> _copyPlaceholderImage(int orphanIndex) async {
    try {
      // Get app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final orphanPhotosDir =
          Directory(p.join(appDocDir.path, 'orphan_photos'));

      if (!await orphanPhotosDir.exists()) {
        await orphanPhotosDir.create(recursive: true);
      }

      // Use one of the app icons as placeholder
      final sourceIcon = File(
          'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png');
      if (await sourceIcon.exists()) {
        final targetFile =
            File(p.join(orphanPhotosDir.path, 'orphan_$orphanIndex.png'));
        await sourceIcon.copy(targetFile.path);
        print('📸 Created placeholder image for orphan $orphanIndex');
      }
    } catch (e) {
      print(
          '⚠️ Could not create placeholder image for orphan $orphanIndex: $e');
    }
  }
}
