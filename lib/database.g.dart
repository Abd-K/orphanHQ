// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SupervisorsTable extends Supervisors
    with TableInfo<$SupervisorsTable, Supervisor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupervisorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => Uuid().v4());
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contactInfoMeta =
      const VerificationMeta('contactInfo');
  @override
  late final GeneratedColumn<String> contactInfo = GeneratedColumn<String>(
      'contact_info', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [supervisorId, fullName, contactInfo, location, publicKey, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supervisors';
  @override
  VerificationContext validateIntegrity(Insertable<Supervisor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('contact_info')) {
      context.handle(
          _contactInfoMeta,
          contactInfo.isAcceptableOrUnknown(
              data['contact_info']!, _contactInfoMeta));
    } else if (isInserting) {
      context.missing(_contactInfoMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {supervisorId};
  @override
  Supervisor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supervisor(
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      contactInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_info'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $SupervisorsTable createAlias(String alias) {
    return $SupervisorsTable(attachedDatabase, alias);
  }
}

class Supervisor extends DataClass implements Insertable<Supervisor> {
  final String supervisorId;
  final String fullName;
  final String contactInfo;
  final String location;
  final String publicKey;
  final bool active;
  const Supervisor(
      {required this.supervisorId,
      required this.fullName,
      required this.contactInfo,
      required this.location,
      required this.publicKey,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['supervisor_id'] = Variable<String>(supervisorId);
    map['full_name'] = Variable<String>(fullName);
    map['contact_info'] = Variable<String>(contactInfo);
    map['location'] = Variable<String>(location);
    map['public_key'] = Variable<String>(publicKey);
    map['active'] = Variable<bool>(active);
    return map;
  }

  SupervisorsCompanion toCompanion(bool nullToAbsent) {
    return SupervisorsCompanion(
      supervisorId: Value(supervisorId),
      fullName: Value(fullName),
      contactInfo: Value(contactInfo),
      location: Value(location),
      publicKey: Value(publicKey),
      active: Value(active),
    );
  }

  factory Supervisor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supervisor(
      supervisorId: serializer.fromJson<String>(json['supervisorId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      location: serializer.fromJson<String>(json['location']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'supervisorId': serializer.toJson<String>(supervisorId),
      'fullName': serializer.toJson<String>(fullName),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'location': serializer.toJson<String>(location),
      'publicKey': serializer.toJson<String>(publicKey),
      'active': serializer.toJson<bool>(active),
    };
  }

  Supervisor copyWith(
          {String? supervisorId,
          String? fullName,
          String? contactInfo,
          String? location,
          String? publicKey,
          bool? active}) =>
      Supervisor(
        supervisorId: supervisorId ?? this.supervisorId,
        fullName: fullName ?? this.fullName,
        contactInfo: contactInfo ?? this.contactInfo,
        location: location ?? this.location,
        publicKey: publicKey ?? this.publicKey,
        active: active ?? this.active,
      );
  Supervisor copyWithCompanion(SupervisorsCompanion data) {
    return Supervisor(
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      contactInfo:
          data.contactInfo.present ? data.contactInfo.value : this.contactInfo,
      location: data.location.present ? data.location.value : this.location,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supervisor(')
          ..write('supervisorId: $supervisorId, ')
          ..write('fullName: $fullName, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('location: $location, ')
          ..write('publicKey: $publicKey, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      supervisorId, fullName, contactInfo, location, publicKey, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supervisor &&
          other.supervisorId == this.supervisorId &&
          other.fullName == this.fullName &&
          other.contactInfo == this.contactInfo &&
          other.location == this.location &&
          other.publicKey == this.publicKey &&
          other.active == this.active);
}

class SupervisorsCompanion extends UpdateCompanion<Supervisor> {
  final Value<String> supervisorId;
  final Value<String> fullName;
  final Value<String> contactInfo;
  final Value<String> location;
  final Value<String> publicKey;
  final Value<bool> active;
  final Value<int> rowid;
  const SupervisorsCompanion({
    this.supervisorId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.location = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupervisorsCompanion.insert({
    this.supervisorId = const Value.absent(),
    required String fullName,
    required String contactInfo,
    required String location,
    required String publicKey,
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fullName = Value(fullName),
        contactInfo = Value(contactInfo),
        location = Value(location),
        publicKey = Value(publicKey);
  static Insertable<Supervisor> custom({
    Expression<String>? supervisorId,
    Expression<String>? fullName,
    Expression<String>? contactInfo,
    Expression<String>? location,
    Expression<String>? publicKey,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (fullName != null) 'full_name': fullName,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (location != null) 'location': location,
      if (publicKey != null) 'public_key': publicKey,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupervisorsCompanion copyWith(
      {Value<String>? supervisorId,
      Value<String>? fullName,
      Value<String>? contactInfo,
      Value<String>? location,
      Value<String>? publicKey,
      Value<bool>? active,
      Value<int>? rowid}) {
    return SupervisorsCompanion(
      supervisorId: supervisorId ?? this.supervisorId,
      fullName: fullName ?? this.fullName,
      contactInfo: contactInfo ?? this.contactInfo,
      location: location ?? this.location,
      publicKey: publicKey ?? this.publicKey,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (contactInfo.present) {
      map['contact_info'] = Variable<String>(contactInfo.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupervisorsCompanion(')
          ..write('supervisorId: $supervisorId, ')
          ..write('fullName: $fullName, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('location: $location, ')
          ..write('publicKey: $publicKey, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrphansTable extends Orphans with TableInfo<$OrphansTable, Orphan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrphansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orphanIdMeta =
      const VerificationMeta('orphanId');
  @override
  late final GeneratedColumn<String> orphanId = GeneratedColumn<String>(
      'orphan_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => Uuid().v4());
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyNameMeta =
      const VerificationMeta('familyName');
  @override
  late final GeneratedColumn<String> familyName = GeneratedColumn<String>(
      'family_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Gender, int> gender =
      GeneratedColumn<int>('gender', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Gender>($OrphansTable.$convertergender);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _placeOfBirthMeta =
      const VerificationMeta('placeOfBirth');
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
      'place_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nationalityMeta =
      const VerificationMeta('nationality');
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
      'nationality', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idNumberMeta =
      const VerificationMeta('idNumber');
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
      'id_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<OrphanStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<OrphanStatus>($OrphansTable.$converterstatus);
  static const VerificationMeta _lastSeenLocationMeta =
      const VerificationMeta('lastSeenLocation');
  @override
  late final GeneratedColumn<String> lastSeenLocation = GeneratedColumn<String>(
      'last_seen_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES supervisors (supervisor_id)'));
  static const VerificationMeta _currentCountryMeta =
      const VerificationMeta('currentCountry');
  @override
  late final GeneratedColumn<String> currentCountry = GeneratedColumn<String>(
      'current_country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentGovernorateMeta =
      const VerificationMeta('currentGovernorate');
  @override
  late final GeneratedColumn<String> currentGovernorate =
      GeneratedColumn<String>('current_governorate', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentCityMeta =
      const VerificationMeta('currentCity');
  @override
  late final GeneratedColumn<String> currentCity = GeneratedColumn<String>(
      'current_city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentNeighborhoodMeta =
      const VerificationMeta('currentNeighborhood');
  @override
  late final GeneratedColumn<String> currentNeighborhood =
      GeneratedColumn<String>('current_neighborhood', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentCampMeta =
      const VerificationMeta('currentCamp');
  @override
  late final GeneratedColumn<String> currentCamp = GeneratedColumn<String>(
      'current_camp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentStreetMeta =
      const VerificationMeta('currentStreet');
  @override
  late final GeneratedColumn<String> currentStreet = GeneratedColumn<String>(
      'current_street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentPhoneNumberMeta =
      const VerificationMeta('currentPhoneNumber');
  @override
  late final GeneratedColumn<String> currentPhoneNumber =
      GeneratedColumn<String>('current_phone_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherFirstNameMeta =
      const VerificationMeta('fatherFirstName');
  @override
  late final GeneratedColumn<String> fatherFirstName = GeneratedColumn<String>(
      'father_first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherLastNameMeta =
      const VerificationMeta('fatherLastName');
  @override
  late final GeneratedColumn<String> fatherLastName = GeneratedColumn<String>(
      'father_last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherDateOfBirthMeta =
      const VerificationMeta('fatherDateOfBirth');
  @override
  late final GeneratedColumn<DateTime> fatherDateOfBirth =
      GeneratedColumn<DateTime>('father_date_of_birth', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fatherDateOfDeathMeta =
      const VerificationMeta('fatherDateOfDeath');
  @override
  late final GeneratedColumn<DateTime> fatherDateOfDeath =
      GeneratedColumn<DateTime>('father_date_of_death', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fatherCauseOfDeathMeta =
      const VerificationMeta('fatherCauseOfDeath');
  @override
  late final GeneratedColumn<String> fatherCauseOfDeath =
      GeneratedColumn<String>('father_cause_of_death', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherAliveMeta =
      const VerificationMeta('fatherAlive');
  @override
  late final GeneratedColumn<bool> fatherAlive = GeneratedColumn<bool>(
      'father_alive', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("father_alive" IN (0, 1))'));
  static const VerificationMeta _fatherEducationLevelMeta =
      const VerificationMeta('fatherEducationLevel');
  @override
  late final GeneratedColumn<String> fatherEducationLevel =
      GeneratedColumn<String>('father_education_level', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherWorkMeta =
      const VerificationMeta('fatherWork');
  @override
  late final GeneratedColumn<String> fatherWork = GeneratedColumn<String>(
      'father_work', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherMonthlyIncomeMeta =
      const VerificationMeta('fatherMonthlyIncome');
  @override
  late final GeneratedColumn<String> fatherMonthlyIncome =
      GeneratedColumn<String>('father_monthly_income', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherNumberOfWivesMeta =
      const VerificationMeta('fatherNumberOfWives');
  @override
  late final GeneratedColumn<int> fatherNumberOfWives = GeneratedColumn<int>(
      'father_number_of_wives', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fatherNumberOfChildrenMeta =
      const VerificationMeta('fatherNumberOfChildren');
  @override
  late final GeneratedColumn<int> fatherNumberOfChildren = GeneratedColumn<int>(
      'father_number_of_children', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _motherFirstNameMeta =
      const VerificationMeta('motherFirstName');
  @override
  late final GeneratedColumn<String> motherFirstName = GeneratedColumn<String>(
      'mother_first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherLastNameMeta =
      const VerificationMeta('motherLastName');
  @override
  late final GeneratedColumn<String> motherLastName = GeneratedColumn<String>(
      'mother_last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherDateOfBirthMeta =
      const VerificationMeta('motherDateOfBirth');
  @override
  late final GeneratedColumn<DateTime> motherDateOfBirth =
      GeneratedColumn<DateTime>('mother_date_of_birth', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _motherDateOfDeathMeta =
      const VerificationMeta('motherDateOfDeath');
  @override
  late final GeneratedColumn<DateTime> motherDateOfDeath =
      GeneratedColumn<DateTime>('mother_date_of_death', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _motherCauseOfDeathMeta =
      const VerificationMeta('motherCauseOfDeath');
  @override
  late final GeneratedColumn<String> motherCauseOfDeath =
      GeneratedColumn<String>('mother_cause_of_death', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherAliveMeta =
      const VerificationMeta('motherAlive');
  @override
  late final GeneratedColumn<bool> motherAlive = GeneratedColumn<bool>(
      'mother_alive', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("mother_alive" IN (0, 1))'));
  static const VerificationMeta _motherEducationLevelMeta =
      const VerificationMeta('motherEducationLevel');
  @override
  late final GeneratedColumn<String> motherEducationLevel =
      GeneratedColumn<String>('mother_education_level', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherWorkMeta =
      const VerificationMeta('motherWork');
  @override
  late final GeneratedColumn<String> motherWork = GeneratedColumn<String>(
      'mother_work', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherMonthlyIncomeMeta =
      const VerificationMeta('motherMonthlyIncome');
  @override
  late final GeneratedColumn<String> motherMonthlyIncome =
      GeneratedColumn<String>('mother_monthly_income', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherRemarriedMeta =
      const VerificationMeta('motherRemarried');
  @override
  late final GeneratedColumn<bool> motherRemarried = GeneratedColumn<bool>(
      'mother_remarried', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("mother_remarried" IN (0, 1))'));
  static const VerificationMeta _motherNeedsSupportMeta =
      const VerificationMeta('motherNeedsSupport');
  @override
  late final GeneratedColumn<bool> motherNeedsSupport = GeneratedColumn<bool>(
      'mother_needs_support', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("mother_needs_support" IN (0, 1))'));
  static const VerificationMeta _guardianNameMeta =
      const VerificationMeta('guardianName');
  @override
  late final GeneratedColumn<String> guardianName = GeneratedColumn<String>(
      'guardian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianRelationshipMeta =
      const VerificationMeta('guardianRelationship');
  @override
  late final GeneratedColumn<String> guardianRelationship =
      GeneratedColumn<String>('guardian_relationship', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianEducationLevelMeta =
      const VerificationMeta('guardianEducationLevel');
  @override
  late final GeneratedColumn<String> guardianEducationLevel =
      GeneratedColumn<String>('guardian_education_level', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianWorkMeta =
      const VerificationMeta('guardianWork');
  @override
  late final GeneratedColumn<String> guardianWork = GeneratedColumn<String>(
      'guardian_work', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianNumberOfDependentsMeta =
      const VerificationMeta('guardianNumberOfDependents');
  @override
  late final GeneratedColumn<int> guardianNumberOfDependents =
      GeneratedColumn<int>('guardian_number_of_dependents', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _guardianMonthlyIncomeMeta =
      const VerificationMeta('guardianMonthlyIncome');
  @override
  late final GeneratedColumn<String> guardianMonthlyIncome =
      GeneratedColumn<String>('guardian_monthly_income', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<EducationLevel?, int>
      educationLevel = GeneratedColumn<int>(
              'education_level', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<EducationLevel?>(
              $OrphansTable.$convertereducationLeveln);
  static const VerificationMeta _schoolNameMeta =
      const VerificationMeta('schoolName');
  @override
  late final GeneratedColumn<String> schoolName = GeneratedColumn<String>(
      'school_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _educationAddressMeta =
      const VerificationMeta('educationAddress');
  @override
  late final GeneratedColumn<String> educationAddress = GeneratedColumn<String>(
      'education_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _educationCostsMeta =
      const VerificationMeta('educationCosts');
  @override
  late final GeneratedColumn<String> educationCosts = GeneratedColumn<String>(
      'education_costs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _studyYearMeta =
      const VerificationMeta('studyYear');
  @override
  late final GeneratedColumn<String> studyYear = GeneratedColumn<String>(
      'study_year', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
      'grade', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _educationStageMeta =
      const VerificationMeta('educationStage');
  @override
  late final GeneratedColumn<String> educationStage = GeneratedColumn<String>(
      'education_stage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _studyTypeMeta =
      const VerificationMeta('studyType');
  @override
  late final GeneratedColumn<String> studyType = GeneratedColumn<String>(
      'study_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _educationAchievementMeta =
      const VerificationMeta('educationAchievement');
  @override
  late final GeneratedColumn<String> educationAchievement =
      GeneratedColumn<String>('education_achievement', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastStudyResultMeta =
      const VerificationMeta('lastStudyResult');
  @override
  late final GeneratedColumn<String> lastStudyResult = GeneratedColumn<String>(
      'last_study_result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weakSubjectsMeta =
      const VerificationMeta('weakSubjects');
  @override
  late final GeneratedColumn<String> weakSubjects = GeneratedColumn<String>(
      'weak_subjects', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _strongSubjectsMeta =
      const VerificationMeta('strongSubjects');
  @override
  late final GeneratedColumn<String> strongSubjects = GeneratedColumn<String>(
      'strong_subjects', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _studyImprovementActionsMeta =
      const VerificationMeta('studyImprovementActions');
  @override
  late final GeneratedColumn<String> studyImprovementActions =
      GeneratedColumn<String>('study_improvement_actions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonForNotStudyingMeta =
      const VerificationMeta('reasonForNotStudying');
  @override
  late final GeneratedColumn<String> reasonForNotStudying =
      GeneratedColumn<String>('reason_for_not_studying', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stoppedStudyingMeta =
      const VerificationMeta('stoppedStudying');
  @override
  late final GeneratedColumn<bool> stoppedStudying = GeneratedColumn<bool>(
      'stopped_studying', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("stopped_studying" IN (0, 1))'));
  static const VerificationMeta _reasonForStoppingStufyMeta =
      const VerificationMeta('reasonForStoppingStufy');
  @override
  late final GeneratedColumn<String> reasonForStoppingStufy =
      GeneratedColumn<String>('reason_for_stopping_stufy', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<HealthStatus?, int> healthStatus =
      GeneratedColumn<int>('health_status', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<HealthStatus?>($OrphansTable.$converterhealthStatusn);
  @override
  late final GeneratedColumnWithTypeConverter<PsychologicalStatus?, int>
      psychologicalStatus = GeneratedColumn<int>(
              'psychological_status', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<PsychologicalStatus?>(
              $OrphansTable.$converterpsychologicalStatusn);
  @override
  late final GeneratedColumnWithTypeConverter<PsychologicalStatus?, int>
      behavioralStatus = GeneratedColumn<int>(
              'behavioral_status', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<PsychologicalStatus?>(
              $OrphansTable.$converterbehavioralStatusn);
  static const VerificationMeta _nutritionalStatusMeta =
      const VerificationMeta('nutritionalStatus');
  @override
  late final GeneratedColumn<String> nutritionalStatus =
      GeneratedColumn<String>('nutritional_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _disabilityTypeMeta =
      const VerificationMeta('disabilityType');
  @override
  late final GeneratedColumn<String> disabilityType = GeneratedColumn<String>(
      'disability_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<DisabilityType?, int>
      disabilityLevel = GeneratedColumn<int>(
              'disability_level', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DisabilityType?>(
              $OrphansTable.$converterdisabilityLeveln);
  static const VerificationMeta _medicalConditionsMeta =
      const VerificationMeta('medicalConditions');
  @override
  late final GeneratedColumn<String> medicalConditions =
      GeneratedColumn<String>('medical_conditions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicationsMeta =
      const VerificationMeta('medications');
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
      'medications', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _needsMedicalSupportMeta =
      const VerificationMeta('needsMedicalSupport');
  @override
  late final GeneratedColumn<bool> needsMedicalSupport = GeneratedColumn<bool>(
      'needs_medical_support', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("needs_medical_support" IN (0, 1))'));
  @override
  late final GeneratedColumnWithTypeConverter<AccommodationType?, int>
      accommodationType = GeneratedColumn<int>(
              'accommodation_type', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<AccommodationType?>(
              $OrphansTable.$converteraccommodationTypen);
  static const VerificationMeta _accommodationAddressMeta =
      const VerificationMeta('accommodationAddress');
  @override
  late final GeneratedColumn<String> accommodationAddress =
      GeneratedColumn<String>('accommodation_address', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accommodationConditionMeta =
      const VerificationMeta('accommodationCondition');
  @override
  late final GeneratedColumn<String> accommodationCondition =
      GeneratedColumn<String>('accommodation_condition', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accommodationOwnershipMeta =
      const VerificationMeta('accommodationOwnership');
  @override
  late final GeneratedColumn<String> accommodationOwnership =
      GeneratedColumn<String>('accommodation_ownership', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _needsHousingSupportMeta =
      const VerificationMeta('needsHousingSupport');
  @override
  late final GeneratedColumn<bool> needsHousingSupport = GeneratedColumn<bool>(
      'needs_housing_support', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("needs_housing_support" IN (0, 1))'));
  static const VerificationMeta _quranMemorizationMeta =
      const VerificationMeta('quranMemorization');
  @override
  late final GeneratedColumn<String> quranMemorization =
      GeneratedColumn<String>('quran_memorization', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attendsIslamicSchoolMeta =
      const VerificationMeta('attendsIslamicSchool');
  @override
  late final GeneratedColumn<bool> attendsIslamicSchool = GeneratedColumn<bool>(
      'attends_islamic_school', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("attends_islamic_school" IN (0, 1))'));
  static const VerificationMeta _islamicEducationLevelMeta =
      const VerificationMeta('islamicEducationLevel');
  @override
  late final GeneratedColumn<String> islamicEducationLevel =
      GeneratedColumn<String>('islamic_education_level', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hobbiesMeta =
      const VerificationMeta('hobbies');
  @override
  late final GeneratedColumn<String> hobbies = GeneratedColumn<String>(
      'hobbies', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skillsMeta = const VerificationMeta('skills');
  @override
  late final GeneratedColumn<String> skills = GeneratedColumn<String>(
      'skills', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aspirationsMeta =
      const VerificationMeta('aspirations');
  @override
  late final GeneratedColumn<String> aspirations = GeneratedColumn<String>(
      'aspirations', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numberOfSiblingsMeta =
      const VerificationMeta('numberOfSiblings');
  @override
  late final GeneratedColumn<int> numberOfSiblings = GeneratedColumn<int>(
      'number_of_siblings', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _siblingsDetailsMeta =
      const VerificationMeta('siblingsDetails');
  @override
  late final GeneratedColumn<String> siblingsDetails = GeneratedColumn<String>(
      'siblings_details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _additionalNotesMeta =
      const VerificationMeta('additionalNotes');
  @override
  late final GeneratedColumn<String> additionalNotes = GeneratedColumn<String>(
      'additional_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urgentNeedsMeta =
      const VerificationMeta('urgentNeeds');
  @override
  late final GeneratedColumn<String> urgentNeeds = GeneratedColumn<String>(
      'urgent_needs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _specialCircumstancesMeta =
      const VerificationMeta('specialCircumstances');
  @override
  late final GeneratedColumn<String> specialCircumstances =
      GeneratedColumn<String>('special_circumstances', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentsPathMeta =
      const VerificationMeta('documentsPath');
  @override
  late final GeneratedColumn<String> documentsPath = GeneratedColumn<String>(
      'documents_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        orphanId,
        firstName,
        lastName,
        familyName,
        gender,
        dateOfBirth,
        placeOfBirth,
        nationality,
        idNumber,
        status,
        lastSeenLocation,
        lastUpdated,
        supervisorId,
        currentCountry,
        currentGovernorate,
        currentCity,
        currentNeighborhood,
        currentCamp,
        currentStreet,
        currentPhoneNumber,
        fatherFirstName,
        fatherLastName,
        fatherDateOfBirth,
        fatherDateOfDeath,
        fatherCauseOfDeath,
        fatherAlive,
        fatherEducationLevel,
        fatherWork,
        fatherMonthlyIncome,
        fatherNumberOfWives,
        fatherNumberOfChildren,
        motherFirstName,
        motherLastName,
        motherDateOfBirth,
        motherDateOfDeath,
        motherCauseOfDeath,
        motherAlive,
        motherEducationLevel,
        motherWork,
        motherMonthlyIncome,
        motherRemarried,
        motherNeedsSupport,
        guardianName,
        guardianRelationship,
        guardianEducationLevel,
        guardianWork,
        guardianNumberOfDependents,
        guardianMonthlyIncome,
        educationLevel,
        schoolName,
        educationAddress,
        educationCosts,
        studyYear,
        grade,
        educationStage,
        studyType,
        educationAchievement,
        lastStudyResult,
        weakSubjects,
        strongSubjects,
        studyImprovementActions,
        reasonForNotStudying,
        stoppedStudying,
        reasonForStoppingStufy,
        healthStatus,
        psychologicalStatus,
        behavioralStatus,
        nutritionalStatus,
        disabilityType,
        disabilityLevel,
        medicalConditions,
        medications,
        needsMedicalSupport,
        accommodationType,
        accommodationAddress,
        accommodationCondition,
        accommodationOwnership,
        needsHousingSupport,
        quranMemorization,
        attendsIslamicSchool,
        islamicEducationLevel,
        hobbies,
        skills,
        aspirations,
        numberOfSiblings,
        siblingsDetails,
        additionalNotes,
        urgentNeeds,
        specialCircumstances,
        photoPath,
        documentsPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orphans';
  @override
  VerificationContext validateIntegrity(Insertable<Orphan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('orphan_id')) {
      context.handle(_orphanIdMeta,
          orphanId.isAcceptableOrUnknown(data['orphan_id']!, _orphanIdMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('family_name')) {
      context.handle(
          _familyNameMeta,
          familyName.isAcceptableOrUnknown(
              data['family_name']!, _familyNameMeta));
    } else if (isInserting) {
      context.missing(_familyNameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
          _placeOfBirthMeta,
          placeOfBirth.isAcceptableOrUnknown(
              data['place_of_birth']!, _placeOfBirthMeta));
    }
    if (data.containsKey('nationality')) {
      context.handle(
          _nationalityMeta,
          nationality.isAcceptableOrUnknown(
              data['nationality']!, _nationalityMeta));
    }
    if (data.containsKey('id_number')) {
      context.handle(_idNumberMeta,
          idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta));
    }
    if (data.containsKey('last_seen_location')) {
      context.handle(
          _lastSeenLocationMeta,
          lastSeenLocation.isAcceptableOrUnknown(
              data['last_seen_location']!, _lastSeenLocationMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    } else if (isInserting) {
      context.missing(_supervisorIdMeta);
    }
    if (data.containsKey('current_country')) {
      context.handle(
          _currentCountryMeta,
          currentCountry.isAcceptableOrUnknown(
              data['current_country']!, _currentCountryMeta));
    }
    if (data.containsKey('current_governorate')) {
      context.handle(
          _currentGovernorateMeta,
          currentGovernorate.isAcceptableOrUnknown(
              data['current_governorate']!, _currentGovernorateMeta));
    }
    if (data.containsKey('current_city')) {
      context.handle(
          _currentCityMeta,
          currentCity.isAcceptableOrUnknown(
              data['current_city']!, _currentCityMeta));
    }
    if (data.containsKey('current_neighborhood')) {
      context.handle(
          _currentNeighborhoodMeta,
          currentNeighborhood.isAcceptableOrUnknown(
              data['current_neighborhood']!, _currentNeighborhoodMeta));
    }
    if (data.containsKey('current_camp')) {
      context.handle(
          _currentCampMeta,
          currentCamp.isAcceptableOrUnknown(
              data['current_camp']!, _currentCampMeta));
    }
    if (data.containsKey('current_street')) {
      context.handle(
          _currentStreetMeta,
          currentStreet.isAcceptableOrUnknown(
              data['current_street']!, _currentStreetMeta));
    }
    if (data.containsKey('current_phone_number')) {
      context.handle(
          _currentPhoneNumberMeta,
          currentPhoneNumber.isAcceptableOrUnknown(
              data['current_phone_number']!, _currentPhoneNumberMeta));
    }
    if (data.containsKey('father_first_name')) {
      context.handle(
          _fatherFirstNameMeta,
          fatherFirstName.isAcceptableOrUnknown(
              data['father_first_name']!, _fatherFirstNameMeta));
    }
    if (data.containsKey('father_last_name')) {
      context.handle(
          _fatherLastNameMeta,
          fatherLastName.isAcceptableOrUnknown(
              data['father_last_name']!, _fatherLastNameMeta));
    }
    if (data.containsKey('father_date_of_birth')) {
      context.handle(
          _fatherDateOfBirthMeta,
          fatherDateOfBirth.isAcceptableOrUnknown(
              data['father_date_of_birth']!, _fatherDateOfBirthMeta));
    }
    if (data.containsKey('father_date_of_death')) {
      context.handle(
          _fatherDateOfDeathMeta,
          fatherDateOfDeath.isAcceptableOrUnknown(
              data['father_date_of_death']!, _fatherDateOfDeathMeta));
    }
    if (data.containsKey('father_cause_of_death')) {
      context.handle(
          _fatherCauseOfDeathMeta,
          fatherCauseOfDeath.isAcceptableOrUnknown(
              data['father_cause_of_death']!, _fatherCauseOfDeathMeta));
    }
    if (data.containsKey('father_alive')) {
      context.handle(
          _fatherAliveMeta,
          fatherAlive.isAcceptableOrUnknown(
              data['father_alive']!, _fatherAliveMeta));
    }
    if (data.containsKey('father_education_level')) {
      context.handle(
          _fatherEducationLevelMeta,
          fatherEducationLevel.isAcceptableOrUnknown(
              data['father_education_level']!, _fatherEducationLevelMeta));
    }
    if (data.containsKey('father_work')) {
      context.handle(
          _fatherWorkMeta,
          fatherWork.isAcceptableOrUnknown(
              data['father_work']!, _fatherWorkMeta));
    }
    if (data.containsKey('father_monthly_income')) {
      context.handle(
          _fatherMonthlyIncomeMeta,
          fatherMonthlyIncome.isAcceptableOrUnknown(
              data['father_monthly_income']!, _fatherMonthlyIncomeMeta));
    }
    if (data.containsKey('father_number_of_wives')) {
      context.handle(
          _fatherNumberOfWivesMeta,
          fatherNumberOfWives.isAcceptableOrUnknown(
              data['father_number_of_wives']!, _fatherNumberOfWivesMeta));
    }
    if (data.containsKey('father_number_of_children')) {
      context.handle(
          _fatherNumberOfChildrenMeta,
          fatherNumberOfChildren.isAcceptableOrUnknown(
              data['father_number_of_children']!, _fatherNumberOfChildrenMeta));
    }
    if (data.containsKey('mother_first_name')) {
      context.handle(
          _motherFirstNameMeta,
          motherFirstName.isAcceptableOrUnknown(
              data['mother_first_name']!, _motherFirstNameMeta));
    }
    if (data.containsKey('mother_last_name')) {
      context.handle(
          _motherLastNameMeta,
          motherLastName.isAcceptableOrUnknown(
              data['mother_last_name']!, _motherLastNameMeta));
    }
    if (data.containsKey('mother_date_of_birth')) {
      context.handle(
          _motherDateOfBirthMeta,
          motherDateOfBirth.isAcceptableOrUnknown(
              data['mother_date_of_birth']!, _motherDateOfBirthMeta));
    }
    if (data.containsKey('mother_date_of_death')) {
      context.handle(
          _motherDateOfDeathMeta,
          motherDateOfDeath.isAcceptableOrUnknown(
              data['mother_date_of_death']!, _motherDateOfDeathMeta));
    }
    if (data.containsKey('mother_cause_of_death')) {
      context.handle(
          _motherCauseOfDeathMeta,
          motherCauseOfDeath.isAcceptableOrUnknown(
              data['mother_cause_of_death']!, _motherCauseOfDeathMeta));
    }
    if (data.containsKey('mother_alive')) {
      context.handle(
          _motherAliveMeta,
          motherAlive.isAcceptableOrUnknown(
              data['mother_alive']!, _motherAliveMeta));
    }
    if (data.containsKey('mother_education_level')) {
      context.handle(
          _motherEducationLevelMeta,
          motherEducationLevel.isAcceptableOrUnknown(
              data['mother_education_level']!, _motherEducationLevelMeta));
    }
    if (data.containsKey('mother_work')) {
      context.handle(
          _motherWorkMeta,
          motherWork.isAcceptableOrUnknown(
              data['mother_work']!, _motherWorkMeta));
    }
    if (data.containsKey('mother_monthly_income')) {
      context.handle(
          _motherMonthlyIncomeMeta,
          motherMonthlyIncome.isAcceptableOrUnknown(
              data['mother_monthly_income']!, _motherMonthlyIncomeMeta));
    }
    if (data.containsKey('mother_remarried')) {
      context.handle(
          _motherRemarriedMeta,
          motherRemarried.isAcceptableOrUnknown(
              data['mother_remarried']!, _motherRemarriedMeta));
    }
    if (data.containsKey('mother_needs_support')) {
      context.handle(
          _motherNeedsSupportMeta,
          motherNeedsSupport.isAcceptableOrUnknown(
              data['mother_needs_support']!, _motherNeedsSupportMeta));
    }
    if (data.containsKey('guardian_name')) {
      context.handle(
          _guardianNameMeta,
          guardianName.isAcceptableOrUnknown(
              data['guardian_name']!, _guardianNameMeta));
    }
    if (data.containsKey('guardian_relationship')) {
      context.handle(
          _guardianRelationshipMeta,
          guardianRelationship.isAcceptableOrUnknown(
              data['guardian_relationship']!, _guardianRelationshipMeta));
    }
    if (data.containsKey('guardian_education_level')) {
      context.handle(
          _guardianEducationLevelMeta,
          guardianEducationLevel.isAcceptableOrUnknown(
              data['guardian_education_level']!, _guardianEducationLevelMeta));
    }
    if (data.containsKey('guardian_work')) {
      context.handle(
          _guardianWorkMeta,
          guardianWork.isAcceptableOrUnknown(
              data['guardian_work']!, _guardianWorkMeta));
    }
    if (data.containsKey('guardian_number_of_dependents')) {
      context.handle(
          _guardianNumberOfDependentsMeta,
          guardianNumberOfDependents.isAcceptableOrUnknown(
              data['guardian_number_of_dependents']!,
              _guardianNumberOfDependentsMeta));
    }
    if (data.containsKey('guardian_monthly_income')) {
      context.handle(
          _guardianMonthlyIncomeMeta,
          guardianMonthlyIncome.isAcceptableOrUnknown(
              data['guardian_monthly_income']!, _guardianMonthlyIncomeMeta));
    }
    if (data.containsKey('school_name')) {
      context.handle(
          _schoolNameMeta,
          schoolName.isAcceptableOrUnknown(
              data['school_name']!, _schoolNameMeta));
    }
    if (data.containsKey('education_address')) {
      context.handle(
          _educationAddressMeta,
          educationAddress.isAcceptableOrUnknown(
              data['education_address']!, _educationAddressMeta));
    }
    if (data.containsKey('education_costs')) {
      context.handle(
          _educationCostsMeta,
          educationCosts.isAcceptableOrUnknown(
              data['education_costs']!, _educationCostsMeta));
    }
    if (data.containsKey('study_year')) {
      context.handle(_studyYearMeta,
          studyYear.isAcceptableOrUnknown(data['study_year']!, _studyYearMeta));
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    }
    if (data.containsKey('education_stage')) {
      context.handle(
          _educationStageMeta,
          educationStage.isAcceptableOrUnknown(
              data['education_stage']!, _educationStageMeta));
    }
    if (data.containsKey('study_type')) {
      context.handle(_studyTypeMeta,
          studyType.isAcceptableOrUnknown(data['study_type']!, _studyTypeMeta));
    }
    if (data.containsKey('education_achievement')) {
      context.handle(
          _educationAchievementMeta,
          educationAchievement.isAcceptableOrUnknown(
              data['education_achievement']!, _educationAchievementMeta));
    }
    if (data.containsKey('last_study_result')) {
      context.handle(
          _lastStudyResultMeta,
          lastStudyResult.isAcceptableOrUnknown(
              data['last_study_result']!, _lastStudyResultMeta));
    }
    if (data.containsKey('weak_subjects')) {
      context.handle(
          _weakSubjectsMeta,
          weakSubjects.isAcceptableOrUnknown(
              data['weak_subjects']!, _weakSubjectsMeta));
    }
    if (data.containsKey('strong_subjects')) {
      context.handle(
          _strongSubjectsMeta,
          strongSubjects.isAcceptableOrUnknown(
              data['strong_subjects']!, _strongSubjectsMeta));
    }
    if (data.containsKey('study_improvement_actions')) {
      context.handle(
          _studyImprovementActionsMeta,
          studyImprovementActions.isAcceptableOrUnknown(
              data['study_improvement_actions']!,
              _studyImprovementActionsMeta));
    }
    if (data.containsKey('reason_for_not_studying')) {
      context.handle(
          _reasonForNotStudyingMeta,
          reasonForNotStudying.isAcceptableOrUnknown(
              data['reason_for_not_studying']!, _reasonForNotStudyingMeta));
    }
    if (data.containsKey('stopped_studying')) {
      context.handle(
          _stoppedStudyingMeta,
          stoppedStudying.isAcceptableOrUnknown(
              data['stopped_studying']!, _stoppedStudyingMeta));
    }
    if (data.containsKey('reason_for_stopping_stufy')) {
      context.handle(
          _reasonForStoppingStufyMeta,
          reasonForStoppingStufy.isAcceptableOrUnknown(
              data['reason_for_stopping_stufy']!, _reasonForStoppingStufyMeta));
    }
    if (data.containsKey('nutritional_status')) {
      context.handle(
          _nutritionalStatusMeta,
          nutritionalStatus.isAcceptableOrUnknown(
              data['nutritional_status']!, _nutritionalStatusMeta));
    }
    if (data.containsKey('disability_type')) {
      context.handle(
          _disabilityTypeMeta,
          disabilityType.isAcceptableOrUnknown(
              data['disability_type']!, _disabilityTypeMeta));
    }
    if (data.containsKey('medical_conditions')) {
      context.handle(
          _medicalConditionsMeta,
          medicalConditions.isAcceptableOrUnknown(
              data['medical_conditions']!, _medicalConditionsMeta));
    }
    if (data.containsKey('medications')) {
      context.handle(
          _medicationsMeta,
          medications.isAcceptableOrUnknown(
              data['medications']!, _medicationsMeta));
    }
    if (data.containsKey('needs_medical_support')) {
      context.handle(
          _needsMedicalSupportMeta,
          needsMedicalSupport.isAcceptableOrUnknown(
              data['needs_medical_support']!, _needsMedicalSupportMeta));
    }
    if (data.containsKey('accommodation_address')) {
      context.handle(
          _accommodationAddressMeta,
          accommodationAddress.isAcceptableOrUnknown(
              data['accommodation_address']!, _accommodationAddressMeta));
    }
    if (data.containsKey('accommodation_condition')) {
      context.handle(
          _accommodationConditionMeta,
          accommodationCondition.isAcceptableOrUnknown(
              data['accommodation_condition']!, _accommodationConditionMeta));
    }
    if (data.containsKey('accommodation_ownership')) {
      context.handle(
          _accommodationOwnershipMeta,
          accommodationOwnership.isAcceptableOrUnknown(
              data['accommodation_ownership']!, _accommodationOwnershipMeta));
    }
    if (data.containsKey('needs_housing_support')) {
      context.handle(
          _needsHousingSupportMeta,
          needsHousingSupport.isAcceptableOrUnknown(
              data['needs_housing_support']!, _needsHousingSupportMeta));
    }
    if (data.containsKey('quran_memorization')) {
      context.handle(
          _quranMemorizationMeta,
          quranMemorization.isAcceptableOrUnknown(
              data['quran_memorization']!, _quranMemorizationMeta));
    }
    if (data.containsKey('attends_islamic_school')) {
      context.handle(
          _attendsIslamicSchoolMeta,
          attendsIslamicSchool.isAcceptableOrUnknown(
              data['attends_islamic_school']!, _attendsIslamicSchoolMeta));
    }
    if (data.containsKey('islamic_education_level')) {
      context.handle(
          _islamicEducationLevelMeta,
          islamicEducationLevel.isAcceptableOrUnknown(
              data['islamic_education_level']!, _islamicEducationLevelMeta));
    }
    if (data.containsKey('hobbies')) {
      context.handle(_hobbiesMeta,
          hobbies.isAcceptableOrUnknown(data['hobbies']!, _hobbiesMeta));
    }
    if (data.containsKey('skills')) {
      context.handle(_skillsMeta,
          skills.isAcceptableOrUnknown(data['skills']!, _skillsMeta));
    }
    if (data.containsKey('aspirations')) {
      context.handle(
          _aspirationsMeta,
          aspirations.isAcceptableOrUnknown(
              data['aspirations']!, _aspirationsMeta));
    }
    if (data.containsKey('number_of_siblings')) {
      context.handle(
          _numberOfSiblingsMeta,
          numberOfSiblings.isAcceptableOrUnknown(
              data['number_of_siblings']!, _numberOfSiblingsMeta));
    }
    if (data.containsKey('siblings_details')) {
      context.handle(
          _siblingsDetailsMeta,
          siblingsDetails.isAcceptableOrUnknown(
              data['siblings_details']!, _siblingsDetailsMeta));
    }
    if (data.containsKey('additional_notes')) {
      context.handle(
          _additionalNotesMeta,
          additionalNotes.isAcceptableOrUnknown(
              data['additional_notes']!, _additionalNotesMeta));
    }
    if (data.containsKey('urgent_needs')) {
      context.handle(
          _urgentNeedsMeta,
          urgentNeeds.isAcceptableOrUnknown(
              data['urgent_needs']!, _urgentNeedsMeta));
    }
    if (data.containsKey('special_circumstances')) {
      context.handle(
          _specialCircumstancesMeta,
          specialCircumstances.isAcceptableOrUnknown(
              data['special_circumstances']!, _specialCircumstancesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('documents_path')) {
      context.handle(
          _documentsPathMeta,
          documentsPath.isAcceptableOrUnknown(
              data['documents_path']!, _documentsPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orphanId};
  @override
  Orphan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Orphan(
      orphanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}orphan_id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      familyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_name'])!,
      gender: $OrphansTable.$convertergender.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!),
      dateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth'])!,
      placeOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_of_birth']),
      nationality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nationality']),
      idNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_number']),
      status: $OrphansTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      lastSeenLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_seen_location']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id'])!,
      currentCountry: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_country']),
      currentGovernorate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_governorate']),
      currentCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_city']),
      currentNeighborhood: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_neighborhood']),
      currentCamp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_camp']),
      currentStreet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_street']),
      currentPhoneNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_phone_number']),
      fatherFirstName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_first_name']),
      fatherLastName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_last_name']),
      fatherDateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}father_date_of_birth']),
      fatherDateOfDeath: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}father_date_of_death']),
      fatherCauseOfDeath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_cause_of_death']),
      fatherAlive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}father_alive']),
      fatherEducationLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}father_education_level']),
      fatherWork: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_work']),
      fatherMonthlyIncome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_monthly_income']),
      fatherNumberOfWives: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}father_number_of_wives']),
      fatherNumberOfChildren: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}father_number_of_children']),
      motherFirstName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mother_first_name']),
      motherLastName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mother_last_name']),
      motherDateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}mother_date_of_birth']),
      motherDateOfDeath: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}mother_date_of_death']),
      motherCauseOfDeath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mother_cause_of_death']),
      motherAlive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}mother_alive']),
      motherEducationLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mother_education_level']),
      motherWork: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_work']),
      motherMonthlyIncome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mother_monthly_income']),
      motherRemarried: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}mother_remarried']),
      motherNeedsSupport: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}mother_needs_support']),
      guardianName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_name']),
      guardianRelationship: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guardian_relationship']),
      guardianEducationLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}guardian_education_level']),
      guardianWork: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_work']),
      guardianNumberOfDependents: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}guardian_number_of_dependents']),
      guardianMonthlyIncome: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}guardian_monthly_income']),
      educationLevel: $OrphansTable.$convertereducationLeveln.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}education_level'])),
      schoolName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school_name']),
      educationAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}education_address']),
      educationCosts: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}education_costs']),
      studyYear: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}study_year']),
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade']),
      educationStage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}education_stage']),
      studyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}study_type']),
      educationAchievement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}education_achievement']),
      lastStudyResult: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_study_result']),
      weakSubjects: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weak_subjects']),
      strongSubjects: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strong_subjects']),
      studyImprovementActions: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}study_improvement_actions']),
      reasonForNotStudying: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason_for_not_studying']),
      stoppedStudying: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}stopped_studying']),
      reasonForStoppingStufy: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason_for_stopping_stufy']),
      healthStatus: $OrphansTable.$converterhealthStatusn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}health_status'])),
      psychologicalStatus: $OrphansTable.$converterpsychologicalStatusn.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.int,
              data['${effectivePrefix}psychological_status'])),
      behavioralStatus: $OrphansTable.$converterbehavioralStatusn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}behavioral_status'])),
      nutritionalStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nutritional_status']),
      disabilityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}disability_type']),
      disabilityLevel: $OrphansTable.$converterdisabilityLeveln.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}disability_level'])),
      medicalConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}medical_conditions']),
      medications: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medications']),
      needsMedicalSupport: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}needs_medical_support']),
      accommodationType: $OrphansTable.$converteraccommodationTypen.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}accommodation_type'])),
      accommodationAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}accommodation_address']),
      accommodationCondition: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}accommodation_condition']),
      accommodationOwnership: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}accommodation_ownership']),
      needsHousingSupport: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}needs_housing_support']),
      quranMemorization: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}quran_memorization']),
      attendsIslamicSchool: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}attends_islamic_school']),
      islamicEducationLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}islamic_education_level']),
      hobbies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hobbies']),
      skills: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skills']),
      aspirations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aspirations']),
      numberOfSiblings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_of_siblings']),
      siblingsDetails: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}siblings_details']),
      additionalNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}additional_notes']),
      urgentNeeds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}urgent_needs']),
      specialCircumstances: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}special_circumstances']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      documentsPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}documents_path']),
    );
  }

  @override
  $OrphansTable createAlias(String alias) {
    return $OrphansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Gender, int, int> $convertergender =
      const EnumIndexConverter<Gender>(Gender.values);
  static JsonTypeConverter2<OrphanStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrphanStatus>(OrphanStatus.values);
  static JsonTypeConverter2<EducationLevel, int, int> $convertereducationLevel =
      const EnumIndexConverter<EducationLevel>(EducationLevel.values);
  static JsonTypeConverter2<EducationLevel?, int?, int?>
      $convertereducationLeveln =
      JsonTypeConverter2.asNullable($convertereducationLevel);
  static JsonTypeConverter2<HealthStatus, int, int> $converterhealthStatus =
      const EnumIndexConverter<HealthStatus>(HealthStatus.values);
  static JsonTypeConverter2<HealthStatus?, int?, int?> $converterhealthStatusn =
      JsonTypeConverter2.asNullable($converterhealthStatus);
  static JsonTypeConverter2<PsychologicalStatus, int, int>
      $converterpsychologicalStatus =
      const EnumIndexConverter<PsychologicalStatus>(PsychologicalStatus.values);
  static JsonTypeConverter2<PsychologicalStatus?, int?, int?>
      $converterpsychologicalStatusn =
      JsonTypeConverter2.asNullable($converterpsychologicalStatus);
  static JsonTypeConverter2<PsychologicalStatus, int, int>
      $converterbehavioralStatus =
      const EnumIndexConverter<PsychologicalStatus>(PsychologicalStatus.values);
  static JsonTypeConverter2<PsychologicalStatus?, int?, int?>
      $converterbehavioralStatusn =
      JsonTypeConverter2.asNullable($converterbehavioralStatus);
  static JsonTypeConverter2<DisabilityType, int, int>
      $converterdisabilityLevel =
      const EnumIndexConverter<DisabilityType>(DisabilityType.values);
  static JsonTypeConverter2<DisabilityType?, int?, int?>
      $converterdisabilityLeveln =
      JsonTypeConverter2.asNullable($converterdisabilityLevel);
  static JsonTypeConverter2<AccommodationType, int, int>
      $converteraccommodationType =
      const EnumIndexConverter<AccommodationType>(AccommodationType.values);
  static JsonTypeConverter2<AccommodationType?, int?, int?>
      $converteraccommodationTypen =
      JsonTypeConverter2.asNullable($converteraccommodationType);
}

class Orphan extends DataClass implements Insertable<Orphan> {
  final String orphanId;
  final String firstName;
  final String lastName;
  final String familyName;
  final Gender gender;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String? nationality;
  final String? idNumber;
  final OrphanStatus status;
  final String? lastSeenLocation;
  final DateTime lastUpdated;
  final String supervisorId;
  final String? currentCountry;
  final String? currentGovernorate;
  final String? currentCity;
  final String? currentNeighborhood;
  final String? currentCamp;
  final String? currentStreet;
  final String? currentPhoneNumber;
  final String? fatherFirstName;
  final String? fatherLastName;
  final DateTime? fatherDateOfBirth;
  final DateTime? fatherDateOfDeath;
  final String? fatherCauseOfDeath;
  final bool? fatherAlive;
  final String? fatherEducationLevel;
  final String? fatherWork;
  final String? fatherMonthlyIncome;
  final int? fatherNumberOfWives;
  final int? fatherNumberOfChildren;
  final String? motherFirstName;
  final String? motherLastName;
  final DateTime? motherDateOfBirth;
  final DateTime? motherDateOfDeath;
  final String? motherCauseOfDeath;
  final bool? motherAlive;
  final String? motherEducationLevel;
  final String? motherWork;
  final String? motherMonthlyIncome;
  final bool? motherRemarried;
  final bool? motherNeedsSupport;
  final String? guardianName;
  final String? guardianRelationship;
  final String? guardianEducationLevel;
  final String? guardianWork;
  final int? guardianNumberOfDependents;
  final String? guardianMonthlyIncome;
  final EducationLevel? educationLevel;
  final String? schoolName;
  final String? educationAddress;
  final String? educationCosts;
  final String? studyYear;
  final String? grade;
  final String? educationStage;
  final String? studyType;
  final String? educationAchievement;
  final String? lastStudyResult;
  final String? weakSubjects;
  final String? strongSubjects;
  final String? studyImprovementActions;
  final String? reasonForNotStudying;
  final bool? stoppedStudying;
  final String? reasonForStoppingStufy;
  final HealthStatus? healthStatus;
  final PsychologicalStatus? psychologicalStatus;
  final PsychologicalStatus? behavioralStatus;
  final String? nutritionalStatus;
  final String? disabilityType;
  final DisabilityType? disabilityLevel;
  final String? medicalConditions;
  final String? medications;
  final bool? needsMedicalSupport;
  final AccommodationType? accommodationType;
  final String? accommodationAddress;
  final String? accommodationCondition;
  final String? accommodationOwnership;
  final bool? needsHousingSupport;
  final String? quranMemorization;
  final bool? attendsIslamicSchool;
  final String? islamicEducationLevel;
  final String? hobbies;
  final String? skills;
  final String? aspirations;
  final int? numberOfSiblings;
  final String? siblingsDetails;
  final String? additionalNotes;
  final String? urgentNeeds;
  final String? specialCircumstances;
  final String? photoPath;
  final String? documentsPath;
  const Orphan(
      {required this.orphanId,
      required this.firstName,
      required this.lastName,
      required this.familyName,
      required this.gender,
      required this.dateOfBirth,
      this.placeOfBirth,
      this.nationality,
      this.idNumber,
      required this.status,
      this.lastSeenLocation,
      required this.lastUpdated,
      required this.supervisorId,
      this.currentCountry,
      this.currentGovernorate,
      this.currentCity,
      this.currentNeighborhood,
      this.currentCamp,
      this.currentStreet,
      this.currentPhoneNumber,
      this.fatherFirstName,
      this.fatherLastName,
      this.fatherDateOfBirth,
      this.fatherDateOfDeath,
      this.fatherCauseOfDeath,
      this.fatherAlive,
      this.fatherEducationLevel,
      this.fatherWork,
      this.fatherMonthlyIncome,
      this.fatherNumberOfWives,
      this.fatherNumberOfChildren,
      this.motherFirstName,
      this.motherLastName,
      this.motherDateOfBirth,
      this.motherDateOfDeath,
      this.motherCauseOfDeath,
      this.motherAlive,
      this.motherEducationLevel,
      this.motherWork,
      this.motherMonthlyIncome,
      this.motherRemarried,
      this.motherNeedsSupport,
      this.guardianName,
      this.guardianRelationship,
      this.guardianEducationLevel,
      this.guardianWork,
      this.guardianNumberOfDependents,
      this.guardianMonthlyIncome,
      this.educationLevel,
      this.schoolName,
      this.educationAddress,
      this.educationCosts,
      this.studyYear,
      this.grade,
      this.educationStage,
      this.studyType,
      this.educationAchievement,
      this.lastStudyResult,
      this.weakSubjects,
      this.strongSubjects,
      this.studyImprovementActions,
      this.reasonForNotStudying,
      this.stoppedStudying,
      this.reasonForStoppingStufy,
      this.healthStatus,
      this.psychologicalStatus,
      this.behavioralStatus,
      this.nutritionalStatus,
      this.disabilityType,
      this.disabilityLevel,
      this.medicalConditions,
      this.medications,
      this.needsMedicalSupport,
      this.accommodationType,
      this.accommodationAddress,
      this.accommodationCondition,
      this.accommodationOwnership,
      this.needsHousingSupport,
      this.quranMemorization,
      this.attendsIslamicSchool,
      this.islamicEducationLevel,
      this.hobbies,
      this.skills,
      this.aspirations,
      this.numberOfSiblings,
      this.siblingsDetails,
      this.additionalNotes,
      this.urgentNeeds,
      this.specialCircumstances,
      this.photoPath,
      this.documentsPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['orphan_id'] = Variable<String>(orphanId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['family_name'] = Variable<String>(familyName);
    {
      map['gender'] =
          Variable<int>($OrphansTable.$convertergender.toSql(gender));
    }
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    if (!nullToAbsent || placeOfBirth != null) {
      map['place_of_birth'] = Variable<String>(placeOfBirth);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
    }
    {
      map['status'] =
          Variable<int>($OrphansTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || lastSeenLocation != null) {
      map['last_seen_location'] = Variable<String>(lastSeenLocation);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['supervisor_id'] = Variable<String>(supervisorId);
    if (!nullToAbsent || currentCountry != null) {
      map['current_country'] = Variable<String>(currentCountry);
    }
    if (!nullToAbsent || currentGovernorate != null) {
      map['current_governorate'] = Variable<String>(currentGovernorate);
    }
    if (!nullToAbsent || currentCity != null) {
      map['current_city'] = Variable<String>(currentCity);
    }
    if (!nullToAbsent || currentNeighborhood != null) {
      map['current_neighborhood'] = Variable<String>(currentNeighborhood);
    }
    if (!nullToAbsent || currentCamp != null) {
      map['current_camp'] = Variable<String>(currentCamp);
    }
    if (!nullToAbsent || currentStreet != null) {
      map['current_street'] = Variable<String>(currentStreet);
    }
    if (!nullToAbsent || currentPhoneNumber != null) {
      map['current_phone_number'] = Variable<String>(currentPhoneNumber);
    }
    if (!nullToAbsent || fatherFirstName != null) {
      map['father_first_name'] = Variable<String>(fatherFirstName);
    }
    if (!nullToAbsent || fatherLastName != null) {
      map['father_last_name'] = Variable<String>(fatherLastName);
    }
    if (!nullToAbsent || fatherDateOfBirth != null) {
      map['father_date_of_birth'] = Variable<DateTime>(fatherDateOfBirth);
    }
    if (!nullToAbsent || fatherDateOfDeath != null) {
      map['father_date_of_death'] = Variable<DateTime>(fatherDateOfDeath);
    }
    if (!nullToAbsent || fatherCauseOfDeath != null) {
      map['father_cause_of_death'] = Variable<String>(fatherCauseOfDeath);
    }
    if (!nullToAbsent || fatherAlive != null) {
      map['father_alive'] = Variable<bool>(fatherAlive);
    }
    if (!nullToAbsent || fatherEducationLevel != null) {
      map['father_education_level'] = Variable<String>(fatherEducationLevel);
    }
    if (!nullToAbsent || fatherWork != null) {
      map['father_work'] = Variable<String>(fatherWork);
    }
    if (!nullToAbsent || fatherMonthlyIncome != null) {
      map['father_monthly_income'] = Variable<String>(fatherMonthlyIncome);
    }
    if (!nullToAbsent || fatherNumberOfWives != null) {
      map['father_number_of_wives'] = Variable<int>(fatherNumberOfWives);
    }
    if (!nullToAbsent || fatherNumberOfChildren != null) {
      map['father_number_of_children'] = Variable<int>(fatherNumberOfChildren);
    }
    if (!nullToAbsent || motherFirstName != null) {
      map['mother_first_name'] = Variable<String>(motherFirstName);
    }
    if (!nullToAbsent || motherLastName != null) {
      map['mother_last_name'] = Variable<String>(motherLastName);
    }
    if (!nullToAbsent || motherDateOfBirth != null) {
      map['mother_date_of_birth'] = Variable<DateTime>(motherDateOfBirth);
    }
    if (!nullToAbsent || motherDateOfDeath != null) {
      map['mother_date_of_death'] = Variable<DateTime>(motherDateOfDeath);
    }
    if (!nullToAbsent || motherCauseOfDeath != null) {
      map['mother_cause_of_death'] = Variable<String>(motherCauseOfDeath);
    }
    if (!nullToAbsent || motherAlive != null) {
      map['mother_alive'] = Variable<bool>(motherAlive);
    }
    if (!nullToAbsent || motherEducationLevel != null) {
      map['mother_education_level'] = Variable<String>(motherEducationLevel);
    }
    if (!nullToAbsent || motherWork != null) {
      map['mother_work'] = Variable<String>(motherWork);
    }
    if (!nullToAbsent || motherMonthlyIncome != null) {
      map['mother_monthly_income'] = Variable<String>(motherMonthlyIncome);
    }
    if (!nullToAbsent || motherRemarried != null) {
      map['mother_remarried'] = Variable<bool>(motherRemarried);
    }
    if (!nullToAbsent || motherNeedsSupport != null) {
      map['mother_needs_support'] = Variable<bool>(motherNeedsSupport);
    }
    if (!nullToAbsent || guardianName != null) {
      map['guardian_name'] = Variable<String>(guardianName);
    }
    if (!nullToAbsent || guardianRelationship != null) {
      map['guardian_relationship'] = Variable<String>(guardianRelationship);
    }
    if (!nullToAbsent || guardianEducationLevel != null) {
      map['guardian_education_level'] =
          Variable<String>(guardianEducationLevel);
    }
    if (!nullToAbsent || guardianWork != null) {
      map['guardian_work'] = Variable<String>(guardianWork);
    }
    if (!nullToAbsent || guardianNumberOfDependents != null) {
      map['guardian_number_of_dependents'] =
          Variable<int>(guardianNumberOfDependents);
    }
    if (!nullToAbsent || guardianMonthlyIncome != null) {
      map['guardian_monthly_income'] = Variable<String>(guardianMonthlyIncome);
    }
    if (!nullToAbsent || educationLevel != null) {
      map['education_level'] = Variable<int>(
          $OrphansTable.$convertereducationLeveln.toSql(educationLevel));
    }
    if (!nullToAbsent || schoolName != null) {
      map['school_name'] = Variable<String>(schoolName);
    }
    if (!nullToAbsent || educationAddress != null) {
      map['education_address'] = Variable<String>(educationAddress);
    }
    if (!nullToAbsent || educationCosts != null) {
      map['education_costs'] = Variable<String>(educationCosts);
    }
    if (!nullToAbsent || studyYear != null) {
      map['study_year'] = Variable<String>(studyYear);
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<String>(grade);
    }
    if (!nullToAbsent || educationStage != null) {
      map['education_stage'] = Variable<String>(educationStage);
    }
    if (!nullToAbsent || studyType != null) {
      map['study_type'] = Variable<String>(studyType);
    }
    if (!nullToAbsent || educationAchievement != null) {
      map['education_achievement'] = Variable<String>(educationAchievement);
    }
    if (!nullToAbsent || lastStudyResult != null) {
      map['last_study_result'] = Variable<String>(lastStudyResult);
    }
    if (!nullToAbsent || weakSubjects != null) {
      map['weak_subjects'] = Variable<String>(weakSubjects);
    }
    if (!nullToAbsent || strongSubjects != null) {
      map['strong_subjects'] = Variable<String>(strongSubjects);
    }
    if (!nullToAbsent || studyImprovementActions != null) {
      map['study_improvement_actions'] =
          Variable<String>(studyImprovementActions);
    }
    if (!nullToAbsent || reasonForNotStudying != null) {
      map['reason_for_not_studying'] = Variable<String>(reasonForNotStudying);
    }
    if (!nullToAbsent || stoppedStudying != null) {
      map['stopped_studying'] = Variable<bool>(stoppedStudying);
    }
    if (!nullToAbsent || reasonForStoppingStufy != null) {
      map['reason_for_stopping_stufy'] =
          Variable<String>(reasonForStoppingStufy);
    }
    if (!nullToAbsent || healthStatus != null) {
      map['health_status'] = Variable<int>(
          $OrphansTable.$converterhealthStatusn.toSql(healthStatus));
    }
    if (!nullToAbsent || psychologicalStatus != null) {
      map['psychological_status'] = Variable<int>($OrphansTable
          .$converterpsychologicalStatusn
          .toSql(psychologicalStatus));
    }
    if (!nullToAbsent || behavioralStatus != null) {
      map['behavioral_status'] = Variable<int>(
          $OrphansTable.$converterbehavioralStatusn.toSql(behavioralStatus));
    }
    if (!nullToAbsent || nutritionalStatus != null) {
      map['nutritional_status'] = Variable<String>(nutritionalStatus);
    }
    if (!nullToAbsent || disabilityType != null) {
      map['disability_type'] = Variable<String>(disabilityType);
    }
    if (!nullToAbsent || disabilityLevel != null) {
      map['disability_level'] = Variable<int>(
          $OrphansTable.$converterdisabilityLeveln.toSql(disabilityLevel));
    }
    if (!nullToAbsent || medicalConditions != null) {
      map['medical_conditions'] = Variable<String>(medicalConditions);
    }
    if (!nullToAbsent || medications != null) {
      map['medications'] = Variable<String>(medications);
    }
    if (!nullToAbsent || needsMedicalSupport != null) {
      map['needs_medical_support'] = Variable<bool>(needsMedicalSupport);
    }
    if (!nullToAbsent || accommodationType != null) {
      map['accommodation_type'] = Variable<int>(
          $OrphansTable.$converteraccommodationTypen.toSql(accommodationType));
    }
    if (!nullToAbsent || accommodationAddress != null) {
      map['accommodation_address'] = Variable<String>(accommodationAddress);
    }
    if (!nullToAbsent || accommodationCondition != null) {
      map['accommodation_condition'] = Variable<String>(accommodationCondition);
    }
    if (!nullToAbsent || accommodationOwnership != null) {
      map['accommodation_ownership'] = Variable<String>(accommodationOwnership);
    }
    if (!nullToAbsent || needsHousingSupport != null) {
      map['needs_housing_support'] = Variable<bool>(needsHousingSupport);
    }
    if (!nullToAbsent || quranMemorization != null) {
      map['quran_memorization'] = Variable<String>(quranMemorization);
    }
    if (!nullToAbsent || attendsIslamicSchool != null) {
      map['attends_islamic_school'] = Variable<bool>(attendsIslamicSchool);
    }
    if (!nullToAbsent || islamicEducationLevel != null) {
      map['islamic_education_level'] = Variable<String>(islamicEducationLevel);
    }
    if (!nullToAbsent || hobbies != null) {
      map['hobbies'] = Variable<String>(hobbies);
    }
    if (!nullToAbsent || skills != null) {
      map['skills'] = Variable<String>(skills);
    }
    if (!nullToAbsent || aspirations != null) {
      map['aspirations'] = Variable<String>(aspirations);
    }
    if (!nullToAbsent || numberOfSiblings != null) {
      map['number_of_siblings'] = Variable<int>(numberOfSiblings);
    }
    if (!nullToAbsent || siblingsDetails != null) {
      map['siblings_details'] = Variable<String>(siblingsDetails);
    }
    if (!nullToAbsent || additionalNotes != null) {
      map['additional_notes'] = Variable<String>(additionalNotes);
    }
    if (!nullToAbsent || urgentNeeds != null) {
      map['urgent_needs'] = Variable<String>(urgentNeeds);
    }
    if (!nullToAbsent || specialCircumstances != null) {
      map['special_circumstances'] = Variable<String>(specialCircumstances);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || documentsPath != null) {
      map['documents_path'] = Variable<String>(documentsPath);
    }
    return map;
  }

  OrphansCompanion toCompanion(bool nullToAbsent) {
    return OrphansCompanion(
      orphanId: Value(orphanId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      familyName: Value(familyName),
      gender: Value(gender),
      dateOfBirth: Value(dateOfBirth),
      placeOfBirth: placeOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfBirth),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
      status: Value(status),
      lastSeenLocation: lastSeenLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenLocation),
      lastUpdated: Value(lastUpdated),
      supervisorId: Value(supervisorId),
      currentCountry: currentCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(currentCountry),
      currentGovernorate: currentGovernorate == null && nullToAbsent
          ? const Value.absent()
          : Value(currentGovernorate),
      currentCity: currentCity == null && nullToAbsent
          ? const Value.absent()
          : Value(currentCity),
      currentNeighborhood: currentNeighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(currentNeighborhood),
      currentCamp: currentCamp == null && nullToAbsent
          ? const Value.absent()
          : Value(currentCamp),
      currentStreet: currentStreet == null && nullToAbsent
          ? const Value.absent()
          : Value(currentStreet),
      currentPhoneNumber: currentPhoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPhoneNumber),
      fatherFirstName: fatherFirstName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherFirstName),
      fatherLastName: fatherLastName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherLastName),
      fatherDateOfBirth: fatherDateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherDateOfBirth),
      fatherDateOfDeath: fatherDateOfDeath == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherDateOfDeath),
      fatherCauseOfDeath: fatherCauseOfDeath == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherCauseOfDeath),
      fatherAlive: fatherAlive == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherAlive),
      fatherEducationLevel: fatherEducationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherEducationLevel),
      fatherWork: fatherWork == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherWork),
      fatherMonthlyIncome: fatherMonthlyIncome == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherMonthlyIncome),
      fatherNumberOfWives: fatherNumberOfWives == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherNumberOfWives),
      fatherNumberOfChildren: fatherNumberOfChildren == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherNumberOfChildren),
      motherFirstName: motherFirstName == null && nullToAbsent
          ? const Value.absent()
          : Value(motherFirstName),
      motherLastName: motherLastName == null && nullToAbsent
          ? const Value.absent()
          : Value(motherLastName),
      motherDateOfBirth: motherDateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(motherDateOfBirth),
      motherDateOfDeath: motherDateOfDeath == null && nullToAbsent
          ? const Value.absent()
          : Value(motherDateOfDeath),
      motherCauseOfDeath: motherCauseOfDeath == null && nullToAbsent
          ? const Value.absent()
          : Value(motherCauseOfDeath),
      motherAlive: motherAlive == null && nullToAbsent
          ? const Value.absent()
          : Value(motherAlive),
      motherEducationLevel: motherEducationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(motherEducationLevel),
      motherWork: motherWork == null && nullToAbsent
          ? const Value.absent()
          : Value(motherWork),
      motherMonthlyIncome: motherMonthlyIncome == null && nullToAbsent
          ? const Value.absent()
          : Value(motherMonthlyIncome),
      motherRemarried: motherRemarried == null && nullToAbsent
          ? const Value.absent()
          : Value(motherRemarried),
      motherNeedsSupport: motherNeedsSupport == null && nullToAbsent
          ? const Value.absent()
          : Value(motherNeedsSupport),
      guardianName: guardianName == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianName),
      guardianRelationship: guardianRelationship == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianRelationship),
      guardianEducationLevel: guardianEducationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianEducationLevel),
      guardianWork: guardianWork == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianWork),
      guardianNumberOfDependents:
          guardianNumberOfDependents == null && nullToAbsent
              ? const Value.absent()
              : Value(guardianNumberOfDependents),
      guardianMonthlyIncome: guardianMonthlyIncome == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianMonthlyIncome),
      educationLevel: educationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(educationLevel),
      schoolName: schoolName == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolName),
      educationAddress: educationAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(educationAddress),
      educationCosts: educationCosts == null && nullToAbsent
          ? const Value.absent()
          : Value(educationCosts),
      studyYear: studyYear == null && nullToAbsent
          ? const Value.absent()
          : Value(studyYear),
      grade:
          grade == null && nullToAbsent ? const Value.absent() : Value(grade),
      educationStage: educationStage == null && nullToAbsent
          ? const Value.absent()
          : Value(educationStage),
      studyType: studyType == null && nullToAbsent
          ? const Value.absent()
          : Value(studyType),
      educationAchievement: educationAchievement == null && nullToAbsent
          ? const Value.absent()
          : Value(educationAchievement),
      lastStudyResult: lastStudyResult == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStudyResult),
      weakSubjects: weakSubjects == null && nullToAbsent
          ? const Value.absent()
          : Value(weakSubjects),
      strongSubjects: strongSubjects == null && nullToAbsent
          ? const Value.absent()
          : Value(strongSubjects),
      studyImprovementActions: studyImprovementActions == null && nullToAbsent
          ? const Value.absent()
          : Value(studyImprovementActions),
      reasonForNotStudying: reasonForNotStudying == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonForNotStudying),
      stoppedStudying: stoppedStudying == null && nullToAbsent
          ? const Value.absent()
          : Value(stoppedStudying),
      reasonForStoppingStufy: reasonForStoppingStufy == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonForStoppingStufy),
      healthStatus: healthStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(healthStatus),
      psychologicalStatus: psychologicalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(psychologicalStatus),
      behavioralStatus: behavioralStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(behavioralStatus),
      nutritionalStatus: nutritionalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(nutritionalStatus),
      disabilityType: disabilityType == null && nullToAbsent
          ? const Value.absent()
          : Value(disabilityType),
      disabilityLevel: disabilityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(disabilityLevel),
      medicalConditions: medicalConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalConditions),
      medications: medications == null && nullToAbsent
          ? const Value.absent()
          : Value(medications),
      needsMedicalSupport: needsMedicalSupport == null && nullToAbsent
          ? const Value.absent()
          : Value(needsMedicalSupport),
      accommodationType: accommodationType == null && nullToAbsent
          ? const Value.absent()
          : Value(accommodationType),
      accommodationAddress: accommodationAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(accommodationAddress),
      accommodationCondition: accommodationCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(accommodationCondition),
      accommodationOwnership: accommodationOwnership == null && nullToAbsent
          ? const Value.absent()
          : Value(accommodationOwnership),
      needsHousingSupport: needsHousingSupport == null && nullToAbsent
          ? const Value.absent()
          : Value(needsHousingSupport),
      quranMemorization: quranMemorization == null && nullToAbsent
          ? const Value.absent()
          : Value(quranMemorization),
      attendsIslamicSchool: attendsIslamicSchool == null && nullToAbsent
          ? const Value.absent()
          : Value(attendsIslamicSchool),
      islamicEducationLevel: islamicEducationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(islamicEducationLevel),
      hobbies: hobbies == null && nullToAbsent
          ? const Value.absent()
          : Value(hobbies),
      skills:
          skills == null && nullToAbsent ? const Value.absent() : Value(skills),
      aspirations: aspirations == null && nullToAbsent
          ? const Value.absent()
          : Value(aspirations),
      numberOfSiblings: numberOfSiblings == null && nullToAbsent
          ? const Value.absent()
          : Value(numberOfSiblings),
      siblingsDetails: siblingsDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(siblingsDetails),
      additionalNotes: additionalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalNotes),
      urgentNeeds: urgentNeeds == null && nullToAbsent
          ? const Value.absent()
          : Value(urgentNeeds),
      specialCircumstances: specialCircumstances == null && nullToAbsent
          ? const Value.absent()
          : Value(specialCircumstances),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      documentsPath: documentsPath == null && nullToAbsent
          ? const Value.absent()
          : Value(documentsPath),
    );
  }

  factory Orphan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Orphan(
      orphanId: serializer.fromJson<String>(json['orphanId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      familyName: serializer.fromJson<String>(json['familyName']),
      gender: $OrphansTable.$convertergender
          .fromJson(serializer.fromJson<int>(json['gender'])),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      placeOfBirth: serializer.fromJson<String?>(json['placeOfBirth']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
      status: $OrphansTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      lastSeenLocation: serializer.fromJson<String?>(json['lastSeenLocation']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      supervisorId: serializer.fromJson<String>(json['supervisorId']),
      currentCountry: serializer.fromJson<String?>(json['currentCountry']),
      currentGovernorate:
          serializer.fromJson<String?>(json['currentGovernorate']),
      currentCity: serializer.fromJson<String?>(json['currentCity']),
      currentNeighborhood:
          serializer.fromJson<String?>(json['currentNeighborhood']),
      currentCamp: serializer.fromJson<String?>(json['currentCamp']),
      currentStreet: serializer.fromJson<String?>(json['currentStreet']),
      currentPhoneNumber:
          serializer.fromJson<String?>(json['currentPhoneNumber']),
      fatherFirstName: serializer.fromJson<String?>(json['fatherFirstName']),
      fatherLastName: serializer.fromJson<String?>(json['fatherLastName']),
      fatherDateOfBirth:
          serializer.fromJson<DateTime?>(json['fatherDateOfBirth']),
      fatherDateOfDeath:
          serializer.fromJson<DateTime?>(json['fatherDateOfDeath']),
      fatherCauseOfDeath:
          serializer.fromJson<String?>(json['fatherCauseOfDeath']),
      fatherAlive: serializer.fromJson<bool?>(json['fatherAlive']),
      fatherEducationLevel:
          serializer.fromJson<String?>(json['fatherEducationLevel']),
      fatherWork: serializer.fromJson<String?>(json['fatherWork']),
      fatherMonthlyIncome:
          serializer.fromJson<String?>(json['fatherMonthlyIncome']),
      fatherNumberOfWives:
          serializer.fromJson<int?>(json['fatherNumberOfWives']),
      fatherNumberOfChildren:
          serializer.fromJson<int?>(json['fatherNumberOfChildren']),
      motherFirstName: serializer.fromJson<String?>(json['motherFirstName']),
      motherLastName: serializer.fromJson<String?>(json['motherLastName']),
      motherDateOfBirth:
          serializer.fromJson<DateTime?>(json['motherDateOfBirth']),
      motherDateOfDeath:
          serializer.fromJson<DateTime?>(json['motherDateOfDeath']),
      motherCauseOfDeath:
          serializer.fromJson<String?>(json['motherCauseOfDeath']),
      motherAlive: serializer.fromJson<bool?>(json['motherAlive']),
      motherEducationLevel:
          serializer.fromJson<String?>(json['motherEducationLevel']),
      motherWork: serializer.fromJson<String?>(json['motherWork']),
      motherMonthlyIncome:
          serializer.fromJson<String?>(json['motherMonthlyIncome']),
      motherRemarried: serializer.fromJson<bool?>(json['motherRemarried']),
      motherNeedsSupport:
          serializer.fromJson<bool?>(json['motherNeedsSupport']),
      guardianName: serializer.fromJson<String?>(json['guardianName']),
      guardianRelationship:
          serializer.fromJson<String?>(json['guardianRelationship']),
      guardianEducationLevel:
          serializer.fromJson<String?>(json['guardianEducationLevel']),
      guardianWork: serializer.fromJson<String?>(json['guardianWork']),
      guardianNumberOfDependents:
          serializer.fromJson<int?>(json['guardianNumberOfDependents']),
      guardianMonthlyIncome:
          serializer.fromJson<String?>(json['guardianMonthlyIncome']),
      educationLevel: $OrphansTable.$convertereducationLeveln
          .fromJson(serializer.fromJson<int?>(json['educationLevel'])),
      schoolName: serializer.fromJson<String?>(json['schoolName']),
      educationAddress: serializer.fromJson<String?>(json['educationAddress']),
      educationCosts: serializer.fromJson<String?>(json['educationCosts']),
      studyYear: serializer.fromJson<String?>(json['studyYear']),
      grade: serializer.fromJson<String?>(json['grade']),
      educationStage: serializer.fromJson<String?>(json['educationStage']),
      studyType: serializer.fromJson<String?>(json['studyType']),
      educationAchievement:
          serializer.fromJson<String?>(json['educationAchievement']),
      lastStudyResult: serializer.fromJson<String?>(json['lastStudyResult']),
      weakSubjects: serializer.fromJson<String?>(json['weakSubjects']),
      strongSubjects: serializer.fromJson<String?>(json['strongSubjects']),
      studyImprovementActions:
          serializer.fromJson<String?>(json['studyImprovementActions']),
      reasonForNotStudying:
          serializer.fromJson<String?>(json['reasonForNotStudying']),
      stoppedStudying: serializer.fromJson<bool?>(json['stoppedStudying']),
      reasonForStoppingStufy:
          serializer.fromJson<String?>(json['reasonForStoppingStufy']),
      healthStatus: $OrphansTable.$converterhealthStatusn
          .fromJson(serializer.fromJson<int?>(json['healthStatus'])),
      psychologicalStatus: $OrphansTable.$converterpsychologicalStatusn
          .fromJson(serializer.fromJson<int?>(json['psychologicalStatus'])),
      behavioralStatus: $OrphansTable.$converterbehavioralStatusn
          .fromJson(serializer.fromJson<int?>(json['behavioralStatus'])),
      nutritionalStatus:
          serializer.fromJson<String?>(json['nutritionalStatus']),
      disabilityType: serializer.fromJson<String?>(json['disabilityType']),
      disabilityLevel: $OrphansTable.$converterdisabilityLeveln
          .fromJson(serializer.fromJson<int?>(json['disabilityLevel'])),
      medicalConditions:
          serializer.fromJson<String?>(json['medicalConditions']),
      medications: serializer.fromJson<String?>(json['medications']),
      needsMedicalSupport:
          serializer.fromJson<bool?>(json['needsMedicalSupport']),
      accommodationType: $OrphansTable.$converteraccommodationTypen
          .fromJson(serializer.fromJson<int?>(json['accommodationType'])),
      accommodationAddress:
          serializer.fromJson<String?>(json['accommodationAddress']),
      accommodationCondition:
          serializer.fromJson<String?>(json['accommodationCondition']),
      accommodationOwnership:
          serializer.fromJson<String?>(json['accommodationOwnership']),
      needsHousingSupport:
          serializer.fromJson<bool?>(json['needsHousingSupport']),
      quranMemorization:
          serializer.fromJson<String?>(json['quranMemorization']),
      attendsIslamicSchool:
          serializer.fromJson<bool?>(json['attendsIslamicSchool']),
      islamicEducationLevel:
          serializer.fromJson<String?>(json['islamicEducationLevel']),
      hobbies: serializer.fromJson<String?>(json['hobbies']),
      skills: serializer.fromJson<String?>(json['skills']),
      aspirations: serializer.fromJson<String?>(json['aspirations']),
      numberOfSiblings: serializer.fromJson<int?>(json['numberOfSiblings']),
      siblingsDetails: serializer.fromJson<String?>(json['siblingsDetails']),
      additionalNotes: serializer.fromJson<String?>(json['additionalNotes']),
      urgentNeeds: serializer.fromJson<String?>(json['urgentNeeds']),
      specialCircumstances:
          serializer.fromJson<String?>(json['specialCircumstances']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      documentsPath: serializer.fromJson<String?>(json['documentsPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orphanId': serializer.toJson<String>(orphanId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'familyName': serializer.toJson<String>(familyName),
      'gender':
          serializer.toJson<int>($OrphansTable.$convertergender.toJson(gender)),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'placeOfBirth': serializer.toJson<String?>(placeOfBirth),
      'nationality': serializer.toJson<String?>(nationality),
      'idNumber': serializer.toJson<String?>(idNumber),
      'status':
          serializer.toJson<int>($OrphansTable.$converterstatus.toJson(status)),
      'lastSeenLocation': serializer.toJson<String?>(lastSeenLocation),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'supervisorId': serializer.toJson<String>(supervisorId),
      'currentCountry': serializer.toJson<String?>(currentCountry),
      'currentGovernorate': serializer.toJson<String?>(currentGovernorate),
      'currentCity': serializer.toJson<String?>(currentCity),
      'currentNeighborhood': serializer.toJson<String?>(currentNeighborhood),
      'currentCamp': serializer.toJson<String?>(currentCamp),
      'currentStreet': serializer.toJson<String?>(currentStreet),
      'currentPhoneNumber': serializer.toJson<String?>(currentPhoneNumber),
      'fatherFirstName': serializer.toJson<String?>(fatherFirstName),
      'fatherLastName': serializer.toJson<String?>(fatherLastName),
      'fatherDateOfBirth': serializer.toJson<DateTime?>(fatherDateOfBirth),
      'fatherDateOfDeath': serializer.toJson<DateTime?>(fatherDateOfDeath),
      'fatherCauseOfDeath': serializer.toJson<String?>(fatherCauseOfDeath),
      'fatherAlive': serializer.toJson<bool?>(fatherAlive),
      'fatherEducationLevel': serializer.toJson<String?>(fatherEducationLevel),
      'fatherWork': serializer.toJson<String?>(fatherWork),
      'fatherMonthlyIncome': serializer.toJson<String?>(fatherMonthlyIncome),
      'fatherNumberOfWives': serializer.toJson<int?>(fatherNumberOfWives),
      'fatherNumberOfChildren': serializer.toJson<int?>(fatherNumberOfChildren),
      'motherFirstName': serializer.toJson<String?>(motherFirstName),
      'motherLastName': serializer.toJson<String?>(motherLastName),
      'motherDateOfBirth': serializer.toJson<DateTime?>(motherDateOfBirth),
      'motherDateOfDeath': serializer.toJson<DateTime?>(motherDateOfDeath),
      'motherCauseOfDeath': serializer.toJson<String?>(motherCauseOfDeath),
      'motherAlive': serializer.toJson<bool?>(motherAlive),
      'motherEducationLevel': serializer.toJson<String?>(motherEducationLevel),
      'motherWork': serializer.toJson<String?>(motherWork),
      'motherMonthlyIncome': serializer.toJson<String?>(motherMonthlyIncome),
      'motherRemarried': serializer.toJson<bool?>(motherRemarried),
      'motherNeedsSupport': serializer.toJson<bool?>(motherNeedsSupport),
      'guardianName': serializer.toJson<String?>(guardianName),
      'guardianRelationship': serializer.toJson<String?>(guardianRelationship),
      'guardianEducationLevel':
          serializer.toJson<String?>(guardianEducationLevel),
      'guardianWork': serializer.toJson<String?>(guardianWork),
      'guardianNumberOfDependents':
          serializer.toJson<int?>(guardianNumberOfDependents),
      'guardianMonthlyIncome':
          serializer.toJson<String?>(guardianMonthlyIncome),
      'educationLevel': serializer.toJson<int?>(
          $OrphansTable.$convertereducationLeveln.toJson(educationLevel)),
      'schoolName': serializer.toJson<String?>(schoolName),
      'educationAddress': serializer.toJson<String?>(educationAddress),
      'educationCosts': serializer.toJson<String?>(educationCosts),
      'studyYear': serializer.toJson<String?>(studyYear),
      'grade': serializer.toJson<String?>(grade),
      'educationStage': serializer.toJson<String?>(educationStage),
      'studyType': serializer.toJson<String?>(studyType),
      'educationAchievement': serializer.toJson<String?>(educationAchievement),
      'lastStudyResult': serializer.toJson<String?>(lastStudyResult),
      'weakSubjects': serializer.toJson<String?>(weakSubjects),
      'strongSubjects': serializer.toJson<String?>(strongSubjects),
      'studyImprovementActions':
          serializer.toJson<String?>(studyImprovementActions),
      'reasonForNotStudying': serializer.toJson<String?>(reasonForNotStudying),
      'stoppedStudying': serializer.toJson<bool?>(stoppedStudying),
      'reasonForStoppingStufy':
          serializer.toJson<String?>(reasonForStoppingStufy),
      'healthStatus': serializer.toJson<int?>(
          $OrphansTable.$converterhealthStatusn.toJson(healthStatus)),
      'psychologicalStatus': serializer.toJson<int?>($OrphansTable
          .$converterpsychologicalStatusn
          .toJson(psychologicalStatus)),
      'behavioralStatus': serializer.toJson<int?>(
          $OrphansTable.$converterbehavioralStatusn.toJson(behavioralStatus)),
      'nutritionalStatus': serializer.toJson<String?>(nutritionalStatus),
      'disabilityType': serializer.toJson<String?>(disabilityType),
      'disabilityLevel': serializer.toJson<int?>(
          $OrphansTable.$converterdisabilityLeveln.toJson(disabilityLevel)),
      'medicalConditions': serializer.toJson<String?>(medicalConditions),
      'medications': serializer.toJson<String?>(medications),
      'needsMedicalSupport': serializer.toJson<bool?>(needsMedicalSupport),
      'accommodationType': serializer.toJson<int?>(
          $OrphansTable.$converteraccommodationTypen.toJson(accommodationType)),
      'accommodationAddress': serializer.toJson<String?>(accommodationAddress),
      'accommodationCondition':
          serializer.toJson<String?>(accommodationCondition),
      'accommodationOwnership':
          serializer.toJson<String?>(accommodationOwnership),
      'needsHousingSupport': serializer.toJson<bool?>(needsHousingSupport),
      'quranMemorization': serializer.toJson<String?>(quranMemorization),
      'attendsIslamicSchool': serializer.toJson<bool?>(attendsIslamicSchool),
      'islamicEducationLevel':
          serializer.toJson<String?>(islamicEducationLevel),
      'hobbies': serializer.toJson<String?>(hobbies),
      'skills': serializer.toJson<String?>(skills),
      'aspirations': serializer.toJson<String?>(aspirations),
      'numberOfSiblings': serializer.toJson<int?>(numberOfSiblings),
      'siblingsDetails': serializer.toJson<String?>(siblingsDetails),
      'additionalNotes': serializer.toJson<String?>(additionalNotes),
      'urgentNeeds': serializer.toJson<String?>(urgentNeeds),
      'specialCircumstances': serializer.toJson<String?>(specialCircumstances),
      'photoPath': serializer.toJson<String?>(photoPath),
      'documentsPath': serializer.toJson<String?>(documentsPath),
    };
  }

  Orphan copyWith(
          {String? orphanId,
          String? firstName,
          String? lastName,
          String? familyName,
          Gender? gender,
          DateTime? dateOfBirth,
          Value<String?> placeOfBirth = const Value.absent(),
          Value<String?> nationality = const Value.absent(),
          Value<String?> idNumber = const Value.absent(),
          OrphanStatus? status,
          Value<String?> lastSeenLocation = const Value.absent(),
          DateTime? lastUpdated,
          String? supervisorId,
          Value<String?> currentCountry = const Value.absent(),
          Value<String?> currentGovernorate = const Value.absent(),
          Value<String?> currentCity = const Value.absent(),
          Value<String?> currentNeighborhood = const Value.absent(),
          Value<String?> currentCamp = const Value.absent(),
          Value<String?> currentStreet = const Value.absent(),
          Value<String?> currentPhoneNumber = const Value.absent(),
          Value<String?> fatherFirstName = const Value.absent(),
          Value<String?> fatherLastName = const Value.absent(),
          Value<DateTime?> fatherDateOfBirth = const Value.absent(),
          Value<DateTime?> fatherDateOfDeath = const Value.absent(),
          Value<String?> fatherCauseOfDeath = const Value.absent(),
          Value<bool?> fatherAlive = const Value.absent(),
          Value<String?> fatherEducationLevel = const Value.absent(),
          Value<String?> fatherWork = const Value.absent(),
          Value<String?> fatherMonthlyIncome = const Value.absent(),
          Value<int?> fatherNumberOfWives = const Value.absent(),
          Value<int?> fatherNumberOfChildren = const Value.absent(),
          Value<String?> motherFirstName = const Value.absent(),
          Value<String?> motherLastName = const Value.absent(),
          Value<DateTime?> motherDateOfBirth = const Value.absent(),
          Value<DateTime?> motherDateOfDeath = const Value.absent(),
          Value<String?> motherCauseOfDeath = const Value.absent(),
          Value<bool?> motherAlive = const Value.absent(),
          Value<String?> motherEducationLevel = const Value.absent(),
          Value<String?> motherWork = const Value.absent(),
          Value<String?> motherMonthlyIncome = const Value.absent(),
          Value<bool?> motherRemarried = const Value.absent(),
          Value<bool?> motherNeedsSupport = const Value.absent(),
          Value<String?> guardianName = const Value.absent(),
          Value<String?> guardianRelationship = const Value.absent(),
          Value<String?> guardianEducationLevel = const Value.absent(),
          Value<String?> guardianWork = const Value.absent(),
          Value<int?> guardianNumberOfDependents = const Value.absent(),
          Value<String?> guardianMonthlyIncome = const Value.absent(),
          Value<EducationLevel?> educationLevel = const Value.absent(),
          Value<String?> schoolName = const Value.absent(),
          Value<String?> educationAddress = const Value.absent(),
          Value<String?> educationCosts = const Value.absent(),
          Value<String?> studyYear = const Value.absent(),
          Value<String?> grade = const Value.absent(),
          Value<String?> educationStage = const Value.absent(),
          Value<String?> studyType = const Value.absent(),
          Value<String?> educationAchievement = const Value.absent(),
          Value<String?> lastStudyResult = const Value.absent(),
          Value<String?> weakSubjects = const Value.absent(),
          Value<String?> strongSubjects = const Value.absent(),
          Value<String?> studyImprovementActions = const Value.absent(),
          Value<String?> reasonForNotStudying = const Value.absent(),
          Value<bool?> stoppedStudying = const Value.absent(),
          Value<String?> reasonForStoppingStufy = const Value.absent(),
          Value<HealthStatus?> healthStatus = const Value.absent(),
          Value<PsychologicalStatus?> psychologicalStatus =
              const Value.absent(),
          Value<PsychologicalStatus?> behavioralStatus = const Value.absent(),
          Value<String?> nutritionalStatus = const Value.absent(),
          Value<String?> disabilityType = const Value.absent(),
          Value<DisabilityType?> disabilityLevel = const Value.absent(),
          Value<String?> medicalConditions = const Value.absent(),
          Value<String?> medications = const Value.absent(),
          Value<bool?> needsMedicalSupport = const Value.absent(),
          Value<AccommodationType?> accommodationType = const Value.absent(),
          Value<String?> accommodationAddress = const Value.absent(),
          Value<String?> accommodationCondition = const Value.absent(),
          Value<String?> accommodationOwnership = const Value.absent(),
          Value<bool?> needsHousingSupport = const Value.absent(),
          Value<String?> quranMemorization = const Value.absent(),
          Value<bool?> attendsIslamicSchool = const Value.absent(),
          Value<String?> islamicEducationLevel = const Value.absent(),
          Value<String?> hobbies = const Value.absent(),
          Value<String?> skills = const Value.absent(),
          Value<String?> aspirations = const Value.absent(),
          Value<int?> numberOfSiblings = const Value.absent(),
          Value<String?> siblingsDetails = const Value.absent(),
          Value<String?> additionalNotes = const Value.absent(),
          Value<String?> urgentNeeds = const Value.absent(),
          Value<String?> specialCircumstances = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> documentsPath = const Value.absent()}) =>
      Orphan(
        orphanId: orphanId ?? this.orphanId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        familyName: familyName ?? this.familyName,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        placeOfBirth:
            placeOfBirth.present ? placeOfBirth.value : this.placeOfBirth,
        nationality: nationality.present ? nationality.value : this.nationality,
        idNumber: idNumber.present ? idNumber.value : this.idNumber,
        status: status ?? this.status,
        lastSeenLocation: lastSeenLocation.present
            ? lastSeenLocation.value
            : this.lastSeenLocation,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        supervisorId: supervisorId ?? this.supervisorId,
        currentCountry:
            currentCountry.present ? currentCountry.value : this.currentCountry,
        currentGovernorate: currentGovernorate.present
            ? currentGovernorate.value
            : this.currentGovernorate,
        currentCity: currentCity.present ? currentCity.value : this.currentCity,
        currentNeighborhood: currentNeighborhood.present
            ? currentNeighborhood.value
            : this.currentNeighborhood,
        currentCamp: currentCamp.present ? currentCamp.value : this.currentCamp,
        currentStreet:
            currentStreet.present ? currentStreet.value : this.currentStreet,
        currentPhoneNumber: currentPhoneNumber.present
            ? currentPhoneNumber.value
            : this.currentPhoneNumber,
        fatherFirstName: fatherFirstName.present
            ? fatherFirstName.value
            : this.fatherFirstName,
        fatherLastName:
            fatherLastName.present ? fatherLastName.value : this.fatherLastName,
        fatherDateOfBirth: fatherDateOfBirth.present
            ? fatherDateOfBirth.value
            : this.fatherDateOfBirth,
        fatherDateOfDeath: fatherDateOfDeath.present
            ? fatherDateOfDeath.value
            : this.fatherDateOfDeath,
        fatherCauseOfDeath: fatherCauseOfDeath.present
            ? fatherCauseOfDeath.value
            : this.fatherCauseOfDeath,
        fatherAlive: fatherAlive.present ? fatherAlive.value : this.fatherAlive,
        fatherEducationLevel: fatherEducationLevel.present
            ? fatherEducationLevel.value
            : this.fatherEducationLevel,
        fatherWork: fatherWork.present ? fatherWork.value : this.fatherWork,
        fatherMonthlyIncome: fatherMonthlyIncome.present
            ? fatherMonthlyIncome.value
            : this.fatherMonthlyIncome,
        fatherNumberOfWives: fatherNumberOfWives.present
            ? fatherNumberOfWives.value
            : this.fatherNumberOfWives,
        fatherNumberOfChildren: fatherNumberOfChildren.present
            ? fatherNumberOfChildren.value
            : this.fatherNumberOfChildren,
        motherFirstName: motherFirstName.present
            ? motherFirstName.value
            : this.motherFirstName,
        motherLastName:
            motherLastName.present ? motherLastName.value : this.motherLastName,
        motherDateOfBirth: motherDateOfBirth.present
            ? motherDateOfBirth.value
            : this.motherDateOfBirth,
        motherDateOfDeath: motherDateOfDeath.present
            ? motherDateOfDeath.value
            : this.motherDateOfDeath,
        motherCauseOfDeath: motherCauseOfDeath.present
            ? motherCauseOfDeath.value
            : this.motherCauseOfDeath,
        motherAlive: motherAlive.present ? motherAlive.value : this.motherAlive,
        motherEducationLevel: motherEducationLevel.present
            ? motherEducationLevel.value
            : this.motherEducationLevel,
        motherWork: motherWork.present ? motherWork.value : this.motherWork,
        motherMonthlyIncome: motherMonthlyIncome.present
            ? motherMonthlyIncome.value
            : this.motherMonthlyIncome,
        motherRemarried: motherRemarried.present
            ? motherRemarried.value
            : this.motherRemarried,
        motherNeedsSupport: motherNeedsSupport.present
            ? motherNeedsSupport.value
            : this.motherNeedsSupport,
        guardianName:
            guardianName.present ? guardianName.value : this.guardianName,
        guardianRelationship: guardianRelationship.present
            ? guardianRelationship.value
            : this.guardianRelationship,
        guardianEducationLevel: guardianEducationLevel.present
            ? guardianEducationLevel.value
            : this.guardianEducationLevel,
        guardianWork:
            guardianWork.present ? guardianWork.value : this.guardianWork,
        guardianNumberOfDependents: guardianNumberOfDependents.present
            ? guardianNumberOfDependents.value
            : this.guardianNumberOfDependents,
        guardianMonthlyIncome: guardianMonthlyIncome.present
            ? guardianMonthlyIncome.value
            : this.guardianMonthlyIncome,
        educationLevel:
            educationLevel.present ? educationLevel.value : this.educationLevel,
        schoolName: schoolName.present ? schoolName.value : this.schoolName,
        educationAddress: educationAddress.present
            ? educationAddress.value
            : this.educationAddress,
        educationCosts:
            educationCosts.present ? educationCosts.value : this.educationCosts,
        studyYear: studyYear.present ? studyYear.value : this.studyYear,
        grade: grade.present ? grade.value : this.grade,
        educationStage:
            educationStage.present ? educationStage.value : this.educationStage,
        studyType: studyType.present ? studyType.value : this.studyType,
        educationAchievement: educationAchievement.present
            ? educationAchievement.value
            : this.educationAchievement,
        lastStudyResult: lastStudyResult.present
            ? lastStudyResult.value
            : this.lastStudyResult,
        weakSubjects:
            weakSubjects.present ? weakSubjects.value : this.weakSubjects,
        strongSubjects:
            strongSubjects.present ? strongSubjects.value : this.strongSubjects,
        studyImprovementActions: studyImprovementActions.present
            ? studyImprovementActions.value
            : this.studyImprovementActions,
        reasonForNotStudying: reasonForNotStudying.present
            ? reasonForNotStudying.value
            : this.reasonForNotStudying,
        stoppedStudying: stoppedStudying.present
            ? stoppedStudying.value
            : this.stoppedStudying,
        reasonForStoppingStufy: reasonForStoppingStufy.present
            ? reasonForStoppingStufy.value
            : this.reasonForStoppingStufy,
        healthStatus:
            healthStatus.present ? healthStatus.value : this.healthStatus,
        psychologicalStatus: psychologicalStatus.present
            ? psychologicalStatus.value
            : this.psychologicalStatus,
        behavioralStatus: behavioralStatus.present
            ? behavioralStatus.value
            : this.behavioralStatus,
        nutritionalStatus: nutritionalStatus.present
            ? nutritionalStatus.value
            : this.nutritionalStatus,
        disabilityType:
            disabilityType.present ? disabilityType.value : this.disabilityType,
        disabilityLevel: disabilityLevel.present
            ? disabilityLevel.value
            : this.disabilityLevel,
        medicalConditions: medicalConditions.present
            ? medicalConditions.value
            : this.medicalConditions,
        medications: medications.present ? medications.value : this.medications,
        needsMedicalSupport: needsMedicalSupport.present
            ? needsMedicalSupport.value
            : this.needsMedicalSupport,
        accommodationType: accommodationType.present
            ? accommodationType.value
            : this.accommodationType,
        accommodationAddress: accommodationAddress.present
            ? accommodationAddress.value
            : this.accommodationAddress,
        accommodationCondition: accommodationCondition.present
            ? accommodationCondition.value
            : this.accommodationCondition,
        accommodationOwnership: accommodationOwnership.present
            ? accommodationOwnership.value
            : this.accommodationOwnership,
        needsHousingSupport: needsHousingSupport.present
            ? needsHousingSupport.value
            : this.needsHousingSupport,
        quranMemorization: quranMemorization.present
            ? quranMemorization.value
            : this.quranMemorization,
        attendsIslamicSchool: attendsIslamicSchool.present
            ? attendsIslamicSchool.value
            : this.attendsIslamicSchool,
        islamicEducationLevel: islamicEducationLevel.present
            ? islamicEducationLevel.value
            : this.islamicEducationLevel,
        hobbies: hobbies.present ? hobbies.value : this.hobbies,
        skills: skills.present ? skills.value : this.skills,
        aspirations: aspirations.present ? aspirations.value : this.aspirations,
        numberOfSiblings: numberOfSiblings.present
            ? numberOfSiblings.value
            : this.numberOfSiblings,
        siblingsDetails: siblingsDetails.present
            ? siblingsDetails.value
            : this.siblingsDetails,
        additionalNotes: additionalNotes.present
            ? additionalNotes.value
            : this.additionalNotes,
        urgentNeeds: urgentNeeds.present ? urgentNeeds.value : this.urgentNeeds,
        specialCircumstances: specialCircumstances.present
            ? specialCircumstances.value
            : this.specialCircumstances,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        documentsPath:
            documentsPath.present ? documentsPath.value : this.documentsPath,
      );
  Orphan copyWithCompanion(OrphansCompanion data) {
    return Orphan(
      orphanId: data.orphanId.present ? data.orphanId.value : this.orphanId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      familyName:
          data.familyName.present ? data.familyName.value : this.familyName,
      gender: data.gender.present ? data.gender.value : this.gender,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      placeOfBirth: data.placeOfBirth.present
          ? data.placeOfBirth.value
          : this.placeOfBirth,
      nationality:
          data.nationality.present ? data.nationality.value : this.nationality,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      status: data.status.present ? data.status.value : this.status,
      lastSeenLocation: data.lastSeenLocation.present
          ? data.lastSeenLocation.value
          : this.lastSeenLocation,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      currentCountry: data.currentCountry.present
          ? data.currentCountry.value
          : this.currentCountry,
      currentGovernorate: data.currentGovernorate.present
          ? data.currentGovernorate.value
          : this.currentGovernorate,
      currentCity:
          data.currentCity.present ? data.currentCity.value : this.currentCity,
      currentNeighborhood: data.currentNeighborhood.present
          ? data.currentNeighborhood.value
          : this.currentNeighborhood,
      currentCamp:
          data.currentCamp.present ? data.currentCamp.value : this.currentCamp,
      currentStreet: data.currentStreet.present
          ? data.currentStreet.value
          : this.currentStreet,
      currentPhoneNumber: data.currentPhoneNumber.present
          ? data.currentPhoneNumber.value
          : this.currentPhoneNumber,
      fatherFirstName: data.fatherFirstName.present
          ? data.fatherFirstName.value
          : this.fatherFirstName,
      fatherLastName: data.fatherLastName.present
          ? data.fatherLastName.value
          : this.fatherLastName,
      fatherDateOfBirth: data.fatherDateOfBirth.present
          ? data.fatherDateOfBirth.value
          : this.fatherDateOfBirth,
      fatherDateOfDeath: data.fatherDateOfDeath.present
          ? data.fatherDateOfDeath.value
          : this.fatherDateOfDeath,
      fatherCauseOfDeath: data.fatherCauseOfDeath.present
          ? data.fatherCauseOfDeath.value
          : this.fatherCauseOfDeath,
      fatherAlive:
          data.fatherAlive.present ? data.fatherAlive.value : this.fatherAlive,
      fatherEducationLevel: data.fatherEducationLevel.present
          ? data.fatherEducationLevel.value
          : this.fatherEducationLevel,
      fatherWork:
          data.fatherWork.present ? data.fatherWork.value : this.fatherWork,
      fatherMonthlyIncome: data.fatherMonthlyIncome.present
          ? data.fatherMonthlyIncome.value
          : this.fatherMonthlyIncome,
      fatherNumberOfWives: data.fatherNumberOfWives.present
          ? data.fatherNumberOfWives.value
          : this.fatherNumberOfWives,
      fatherNumberOfChildren: data.fatherNumberOfChildren.present
          ? data.fatherNumberOfChildren.value
          : this.fatherNumberOfChildren,
      motherFirstName: data.motherFirstName.present
          ? data.motherFirstName.value
          : this.motherFirstName,
      motherLastName: data.motherLastName.present
          ? data.motherLastName.value
          : this.motherLastName,
      motherDateOfBirth: data.motherDateOfBirth.present
          ? data.motherDateOfBirth.value
          : this.motherDateOfBirth,
      motherDateOfDeath: data.motherDateOfDeath.present
          ? data.motherDateOfDeath.value
          : this.motherDateOfDeath,
      motherCauseOfDeath: data.motherCauseOfDeath.present
          ? data.motherCauseOfDeath.value
          : this.motherCauseOfDeath,
      motherAlive:
          data.motherAlive.present ? data.motherAlive.value : this.motherAlive,
      motherEducationLevel: data.motherEducationLevel.present
          ? data.motherEducationLevel.value
          : this.motherEducationLevel,
      motherWork:
          data.motherWork.present ? data.motherWork.value : this.motherWork,
      motherMonthlyIncome: data.motherMonthlyIncome.present
          ? data.motherMonthlyIncome.value
          : this.motherMonthlyIncome,
      motherRemarried: data.motherRemarried.present
          ? data.motherRemarried.value
          : this.motherRemarried,
      motherNeedsSupport: data.motherNeedsSupport.present
          ? data.motherNeedsSupport.value
          : this.motherNeedsSupport,
      guardianName: data.guardianName.present
          ? data.guardianName.value
          : this.guardianName,
      guardianRelationship: data.guardianRelationship.present
          ? data.guardianRelationship.value
          : this.guardianRelationship,
      guardianEducationLevel: data.guardianEducationLevel.present
          ? data.guardianEducationLevel.value
          : this.guardianEducationLevel,
      guardianWork: data.guardianWork.present
          ? data.guardianWork.value
          : this.guardianWork,
      guardianNumberOfDependents: data.guardianNumberOfDependents.present
          ? data.guardianNumberOfDependents.value
          : this.guardianNumberOfDependents,
      guardianMonthlyIncome: data.guardianMonthlyIncome.present
          ? data.guardianMonthlyIncome.value
          : this.guardianMonthlyIncome,
      educationLevel: data.educationLevel.present
          ? data.educationLevel.value
          : this.educationLevel,
      schoolName:
          data.schoolName.present ? data.schoolName.value : this.schoolName,
      educationAddress: data.educationAddress.present
          ? data.educationAddress.value
          : this.educationAddress,
      educationCosts: data.educationCosts.present
          ? data.educationCosts.value
          : this.educationCosts,
      studyYear: data.studyYear.present ? data.studyYear.value : this.studyYear,
      grade: data.grade.present ? data.grade.value : this.grade,
      educationStage: data.educationStage.present
          ? data.educationStage.value
          : this.educationStage,
      studyType: data.studyType.present ? data.studyType.value : this.studyType,
      educationAchievement: data.educationAchievement.present
          ? data.educationAchievement.value
          : this.educationAchievement,
      lastStudyResult: data.lastStudyResult.present
          ? data.lastStudyResult.value
          : this.lastStudyResult,
      weakSubjects: data.weakSubjects.present
          ? data.weakSubjects.value
          : this.weakSubjects,
      strongSubjects: data.strongSubjects.present
          ? data.strongSubjects.value
          : this.strongSubjects,
      studyImprovementActions: data.studyImprovementActions.present
          ? data.studyImprovementActions.value
          : this.studyImprovementActions,
      reasonForNotStudying: data.reasonForNotStudying.present
          ? data.reasonForNotStudying.value
          : this.reasonForNotStudying,
      stoppedStudying: data.stoppedStudying.present
          ? data.stoppedStudying.value
          : this.stoppedStudying,
      reasonForStoppingStufy: data.reasonForStoppingStufy.present
          ? data.reasonForStoppingStufy.value
          : this.reasonForStoppingStufy,
      healthStatus: data.healthStatus.present
          ? data.healthStatus.value
          : this.healthStatus,
      psychologicalStatus: data.psychologicalStatus.present
          ? data.psychologicalStatus.value
          : this.psychologicalStatus,
      behavioralStatus: data.behavioralStatus.present
          ? data.behavioralStatus.value
          : this.behavioralStatus,
      nutritionalStatus: data.nutritionalStatus.present
          ? data.nutritionalStatus.value
          : this.nutritionalStatus,
      disabilityType: data.disabilityType.present
          ? data.disabilityType.value
          : this.disabilityType,
      disabilityLevel: data.disabilityLevel.present
          ? data.disabilityLevel.value
          : this.disabilityLevel,
      medicalConditions: data.medicalConditions.present
          ? data.medicalConditions.value
          : this.medicalConditions,
      medications:
          data.medications.present ? data.medications.value : this.medications,
      needsMedicalSupport: data.needsMedicalSupport.present
          ? data.needsMedicalSupport.value
          : this.needsMedicalSupport,
      accommodationType: data.accommodationType.present
          ? data.accommodationType.value
          : this.accommodationType,
      accommodationAddress: data.accommodationAddress.present
          ? data.accommodationAddress.value
          : this.accommodationAddress,
      accommodationCondition: data.accommodationCondition.present
          ? data.accommodationCondition.value
          : this.accommodationCondition,
      accommodationOwnership: data.accommodationOwnership.present
          ? data.accommodationOwnership.value
          : this.accommodationOwnership,
      needsHousingSupport: data.needsHousingSupport.present
          ? data.needsHousingSupport.value
          : this.needsHousingSupport,
      quranMemorization: data.quranMemorization.present
          ? data.quranMemorization.value
          : this.quranMemorization,
      attendsIslamicSchool: data.attendsIslamicSchool.present
          ? data.attendsIslamicSchool.value
          : this.attendsIslamicSchool,
      islamicEducationLevel: data.islamicEducationLevel.present
          ? data.islamicEducationLevel.value
          : this.islamicEducationLevel,
      hobbies: data.hobbies.present ? data.hobbies.value : this.hobbies,
      skills: data.skills.present ? data.skills.value : this.skills,
      aspirations:
          data.aspirations.present ? data.aspirations.value : this.aspirations,
      numberOfSiblings: data.numberOfSiblings.present
          ? data.numberOfSiblings.value
          : this.numberOfSiblings,
      siblingsDetails: data.siblingsDetails.present
          ? data.siblingsDetails.value
          : this.siblingsDetails,
      additionalNotes: data.additionalNotes.present
          ? data.additionalNotes.value
          : this.additionalNotes,
      urgentNeeds:
          data.urgentNeeds.present ? data.urgentNeeds.value : this.urgentNeeds,
      specialCircumstances: data.specialCircumstances.present
          ? data.specialCircumstances.value
          : this.specialCircumstances,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      documentsPath: data.documentsPath.present
          ? data.documentsPath.value
          : this.documentsPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Orphan(')
          ..write('orphanId: $orphanId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('familyName: $familyName, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('status: $status, ')
          ..write('lastSeenLocation: $lastSeenLocation, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('currentCountry: $currentCountry, ')
          ..write('currentGovernorate: $currentGovernorate, ')
          ..write('currentCity: $currentCity, ')
          ..write('currentNeighborhood: $currentNeighborhood, ')
          ..write('currentCamp: $currentCamp, ')
          ..write('currentStreet: $currentStreet, ')
          ..write('currentPhoneNumber: $currentPhoneNumber, ')
          ..write('fatherFirstName: $fatherFirstName, ')
          ..write('fatherLastName: $fatherLastName, ')
          ..write('fatherDateOfBirth: $fatherDateOfBirth, ')
          ..write('fatherDateOfDeath: $fatherDateOfDeath, ')
          ..write('fatherCauseOfDeath: $fatherCauseOfDeath, ')
          ..write('fatherAlive: $fatherAlive, ')
          ..write('fatherEducationLevel: $fatherEducationLevel, ')
          ..write('fatherWork: $fatherWork, ')
          ..write('fatherMonthlyIncome: $fatherMonthlyIncome, ')
          ..write('fatherNumberOfWives: $fatherNumberOfWives, ')
          ..write('fatherNumberOfChildren: $fatherNumberOfChildren, ')
          ..write('motherFirstName: $motherFirstName, ')
          ..write('motherLastName: $motherLastName, ')
          ..write('motherDateOfBirth: $motherDateOfBirth, ')
          ..write('motherDateOfDeath: $motherDateOfDeath, ')
          ..write('motherCauseOfDeath: $motherCauseOfDeath, ')
          ..write('motherAlive: $motherAlive, ')
          ..write('motherEducationLevel: $motherEducationLevel, ')
          ..write('motherWork: $motherWork, ')
          ..write('motherMonthlyIncome: $motherMonthlyIncome, ')
          ..write('motherRemarried: $motherRemarried, ')
          ..write('motherNeedsSupport: $motherNeedsSupport, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianRelationship: $guardianRelationship, ')
          ..write('guardianEducationLevel: $guardianEducationLevel, ')
          ..write('guardianWork: $guardianWork, ')
          ..write('guardianNumberOfDependents: $guardianNumberOfDependents, ')
          ..write('guardianMonthlyIncome: $guardianMonthlyIncome, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('schoolName: $schoolName, ')
          ..write('educationAddress: $educationAddress, ')
          ..write('educationCosts: $educationCosts, ')
          ..write('studyYear: $studyYear, ')
          ..write('grade: $grade, ')
          ..write('educationStage: $educationStage, ')
          ..write('studyType: $studyType, ')
          ..write('educationAchievement: $educationAchievement, ')
          ..write('lastStudyResult: $lastStudyResult, ')
          ..write('weakSubjects: $weakSubjects, ')
          ..write('strongSubjects: $strongSubjects, ')
          ..write('studyImprovementActions: $studyImprovementActions, ')
          ..write('reasonForNotStudying: $reasonForNotStudying, ')
          ..write('stoppedStudying: $stoppedStudying, ')
          ..write('reasonForStoppingStufy: $reasonForStoppingStufy, ')
          ..write('healthStatus: $healthStatus, ')
          ..write('psychologicalStatus: $psychologicalStatus, ')
          ..write('behavioralStatus: $behavioralStatus, ')
          ..write('nutritionalStatus: $nutritionalStatus, ')
          ..write('disabilityType: $disabilityType, ')
          ..write('disabilityLevel: $disabilityLevel, ')
          ..write('medicalConditions: $medicalConditions, ')
          ..write('medications: $medications, ')
          ..write('needsMedicalSupport: $needsMedicalSupport, ')
          ..write('accommodationType: $accommodationType, ')
          ..write('accommodationAddress: $accommodationAddress, ')
          ..write('accommodationCondition: $accommodationCondition, ')
          ..write('accommodationOwnership: $accommodationOwnership, ')
          ..write('needsHousingSupport: $needsHousingSupport, ')
          ..write('quranMemorization: $quranMemorization, ')
          ..write('attendsIslamicSchool: $attendsIslamicSchool, ')
          ..write('islamicEducationLevel: $islamicEducationLevel, ')
          ..write('hobbies: $hobbies, ')
          ..write('skills: $skills, ')
          ..write('aspirations: $aspirations, ')
          ..write('numberOfSiblings: $numberOfSiblings, ')
          ..write('siblingsDetails: $siblingsDetails, ')
          ..write('additionalNotes: $additionalNotes, ')
          ..write('urgentNeeds: $urgentNeeds, ')
          ..write('specialCircumstances: $specialCircumstances, ')
          ..write('photoPath: $photoPath, ')
          ..write('documentsPath: $documentsPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        orphanId,
        firstName,
        lastName,
        familyName,
        gender,
        dateOfBirth,
        placeOfBirth,
        nationality,
        idNumber,
        status,
        lastSeenLocation,
        lastUpdated,
        supervisorId,
        currentCountry,
        currentGovernorate,
        currentCity,
        currentNeighborhood,
        currentCamp,
        currentStreet,
        currentPhoneNumber,
        fatherFirstName,
        fatherLastName,
        fatherDateOfBirth,
        fatherDateOfDeath,
        fatherCauseOfDeath,
        fatherAlive,
        fatherEducationLevel,
        fatherWork,
        fatherMonthlyIncome,
        fatherNumberOfWives,
        fatherNumberOfChildren,
        motherFirstName,
        motherLastName,
        motherDateOfBirth,
        motherDateOfDeath,
        motherCauseOfDeath,
        motherAlive,
        motherEducationLevel,
        motherWork,
        motherMonthlyIncome,
        motherRemarried,
        motherNeedsSupport,
        guardianName,
        guardianRelationship,
        guardianEducationLevel,
        guardianWork,
        guardianNumberOfDependents,
        guardianMonthlyIncome,
        educationLevel,
        schoolName,
        educationAddress,
        educationCosts,
        studyYear,
        grade,
        educationStage,
        studyType,
        educationAchievement,
        lastStudyResult,
        weakSubjects,
        strongSubjects,
        studyImprovementActions,
        reasonForNotStudying,
        stoppedStudying,
        reasonForStoppingStufy,
        healthStatus,
        psychologicalStatus,
        behavioralStatus,
        nutritionalStatus,
        disabilityType,
        disabilityLevel,
        medicalConditions,
        medications,
        needsMedicalSupport,
        accommodationType,
        accommodationAddress,
        accommodationCondition,
        accommodationOwnership,
        needsHousingSupport,
        quranMemorization,
        attendsIslamicSchool,
        islamicEducationLevel,
        hobbies,
        skills,
        aspirations,
        numberOfSiblings,
        siblingsDetails,
        additionalNotes,
        urgentNeeds,
        specialCircumstances,
        photoPath,
        documentsPath
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Orphan &&
          other.orphanId == this.orphanId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.familyName == this.familyName &&
          other.gender == this.gender &&
          other.dateOfBirth == this.dateOfBirth &&
          other.placeOfBirth == this.placeOfBirth &&
          other.nationality == this.nationality &&
          other.idNumber == this.idNumber &&
          other.status == this.status &&
          other.lastSeenLocation == this.lastSeenLocation &&
          other.lastUpdated == this.lastUpdated &&
          other.supervisorId == this.supervisorId &&
          other.currentCountry == this.currentCountry &&
          other.currentGovernorate == this.currentGovernorate &&
          other.currentCity == this.currentCity &&
          other.currentNeighborhood == this.currentNeighborhood &&
          other.currentCamp == this.currentCamp &&
          other.currentStreet == this.currentStreet &&
          other.currentPhoneNumber == this.currentPhoneNumber &&
          other.fatherFirstName == this.fatherFirstName &&
          other.fatherLastName == this.fatherLastName &&
          other.fatherDateOfBirth == this.fatherDateOfBirth &&
          other.fatherDateOfDeath == this.fatherDateOfDeath &&
          other.fatherCauseOfDeath == this.fatherCauseOfDeath &&
          other.fatherAlive == this.fatherAlive &&
          other.fatherEducationLevel == this.fatherEducationLevel &&
          other.fatherWork == this.fatherWork &&
          other.fatherMonthlyIncome == this.fatherMonthlyIncome &&
          other.fatherNumberOfWives == this.fatherNumberOfWives &&
          other.fatherNumberOfChildren == this.fatherNumberOfChildren &&
          other.motherFirstName == this.motherFirstName &&
          other.motherLastName == this.motherLastName &&
          other.motherDateOfBirth == this.motherDateOfBirth &&
          other.motherDateOfDeath == this.motherDateOfDeath &&
          other.motherCauseOfDeath == this.motherCauseOfDeath &&
          other.motherAlive == this.motherAlive &&
          other.motherEducationLevel == this.motherEducationLevel &&
          other.motherWork == this.motherWork &&
          other.motherMonthlyIncome == this.motherMonthlyIncome &&
          other.motherRemarried == this.motherRemarried &&
          other.motherNeedsSupport == this.motherNeedsSupport &&
          other.guardianName == this.guardianName &&
          other.guardianRelationship == this.guardianRelationship &&
          other.guardianEducationLevel == this.guardianEducationLevel &&
          other.guardianWork == this.guardianWork &&
          other.guardianNumberOfDependents == this.guardianNumberOfDependents &&
          other.guardianMonthlyIncome == this.guardianMonthlyIncome &&
          other.educationLevel == this.educationLevel &&
          other.schoolName == this.schoolName &&
          other.educationAddress == this.educationAddress &&
          other.educationCosts == this.educationCosts &&
          other.studyYear == this.studyYear &&
          other.grade == this.grade &&
          other.educationStage == this.educationStage &&
          other.studyType == this.studyType &&
          other.educationAchievement == this.educationAchievement &&
          other.lastStudyResult == this.lastStudyResult &&
          other.weakSubjects == this.weakSubjects &&
          other.strongSubjects == this.strongSubjects &&
          other.studyImprovementActions == this.studyImprovementActions &&
          other.reasonForNotStudying == this.reasonForNotStudying &&
          other.stoppedStudying == this.stoppedStudying &&
          other.reasonForStoppingStufy == this.reasonForStoppingStufy &&
          other.healthStatus == this.healthStatus &&
          other.psychologicalStatus == this.psychologicalStatus &&
          other.behavioralStatus == this.behavioralStatus &&
          other.nutritionalStatus == this.nutritionalStatus &&
          other.disabilityType == this.disabilityType &&
          other.disabilityLevel == this.disabilityLevel &&
          other.medicalConditions == this.medicalConditions &&
          other.medications == this.medications &&
          other.needsMedicalSupport == this.needsMedicalSupport &&
          other.accommodationType == this.accommodationType &&
          other.accommodationAddress == this.accommodationAddress &&
          other.accommodationCondition == this.accommodationCondition &&
          other.accommodationOwnership == this.accommodationOwnership &&
          other.needsHousingSupport == this.needsHousingSupport &&
          other.quranMemorization == this.quranMemorization &&
          other.attendsIslamicSchool == this.attendsIslamicSchool &&
          other.islamicEducationLevel == this.islamicEducationLevel &&
          other.hobbies == this.hobbies &&
          other.skills == this.skills &&
          other.aspirations == this.aspirations &&
          other.numberOfSiblings == this.numberOfSiblings &&
          other.siblingsDetails == this.siblingsDetails &&
          other.additionalNotes == this.additionalNotes &&
          other.urgentNeeds == this.urgentNeeds &&
          other.specialCircumstances == this.specialCircumstances &&
          other.photoPath == this.photoPath &&
          other.documentsPath == this.documentsPath);
}

class OrphansCompanion extends UpdateCompanion<Orphan> {
  final Value<String> orphanId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> familyName;
  final Value<Gender> gender;
  final Value<DateTime> dateOfBirth;
  final Value<String?> placeOfBirth;
  final Value<String?> nationality;
  final Value<String?> idNumber;
  final Value<OrphanStatus> status;
  final Value<String?> lastSeenLocation;
  final Value<DateTime> lastUpdated;
  final Value<String> supervisorId;
  final Value<String?> currentCountry;
  final Value<String?> currentGovernorate;
  final Value<String?> currentCity;
  final Value<String?> currentNeighborhood;
  final Value<String?> currentCamp;
  final Value<String?> currentStreet;
  final Value<String?> currentPhoneNumber;
  final Value<String?> fatherFirstName;
  final Value<String?> fatherLastName;
  final Value<DateTime?> fatherDateOfBirth;
  final Value<DateTime?> fatherDateOfDeath;
  final Value<String?> fatherCauseOfDeath;
  final Value<bool?> fatherAlive;
  final Value<String?> fatherEducationLevel;
  final Value<String?> fatherWork;
  final Value<String?> fatherMonthlyIncome;
  final Value<int?> fatherNumberOfWives;
  final Value<int?> fatherNumberOfChildren;
  final Value<String?> motherFirstName;
  final Value<String?> motherLastName;
  final Value<DateTime?> motherDateOfBirth;
  final Value<DateTime?> motherDateOfDeath;
  final Value<String?> motherCauseOfDeath;
  final Value<bool?> motherAlive;
  final Value<String?> motherEducationLevel;
  final Value<String?> motherWork;
  final Value<String?> motherMonthlyIncome;
  final Value<bool?> motherRemarried;
  final Value<bool?> motherNeedsSupport;
  final Value<String?> guardianName;
  final Value<String?> guardianRelationship;
  final Value<String?> guardianEducationLevel;
  final Value<String?> guardianWork;
  final Value<int?> guardianNumberOfDependents;
  final Value<String?> guardianMonthlyIncome;
  final Value<EducationLevel?> educationLevel;
  final Value<String?> schoolName;
  final Value<String?> educationAddress;
  final Value<String?> educationCosts;
  final Value<String?> studyYear;
  final Value<String?> grade;
  final Value<String?> educationStage;
  final Value<String?> studyType;
  final Value<String?> educationAchievement;
  final Value<String?> lastStudyResult;
  final Value<String?> weakSubjects;
  final Value<String?> strongSubjects;
  final Value<String?> studyImprovementActions;
  final Value<String?> reasonForNotStudying;
  final Value<bool?> stoppedStudying;
  final Value<String?> reasonForStoppingStufy;
  final Value<HealthStatus?> healthStatus;
  final Value<PsychologicalStatus?> psychologicalStatus;
  final Value<PsychologicalStatus?> behavioralStatus;
  final Value<String?> nutritionalStatus;
  final Value<String?> disabilityType;
  final Value<DisabilityType?> disabilityLevel;
  final Value<String?> medicalConditions;
  final Value<String?> medications;
  final Value<bool?> needsMedicalSupport;
  final Value<AccommodationType?> accommodationType;
  final Value<String?> accommodationAddress;
  final Value<String?> accommodationCondition;
  final Value<String?> accommodationOwnership;
  final Value<bool?> needsHousingSupport;
  final Value<String?> quranMemorization;
  final Value<bool?> attendsIslamicSchool;
  final Value<String?> islamicEducationLevel;
  final Value<String?> hobbies;
  final Value<String?> skills;
  final Value<String?> aspirations;
  final Value<int?> numberOfSiblings;
  final Value<String?> siblingsDetails;
  final Value<String?> additionalNotes;
  final Value<String?> urgentNeeds;
  final Value<String?> specialCircumstances;
  final Value<String?> photoPath;
  final Value<String?> documentsPath;
  final Value<int> rowid;
  const OrphansCompanion({
    this.orphanId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.familyName = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.lastSeenLocation = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.currentCountry = const Value.absent(),
    this.currentGovernorate = const Value.absent(),
    this.currentCity = const Value.absent(),
    this.currentNeighborhood = const Value.absent(),
    this.currentCamp = const Value.absent(),
    this.currentStreet = const Value.absent(),
    this.currentPhoneNumber = const Value.absent(),
    this.fatherFirstName = const Value.absent(),
    this.fatherLastName = const Value.absent(),
    this.fatherDateOfBirth = const Value.absent(),
    this.fatherDateOfDeath = const Value.absent(),
    this.fatherCauseOfDeath = const Value.absent(),
    this.fatherAlive = const Value.absent(),
    this.fatherEducationLevel = const Value.absent(),
    this.fatherWork = const Value.absent(),
    this.fatherMonthlyIncome = const Value.absent(),
    this.fatherNumberOfWives = const Value.absent(),
    this.fatherNumberOfChildren = const Value.absent(),
    this.motherFirstName = const Value.absent(),
    this.motherLastName = const Value.absent(),
    this.motherDateOfBirth = const Value.absent(),
    this.motherDateOfDeath = const Value.absent(),
    this.motherCauseOfDeath = const Value.absent(),
    this.motherAlive = const Value.absent(),
    this.motherEducationLevel = const Value.absent(),
    this.motherWork = const Value.absent(),
    this.motherMonthlyIncome = const Value.absent(),
    this.motherRemarried = const Value.absent(),
    this.motherNeedsSupport = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.guardianRelationship = const Value.absent(),
    this.guardianEducationLevel = const Value.absent(),
    this.guardianWork = const Value.absent(),
    this.guardianNumberOfDependents = const Value.absent(),
    this.guardianMonthlyIncome = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.schoolName = const Value.absent(),
    this.educationAddress = const Value.absent(),
    this.educationCosts = const Value.absent(),
    this.studyYear = const Value.absent(),
    this.grade = const Value.absent(),
    this.educationStage = const Value.absent(),
    this.studyType = const Value.absent(),
    this.educationAchievement = const Value.absent(),
    this.lastStudyResult = const Value.absent(),
    this.weakSubjects = const Value.absent(),
    this.strongSubjects = const Value.absent(),
    this.studyImprovementActions = const Value.absent(),
    this.reasonForNotStudying = const Value.absent(),
    this.stoppedStudying = const Value.absent(),
    this.reasonForStoppingStufy = const Value.absent(),
    this.healthStatus = const Value.absent(),
    this.psychologicalStatus = const Value.absent(),
    this.behavioralStatus = const Value.absent(),
    this.nutritionalStatus = const Value.absent(),
    this.disabilityType = const Value.absent(),
    this.disabilityLevel = const Value.absent(),
    this.medicalConditions = const Value.absent(),
    this.medications = const Value.absent(),
    this.needsMedicalSupport = const Value.absent(),
    this.accommodationType = const Value.absent(),
    this.accommodationAddress = const Value.absent(),
    this.accommodationCondition = const Value.absent(),
    this.accommodationOwnership = const Value.absent(),
    this.needsHousingSupport = const Value.absent(),
    this.quranMemorization = const Value.absent(),
    this.attendsIslamicSchool = const Value.absent(),
    this.islamicEducationLevel = const Value.absent(),
    this.hobbies = const Value.absent(),
    this.skills = const Value.absent(),
    this.aspirations = const Value.absent(),
    this.numberOfSiblings = const Value.absent(),
    this.siblingsDetails = const Value.absent(),
    this.additionalNotes = const Value.absent(),
    this.urgentNeeds = const Value.absent(),
    this.specialCircumstances = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.documentsPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrphansCompanion.insert({
    this.orphanId = const Value.absent(),
    required String firstName,
    required String lastName,
    required String familyName,
    required Gender gender,
    required DateTime dateOfBirth,
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    required OrphanStatus status,
    this.lastSeenLocation = const Value.absent(),
    required DateTime lastUpdated,
    required String supervisorId,
    this.currentCountry = const Value.absent(),
    this.currentGovernorate = const Value.absent(),
    this.currentCity = const Value.absent(),
    this.currentNeighborhood = const Value.absent(),
    this.currentCamp = const Value.absent(),
    this.currentStreet = const Value.absent(),
    this.currentPhoneNumber = const Value.absent(),
    this.fatherFirstName = const Value.absent(),
    this.fatherLastName = const Value.absent(),
    this.fatherDateOfBirth = const Value.absent(),
    this.fatherDateOfDeath = const Value.absent(),
    this.fatherCauseOfDeath = const Value.absent(),
    this.fatherAlive = const Value.absent(),
    this.fatherEducationLevel = const Value.absent(),
    this.fatherWork = const Value.absent(),
    this.fatherMonthlyIncome = const Value.absent(),
    this.fatherNumberOfWives = const Value.absent(),
    this.fatherNumberOfChildren = const Value.absent(),
    this.motherFirstName = const Value.absent(),
    this.motherLastName = const Value.absent(),
    this.motherDateOfBirth = const Value.absent(),
    this.motherDateOfDeath = const Value.absent(),
    this.motherCauseOfDeath = const Value.absent(),
    this.motherAlive = const Value.absent(),
    this.motherEducationLevel = const Value.absent(),
    this.motherWork = const Value.absent(),
    this.motherMonthlyIncome = const Value.absent(),
    this.motherRemarried = const Value.absent(),
    this.motherNeedsSupport = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.guardianRelationship = const Value.absent(),
    this.guardianEducationLevel = const Value.absent(),
    this.guardianWork = const Value.absent(),
    this.guardianNumberOfDependents = const Value.absent(),
    this.guardianMonthlyIncome = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.schoolName = const Value.absent(),
    this.educationAddress = const Value.absent(),
    this.educationCosts = const Value.absent(),
    this.studyYear = const Value.absent(),
    this.grade = const Value.absent(),
    this.educationStage = const Value.absent(),
    this.studyType = const Value.absent(),
    this.educationAchievement = const Value.absent(),
    this.lastStudyResult = const Value.absent(),
    this.weakSubjects = const Value.absent(),
    this.strongSubjects = const Value.absent(),
    this.studyImprovementActions = const Value.absent(),
    this.reasonForNotStudying = const Value.absent(),
    this.stoppedStudying = const Value.absent(),
    this.reasonForStoppingStufy = const Value.absent(),
    this.healthStatus = const Value.absent(),
    this.psychologicalStatus = const Value.absent(),
    this.behavioralStatus = const Value.absent(),
    this.nutritionalStatus = const Value.absent(),
    this.disabilityType = const Value.absent(),
    this.disabilityLevel = const Value.absent(),
    this.medicalConditions = const Value.absent(),
    this.medications = const Value.absent(),
    this.needsMedicalSupport = const Value.absent(),
    this.accommodationType = const Value.absent(),
    this.accommodationAddress = const Value.absent(),
    this.accommodationCondition = const Value.absent(),
    this.accommodationOwnership = const Value.absent(),
    this.needsHousingSupport = const Value.absent(),
    this.quranMemorization = const Value.absent(),
    this.attendsIslamicSchool = const Value.absent(),
    this.islamicEducationLevel = const Value.absent(),
    this.hobbies = const Value.absent(),
    this.skills = const Value.absent(),
    this.aspirations = const Value.absent(),
    this.numberOfSiblings = const Value.absent(),
    this.siblingsDetails = const Value.absent(),
    this.additionalNotes = const Value.absent(),
    this.urgentNeeds = const Value.absent(),
    this.specialCircumstances = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.documentsPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        familyName = Value(familyName),
        gender = Value(gender),
        dateOfBirth = Value(dateOfBirth),
        status = Value(status),
        lastUpdated = Value(lastUpdated),
        supervisorId = Value(supervisorId);
  static Insertable<Orphan> custom({
    Expression<String>? orphanId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? familyName,
    Expression<int>? gender,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? placeOfBirth,
    Expression<String>? nationality,
    Expression<String>? idNumber,
    Expression<int>? status,
    Expression<String>? lastSeenLocation,
    Expression<DateTime>? lastUpdated,
    Expression<String>? supervisorId,
    Expression<String>? currentCountry,
    Expression<String>? currentGovernorate,
    Expression<String>? currentCity,
    Expression<String>? currentNeighborhood,
    Expression<String>? currentCamp,
    Expression<String>? currentStreet,
    Expression<String>? currentPhoneNumber,
    Expression<String>? fatherFirstName,
    Expression<String>? fatherLastName,
    Expression<DateTime>? fatherDateOfBirth,
    Expression<DateTime>? fatherDateOfDeath,
    Expression<String>? fatherCauseOfDeath,
    Expression<bool>? fatherAlive,
    Expression<String>? fatherEducationLevel,
    Expression<String>? fatherWork,
    Expression<String>? fatherMonthlyIncome,
    Expression<int>? fatherNumberOfWives,
    Expression<int>? fatherNumberOfChildren,
    Expression<String>? motherFirstName,
    Expression<String>? motherLastName,
    Expression<DateTime>? motherDateOfBirth,
    Expression<DateTime>? motherDateOfDeath,
    Expression<String>? motherCauseOfDeath,
    Expression<bool>? motherAlive,
    Expression<String>? motherEducationLevel,
    Expression<String>? motherWork,
    Expression<String>? motherMonthlyIncome,
    Expression<bool>? motherRemarried,
    Expression<bool>? motherNeedsSupport,
    Expression<String>? guardianName,
    Expression<String>? guardianRelationship,
    Expression<String>? guardianEducationLevel,
    Expression<String>? guardianWork,
    Expression<int>? guardianNumberOfDependents,
    Expression<String>? guardianMonthlyIncome,
    Expression<int>? educationLevel,
    Expression<String>? schoolName,
    Expression<String>? educationAddress,
    Expression<String>? educationCosts,
    Expression<String>? studyYear,
    Expression<String>? grade,
    Expression<String>? educationStage,
    Expression<String>? studyType,
    Expression<String>? educationAchievement,
    Expression<String>? lastStudyResult,
    Expression<String>? weakSubjects,
    Expression<String>? strongSubjects,
    Expression<String>? studyImprovementActions,
    Expression<String>? reasonForNotStudying,
    Expression<bool>? stoppedStudying,
    Expression<String>? reasonForStoppingStufy,
    Expression<int>? healthStatus,
    Expression<int>? psychologicalStatus,
    Expression<int>? behavioralStatus,
    Expression<String>? nutritionalStatus,
    Expression<String>? disabilityType,
    Expression<int>? disabilityLevel,
    Expression<String>? medicalConditions,
    Expression<String>? medications,
    Expression<bool>? needsMedicalSupport,
    Expression<int>? accommodationType,
    Expression<String>? accommodationAddress,
    Expression<String>? accommodationCondition,
    Expression<String>? accommodationOwnership,
    Expression<bool>? needsHousingSupport,
    Expression<String>? quranMemorization,
    Expression<bool>? attendsIslamicSchool,
    Expression<String>? islamicEducationLevel,
    Expression<String>? hobbies,
    Expression<String>? skills,
    Expression<String>? aspirations,
    Expression<int>? numberOfSiblings,
    Expression<String>? siblingsDetails,
    Expression<String>? additionalNotes,
    Expression<String>? urgentNeeds,
    Expression<String>? specialCircumstances,
    Expression<String>? photoPath,
    Expression<String>? documentsPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orphanId != null) 'orphan_id': orphanId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (familyName != null) 'family_name': familyName,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (nationality != null) 'nationality': nationality,
      if (idNumber != null) 'id_number': idNumber,
      if (status != null) 'status': status,
      if (lastSeenLocation != null) 'last_seen_location': lastSeenLocation,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (currentCountry != null) 'current_country': currentCountry,
      if (currentGovernorate != null) 'current_governorate': currentGovernorate,
      if (currentCity != null) 'current_city': currentCity,
      if (currentNeighborhood != null)
        'current_neighborhood': currentNeighborhood,
      if (currentCamp != null) 'current_camp': currentCamp,
      if (currentStreet != null) 'current_street': currentStreet,
      if (currentPhoneNumber != null)
        'current_phone_number': currentPhoneNumber,
      if (fatherFirstName != null) 'father_first_name': fatherFirstName,
      if (fatherLastName != null) 'father_last_name': fatherLastName,
      if (fatherDateOfBirth != null) 'father_date_of_birth': fatherDateOfBirth,
      if (fatherDateOfDeath != null) 'father_date_of_death': fatherDateOfDeath,
      if (fatherCauseOfDeath != null)
        'father_cause_of_death': fatherCauseOfDeath,
      if (fatherAlive != null) 'father_alive': fatherAlive,
      if (fatherEducationLevel != null)
        'father_education_level': fatherEducationLevel,
      if (fatherWork != null) 'father_work': fatherWork,
      if (fatherMonthlyIncome != null)
        'father_monthly_income': fatherMonthlyIncome,
      if (fatherNumberOfWives != null)
        'father_number_of_wives': fatherNumberOfWives,
      if (fatherNumberOfChildren != null)
        'father_number_of_children': fatherNumberOfChildren,
      if (motherFirstName != null) 'mother_first_name': motherFirstName,
      if (motherLastName != null) 'mother_last_name': motherLastName,
      if (motherDateOfBirth != null) 'mother_date_of_birth': motherDateOfBirth,
      if (motherDateOfDeath != null) 'mother_date_of_death': motherDateOfDeath,
      if (motherCauseOfDeath != null)
        'mother_cause_of_death': motherCauseOfDeath,
      if (motherAlive != null) 'mother_alive': motherAlive,
      if (motherEducationLevel != null)
        'mother_education_level': motherEducationLevel,
      if (motherWork != null) 'mother_work': motherWork,
      if (motherMonthlyIncome != null)
        'mother_monthly_income': motherMonthlyIncome,
      if (motherRemarried != null) 'mother_remarried': motherRemarried,
      if (motherNeedsSupport != null)
        'mother_needs_support': motherNeedsSupport,
      if (guardianName != null) 'guardian_name': guardianName,
      if (guardianRelationship != null)
        'guardian_relationship': guardianRelationship,
      if (guardianEducationLevel != null)
        'guardian_education_level': guardianEducationLevel,
      if (guardianWork != null) 'guardian_work': guardianWork,
      if (guardianNumberOfDependents != null)
        'guardian_number_of_dependents': guardianNumberOfDependents,
      if (guardianMonthlyIncome != null)
        'guardian_monthly_income': guardianMonthlyIncome,
      if (educationLevel != null) 'education_level': educationLevel,
      if (schoolName != null) 'school_name': schoolName,
      if (educationAddress != null) 'education_address': educationAddress,
      if (educationCosts != null) 'education_costs': educationCosts,
      if (studyYear != null) 'study_year': studyYear,
      if (grade != null) 'grade': grade,
      if (educationStage != null) 'education_stage': educationStage,
      if (studyType != null) 'study_type': studyType,
      if (educationAchievement != null)
        'education_achievement': educationAchievement,
      if (lastStudyResult != null) 'last_study_result': lastStudyResult,
      if (weakSubjects != null) 'weak_subjects': weakSubjects,
      if (strongSubjects != null) 'strong_subjects': strongSubjects,
      if (studyImprovementActions != null)
        'study_improvement_actions': studyImprovementActions,
      if (reasonForNotStudying != null)
        'reason_for_not_studying': reasonForNotStudying,
      if (stoppedStudying != null) 'stopped_studying': stoppedStudying,
      if (reasonForStoppingStufy != null)
        'reason_for_stopping_stufy': reasonForStoppingStufy,
      if (healthStatus != null) 'health_status': healthStatus,
      if (psychologicalStatus != null)
        'psychological_status': psychologicalStatus,
      if (behavioralStatus != null) 'behavioral_status': behavioralStatus,
      if (nutritionalStatus != null) 'nutritional_status': nutritionalStatus,
      if (disabilityType != null) 'disability_type': disabilityType,
      if (disabilityLevel != null) 'disability_level': disabilityLevel,
      if (medicalConditions != null) 'medical_conditions': medicalConditions,
      if (medications != null) 'medications': medications,
      if (needsMedicalSupport != null)
        'needs_medical_support': needsMedicalSupport,
      if (accommodationType != null) 'accommodation_type': accommodationType,
      if (accommodationAddress != null)
        'accommodation_address': accommodationAddress,
      if (accommodationCondition != null)
        'accommodation_condition': accommodationCondition,
      if (accommodationOwnership != null)
        'accommodation_ownership': accommodationOwnership,
      if (needsHousingSupport != null)
        'needs_housing_support': needsHousingSupport,
      if (quranMemorization != null) 'quran_memorization': quranMemorization,
      if (attendsIslamicSchool != null)
        'attends_islamic_school': attendsIslamicSchool,
      if (islamicEducationLevel != null)
        'islamic_education_level': islamicEducationLevel,
      if (hobbies != null) 'hobbies': hobbies,
      if (skills != null) 'skills': skills,
      if (aspirations != null) 'aspirations': aspirations,
      if (numberOfSiblings != null) 'number_of_siblings': numberOfSiblings,
      if (siblingsDetails != null) 'siblings_details': siblingsDetails,
      if (additionalNotes != null) 'additional_notes': additionalNotes,
      if (urgentNeeds != null) 'urgent_needs': urgentNeeds,
      if (specialCircumstances != null)
        'special_circumstances': specialCircumstances,
      if (photoPath != null) 'photo_path': photoPath,
      if (documentsPath != null) 'documents_path': documentsPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrphansCompanion copyWith(
      {Value<String>? orphanId,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String>? familyName,
      Value<Gender>? gender,
      Value<DateTime>? dateOfBirth,
      Value<String?>? placeOfBirth,
      Value<String?>? nationality,
      Value<String?>? idNumber,
      Value<OrphanStatus>? status,
      Value<String?>? lastSeenLocation,
      Value<DateTime>? lastUpdated,
      Value<String>? supervisorId,
      Value<String?>? currentCountry,
      Value<String?>? currentGovernorate,
      Value<String?>? currentCity,
      Value<String?>? currentNeighborhood,
      Value<String?>? currentCamp,
      Value<String?>? currentStreet,
      Value<String?>? currentPhoneNumber,
      Value<String?>? fatherFirstName,
      Value<String?>? fatherLastName,
      Value<DateTime?>? fatherDateOfBirth,
      Value<DateTime?>? fatherDateOfDeath,
      Value<String?>? fatherCauseOfDeath,
      Value<bool?>? fatherAlive,
      Value<String?>? fatherEducationLevel,
      Value<String?>? fatherWork,
      Value<String?>? fatherMonthlyIncome,
      Value<int?>? fatherNumberOfWives,
      Value<int?>? fatherNumberOfChildren,
      Value<String?>? motherFirstName,
      Value<String?>? motherLastName,
      Value<DateTime?>? motherDateOfBirth,
      Value<DateTime?>? motherDateOfDeath,
      Value<String?>? motherCauseOfDeath,
      Value<bool?>? motherAlive,
      Value<String?>? motherEducationLevel,
      Value<String?>? motherWork,
      Value<String?>? motherMonthlyIncome,
      Value<bool?>? motherRemarried,
      Value<bool?>? motherNeedsSupport,
      Value<String?>? guardianName,
      Value<String?>? guardianRelationship,
      Value<String?>? guardianEducationLevel,
      Value<String?>? guardianWork,
      Value<int?>? guardianNumberOfDependents,
      Value<String?>? guardianMonthlyIncome,
      Value<EducationLevel?>? educationLevel,
      Value<String?>? schoolName,
      Value<String?>? educationAddress,
      Value<String?>? educationCosts,
      Value<String?>? studyYear,
      Value<String?>? grade,
      Value<String?>? educationStage,
      Value<String?>? studyType,
      Value<String?>? educationAchievement,
      Value<String?>? lastStudyResult,
      Value<String?>? weakSubjects,
      Value<String?>? strongSubjects,
      Value<String?>? studyImprovementActions,
      Value<String?>? reasonForNotStudying,
      Value<bool?>? stoppedStudying,
      Value<String?>? reasonForStoppingStufy,
      Value<HealthStatus?>? healthStatus,
      Value<PsychologicalStatus?>? psychologicalStatus,
      Value<PsychologicalStatus?>? behavioralStatus,
      Value<String?>? nutritionalStatus,
      Value<String?>? disabilityType,
      Value<DisabilityType?>? disabilityLevel,
      Value<String?>? medicalConditions,
      Value<String?>? medications,
      Value<bool?>? needsMedicalSupport,
      Value<AccommodationType?>? accommodationType,
      Value<String?>? accommodationAddress,
      Value<String?>? accommodationCondition,
      Value<String?>? accommodationOwnership,
      Value<bool?>? needsHousingSupport,
      Value<String?>? quranMemorization,
      Value<bool?>? attendsIslamicSchool,
      Value<String?>? islamicEducationLevel,
      Value<String?>? hobbies,
      Value<String?>? skills,
      Value<String?>? aspirations,
      Value<int?>? numberOfSiblings,
      Value<String?>? siblingsDetails,
      Value<String?>? additionalNotes,
      Value<String?>? urgentNeeds,
      Value<String?>? specialCircumstances,
      Value<String?>? photoPath,
      Value<String?>? documentsPath,
      Value<int>? rowid}) {
    return OrphansCompanion(
      orphanId: orphanId ?? this.orphanId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      familyName: familyName ?? this.familyName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      nationality: nationality ?? this.nationality,
      idNumber: idNumber ?? this.idNumber,
      status: status ?? this.status,
      lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      supervisorId: supervisorId ?? this.supervisorId,
      currentCountry: currentCountry ?? this.currentCountry,
      currentGovernorate: currentGovernorate ?? this.currentGovernorate,
      currentCity: currentCity ?? this.currentCity,
      currentNeighborhood: currentNeighborhood ?? this.currentNeighborhood,
      currentCamp: currentCamp ?? this.currentCamp,
      currentStreet: currentStreet ?? this.currentStreet,
      currentPhoneNumber: currentPhoneNumber ?? this.currentPhoneNumber,
      fatherFirstName: fatherFirstName ?? this.fatherFirstName,
      fatherLastName: fatherLastName ?? this.fatherLastName,
      fatherDateOfBirth: fatherDateOfBirth ?? this.fatherDateOfBirth,
      fatherDateOfDeath: fatherDateOfDeath ?? this.fatherDateOfDeath,
      fatherCauseOfDeath: fatherCauseOfDeath ?? this.fatherCauseOfDeath,
      fatherAlive: fatherAlive ?? this.fatherAlive,
      fatherEducationLevel: fatherEducationLevel ?? this.fatherEducationLevel,
      fatherWork: fatherWork ?? this.fatherWork,
      fatherMonthlyIncome: fatherMonthlyIncome ?? this.fatherMonthlyIncome,
      fatherNumberOfWives: fatherNumberOfWives ?? this.fatherNumberOfWives,
      fatherNumberOfChildren:
          fatherNumberOfChildren ?? this.fatherNumberOfChildren,
      motherFirstName: motherFirstName ?? this.motherFirstName,
      motherLastName: motherLastName ?? this.motherLastName,
      motherDateOfBirth: motherDateOfBirth ?? this.motherDateOfBirth,
      motherDateOfDeath: motherDateOfDeath ?? this.motherDateOfDeath,
      motherCauseOfDeath: motherCauseOfDeath ?? this.motherCauseOfDeath,
      motherAlive: motherAlive ?? this.motherAlive,
      motherEducationLevel: motherEducationLevel ?? this.motherEducationLevel,
      motherWork: motherWork ?? this.motherWork,
      motherMonthlyIncome: motherMonthlyIncome ?? this.motherMonthlyIncome,
      motherRemarried: motherRemarried ?? this.motherRemarried,
      motherNeedsSupport: motherNeedsSupport ?? this.motherNeedsSupport,
      guardianName: guardianName ?? this.guardianName,
      guardianRelationship: guardianRelationship ?? this.guardianRelationship,
      guardianEducationLevel:
          guardianEducationLevel ?? this.guardianEducationLevel,
      guardianWork: guardianWork ?? this.guardianWork,
      guardianNumberOfDependents:
          guardianNumberOfDependents ?? this.guardianNumberOfDependents,
      guardianMonthlyIncome:
          guardianMonthlyIncome ?? this.guardianMonthlyIncome,
      educationLevel: educationLevel ?? this.educationLevel,
      schoolName: schoolName ?? this.schoolName,
      educationAddress: educationAddress ?? this.educationAddress,
      educationCosts: educationCosts ?? this.educationCosts,
      studyYear: studyYear ?? this.studyYear,
      grade: grade ?? this.grade,
      educationStage: educationStage ?? this.educationStage,
      studyType: studyType ?? this.studyType,
      educationAchievement: educationAchievement ?? this.educationAchievement,
      lastStudyResult: lastStudyResult ?? this.lastStudyResult,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      strongSubjects: strongSubjects ?? this.strongSubjects,
      studyImprovementActions:
          studyImprovementActions ?? this.studyImprovementActions,
      reasonForNotStudying: reasonForNotStudying ?? this.reasonForNotStudying,
      stoppedStudying: stoppedStudying ?? this.stoppedStudying,
      reasonForStoppingStufy:
          reasonForStoppingStufy ?? this.reasonForStoppingStufy,
      healthStatus: healthStatus ?? this.healthStatus,
      psychologicalStatus: psychologicalStatus ?? this.psychologicalStatus,
      behavioralStatus: behavioralStatus ?? this.behavioralStatus,
      nutritionalStatus: nutritionalStatus ?? this.nutritionalStatus,
      disabilityType: disabilityType ?? this.disabilityType,
      disabilityLevel: disabilityLevel ?? this.disabilityLevel,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      medications: medications ?? this.medications,
      needsMedicalSupport: needsMedicalSupport ?? this.needsMedicalSupport,
      accommodationType: accommodationType ?? this.accommodationType,
      accommodationAddress: accommodationAddress ?? this.accommodationAddress,
      accommodationCondition:
          accommodationCondition ?? this.accommodationCondition,
      accommodationOwnership:
          accommodationOwnership ?? this.accommodationOwnership,
      needsHousingSupport: needsHousingSupport ?? this.needsHousingSupport,
      quranMemorization: quranMemorization ?? this.quranMemorization,
      attendsIslamicSchool: attendsIslamicSchool ?? this.attendsIslamicSchool,
      islamicEducationLevel:
          islamicEducationLevel ?? this.islamicEducationLevel,
      hobbies: hobbies ?? this.hobbies,
      skills: skills ?? this.skills,
      aspirations: aspirations ?? this.aspirations,
      numberOfSiblings: numberOfSiblings ?? this.numberOfSiblings,
      siblingsDetails: siblingsDetails ?? this.siblingsDetails,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      urgentNeeds: urgentNeeds ?? this.urgentNeeds,
      specialCircumstances: specialCircumstances ?? this.specialCircumstances,
      photoPath: photoPath ?? this.photoPath,
      documentsPath: documentsPath ?? this.documentsPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orphanId.present) {
      map['orphan_id'] = Variable<String>(orphanId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (familyName.present) {
      map['family_name'] = Variable<String>(familyName.value);
    }
    if (gender.present) {
      map['gender'] =
          Variable<int>($OrphansTable.$convertergender.toSql(gender.value));
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($OrphansTable.$converterstatus.toSql(status.value));
    }
    if (lastSeenLocation.present) {
      map['last_seen_location'] = Variable<String>(lastSeenLocation.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (currentCountry.present) {
      map['current_country'] = Variable<String>(currentCountry.value);
    }
    if (currentGovernorate.present) {
      map['current_governorate'] = Variable<String>(currentGovernorate.value);
    }
    if (currentCity.present) {
      map['current_city'] = Variable<String>(currentCity.value);
    }
    if (currentNeighborhood.present) {
      map['current_neighborhood'] = Variable<String>(currentNeighborhood.value);
    }
    if (currentCamp.present) {
      map['current_camp'] = Variable<String>(currentCamp.value);
    }
    if (currentStreet.present) {
      map['current_street'] = Variable<String>(currentStreet.value);
    }
    if (currentPhoneNumber.present) {
      map['current_phone_number'] = Variable<String>(currentPhoneNumber.value);
    }
    if (fatherFirstName.present) {
      map['father_first_name'] = Variable<String>(fatherFirstName.value);
    }
    if (fatherLastName.present) {
      map['father_last_name'] = Variable<String>(fatherLastName.value);
    }
    if (fatherDateOfBirth.present) {
      map['father_date_of_birth'] = Variable<DateTime>(fatherDateOfBirth.value);
    }
    if (fatherDateOfDeath.present) {
      map['father_date_of_death'] = Variable<DateTime>(fatherDateOfDeath.value);
    }
    if (fatherCauseOfDeath.present) {
      map['father_cause_of_death'] = Variable<String>(fatherCauseOfDeath.value);
    }
    if (fatherAlive.present) {
      map['father_alive'] = Variable<bool>(fatherAlive.value);
    }
    if (fatherEducationLevel.present) {
      map['father_education_level'] =
          Variable<String>(fatherEducationLevel.value);
    }
    if (fatherWork.present) {
      map['father_work'] = Variable<String>(fatherWork.value);
    }
    if (fatherMonthlyIncome.present) {
      map['father_monthly_income'] =
          Variable<String>(fatherMonthlyIncome.value);
    }
    if (fatherNumberOfWives.present) {
      map['father_number_of_wives'] = Variable<int>(fatherNumberOfWives.value);
    }
    if (fatherNumberOfChildren.present) {
      map['father_number_of_children'] =
          Variable<int>(fatherNumberOfChildren.value);
    }
    if (motherFirstName.present) {
      map['mother_first_name'] = Variable<String>(motherFirstName.value);
    }
    if (motherLastName.present) {
      map['mother_last_name'] = Variable<String>(motherLastName.value);
    }
    if (motherDateOfBirth.present) {
      map['mother_date_of_birth'] = Variable<DateTime>(motherDateOfBirth.value);
    }
    if (motherDateOfDeath.present) {
      map['mother_date_of_death'] = Variable<DateTime>(motherDateOfDeath.value);
    }
    if (motherCauseOfDeath.present) {
      map['mother_cause_of_death'] = Variable<String>(motherCauseOfDeath.value);
    }
    if (motherAlive.present) {
      map['mother_alive'] = Variable<bool>(motherAlive.value);
    }
    if (motherEducationLevel.present) {
      map['mother_education_level'] =
          Variable<String>(motherEducationLevel.value);
    }
    if (motherWork.present) {
      map['mother_work'] = Variable<String>(motherWork.value);
    }
    if (motherMonthlyIncome.present) {
      map['mother_monthly_income'] =
          Variable<String>(motherMonthlyIncome.value);
    }
    if (motherRemarried.present) {
      map['mother_remarried'] = Variable<bool>(motherRemarried.value);
    }
    if (motherNeedsSupport.present) {
      map['mother_needs_support'] = Variable<bool>(motherNeedsSupport.value);
    }
    if (guardianName.present) {
      map['guardian_name'] = Variable<String>(guardianName.value);
    }
    if (guardianRelationship.present) {
      map['guardian_relationship'] =
          Variable<String>(guardianRelationship.value);
    }
    if (guardianEducationLevel.present) {
      map['guardian_education_level'] =
          Variable<String>(guardianEducationLevel.value);
    }
    if (guardianWork.present) {
      map['guardian_work'] = Variable<String>(guardianWork.value);
    }
    if (guardianNumberOfDependents.present) {
      map['guardian_number_of_dependents'] =
          Variable<int>(guardianNumberOfDependents.value);
    }
    if (guardianMonthlyIncome.present) {
      map['guardian_monthly_income'] =
          Variable<String>(guardianMonthlyIncome.value);
    }
    if (educationLevel.present) {
      map['education_level'] = Variable<int>(
          $OrphansTable.$convertereducationLeveln.toSql(educationLevel.value));
    }
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
    }
    if (educationAddress.present) {
      map['education_address'] = Variable<String>(educationAddress.value);
    }
    if (educationCosts.present) {
      map['education_costs'] = Variable<String>(educationCosts.value);
    }
    if (studyYear.present) {
      map['study_year'] = Variable<String>(studyYear.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (educationStage.present) {
      map['education_stage'] = Variable<String>(educationStage.value);
    }
    if (studyType.present) {
      map['study_type'] = Variable<String>(studyType.value);
    }
    if (educationAchievement.present) {
      map['education_achievement'] =
          Variable<String>(educationAchievement.value);
    }
    if (lastStudyResult.present) {
      map['last_study_result'] = Variable<String>(lastStudyResult.value);
    }
    if (weakSubjects.present) {
      map['weak_subjects'] = Variable<String>(weakSubjects.value);
    }
    if (strongSubjects.present) {
      map['strong_subjects'] = Variable<String>(strongSubjects.value);
    }
    if (studyImprovementActions.present) {
      map['study_improvement_actions'] =
          Variable<String>(studyImprovementActions.value);
    }
    if (reasonForNotStudying.present) {
      map['reason_for_not_studying'] =
          Variable<String>(reasonForNotStudying.value);
    }
    if (stoppedStudying.present) {
      map['stopped_studying'] = Variable<bool>(stoppedStudying.value);
    }
    if (reasonForStoppingStufy.present) {
      map['reason_for_stopping_stufy'] =
          Variable<String>(reasonForStoppingStufy.value);
    }
    if (healthStatus.present) {
      map['health_status'] = Variable<int>(
          $OrphansTable.$converterhealthStatusn.toSql(healthStatus.value));
    }
    if (psychologicalStatus.present) {
      map['psychological_status'] = Variable<int>($OrphansTable
          .$converterpsychologicalStatusn
          .toSql(psychologicalStatus.value));
    }
    if (behavioralStatus.present) {
      map['behavioral_status'] = Variable<int>($OrphansTable
          .$converterbehavioralStatusn
          .toSql(behavioralStatus.value));
    }
    if (nutritionalStatus.present) {
      map['nutritional_status'] = Variable<String>(nutritionalStatus.value);
    }
    if (disabilityType.present) {
      map['disability_type'] = Variable<String>(disabilityType.value);
    }
    if (disabilityLevel.present) {
      map['disability_level'] = Variable<int>($OrphansTable
          .$converterdisabilityLeveln
          .toSql(disabilityLevel.value));
    }
    if (medicalConditions.present) {
      map['medical_conditions'] = Variable<String>(medicalConditions.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (needsMedicalSupport.present) {
      map['needs_medical_support'] = Variable<bool>(needsMedicalSupport.value);
    }
    if (accommodationType.present) {
      map['accommodation_type'] = Variable<int>($OrphansTable
          .$converteraccommodationTypen
          .toSql(accommodationType.value));
    }
    if (accommodationAddress.present) {
      map['accommodation_address'] =
          Variable<String>(accommodationAddress.value);
    }
    if (accommodationCondition.present) {
      map['accommodation_condition'] =
          Variable<String>(accommodationCondition.value);
    }
    if (accommodationOwnership.present) {
      map['accommodation_ownership'] =
          Variable<String>(accommodationOwnership.value);
    }
    if (needsHousingSupport.present) {
      map['needs_housing_support'] = Variable<bool>(needsHousingSupport.value);
    }
    if (quranMemorization.present) {
      map['quran_memorization'] = Variable<String>(quranMemorization.value);
    }
    if (attendsIslamicSchool.present) {
      map['attends_islamic_school'] =
          Variable<bool>(attendsIslamicSchool.value);
    }
    if (islamicEducationLevel.present) {
      map['islamic_education_level'] =
          Variable<String>(islamicEducationLevel.value);
    }
    if (hobbies.present) {
      map['hobbies'] = Variable<String>(hobbies.value);
    }
    if (skills.present) {
      map['skills'] = Variable<String>(skills.value);
    }
    if (aspirations.present) {
      map['aspirations'] = Variable<String>(aspirations.value);
    }
    if (numberOfSiblings.present) {
      map['number_of_siblings'] = Variable<int>(numberOfSiblings.value);
    }
    if (siblingsDetails.present) {
      map['siblings_details'] = Variable<String>(siblingsDetails.value);
    }
    if (additionalNotes.present) {
      map['additional_notes'] = Variable<String>(additionalNotes.value);
    }
    if (urgentNeeds.present) {
      map['urgent_needs'] = Variable<String>(urgentNeeds.value);
    }
    if (specialCircumstances.present) {
      map['special_circumstances'] =
          Variable<String>(specialCircumstances.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (documentsPath.present) {
      map['documents_path'] = Variable<String>(documentsPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrphansCompanion(')
          ..write('orphanId: $orphanId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('familyName: $familyName, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('status: $status, ')
          ..write('lastSeenLocation: $lastSeenLocation, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('currentCountry: $currentCountry, ')
          ..write('currentGovernorate: $currentGovernorate, ')
          ..write('currentCity: $currentCity, ')
          ..write('currentNeighborhood: $currentNeighborhood, ')
          ..write('currentCamp: $currentCamp, ')
          ..write('currentStreet: $currentStreet, ')
          ..write('currentPhoneNumber: $currentPhoneNumber, ')
          ..write('fatherFirstName: $fatherFirstName, ')
          ..write('fatherLastName: $fatherLastName, ')
          ..write('fatherDateOfBirth: $fatherDateOfBirth, ')
          ..write('fatherDateOfDeath: $fatherDateOfDeath, ')
          ..write('fatherCauseOfDeath: $fatherCauseOfDeath, ')
          ..write('fatherAlive: $fatherAlive, ')
          ..write('fatherEducationLevel: $fatherEducationLevel, ')
          ..write('fatherWork: $fatherWork, ')
          ..write('fatherMonthlyIncome: $fatherMonthlyIncome, ')
          ..write('fatherNumberOfWives: $fatherNumberOfWives, ')
          ..write('fatherNumberOfChildren: $fatherNumberOfChildren, ')
          ..write('motherFirstName: $motherFirstName, ')
          ..write('motherLastName: $motherLastName, ')
          ..write('motherDateOfBirth: $motherDateOfBirth, ')
          ..write('motherDateOfDeath: $motherDateOfDeath, ')
          ..write('motherCauseOfDeath: $motherCauseOfDeath, ')
          ..write('motherAlive: $motherAlive, ')
          ..write('motherEducationLevel: $motherEducationLevel, ')
          ..write('motherWork: $motherWork, ')
          ..write('motherMonthlyIncome: $motherMonthlyIncome, ')
          ..write('motherRemarried: $motherRemarried, ')
          ..write('motherNeedsSupport: $motherNeedsSupport, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianRelationship: $guardianRelationship, ')
          ..write('guardianEducationLevel: $guardianEducationLevel, ')
          ..write('guardianWork: $guardianWork, ')
          ..write('guardianNumberOfDependents: $guardianNumberOfDependents, ')
          ..write('guardianMonthlyIncome: $guardianMonthlyIncome, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('schoolName: $schoolName, ')
          ..write('educationAddress: $educationAddress, ')
          ..write('educationCosts: $educationCosts, ')
          ..write('studyYear: $studyYear, ')
          ..write('grade: $grade, ')
          ..write('educationStage: $educationStage, ')
          ..write('studyType: $studyType, ')
          ..write('educationAchievement: $educationAchievement, ')
          ..write('lastStudyResult: $lastStudyResult, ')
          ..write('weakSubjects: $weakSubjects, ')
          ..write('strongSubjects: $strongSubjects, ')
          ..write('studyImprovementActions: $studyImprovementActions, ')
          ..write('reasonForNotStudying: $reasonForNotStudying, ')
          ..write('stoppedStudying: $stoppedStudying, ')
          ..write('reasonForStoppingStufy: $reasonForStoppingStufy, ')
          ..write('healthStatus: $healthStatus, ')
          ..write('psychologicalStatus: $psychologicalStatus, ')
          ..write('behavioralStatus: $behavioralStatus, ')
          ..write('nutritionalStatus: $nutritionalStatus, ')
          ..write('disabilityType: $disabilityType, ')
          ..write('disabilityLevel: $disabilityLevel, ')
          ..write('medicalConditions: $medicalConditions, ')
          ..write('medications: $medications, ')
          ..write('needsMedicalSupport: $needsMedicalSupport, ')
          ..write('accommodationType: $accommodationType, ')
          ..write('accommodationAddress: $accommodationAddress, ')
          ..write('accommodationCondition: $accommodationCondition, ')
          ..write('accommodationOwnership: $accommodationOwnership, ')
          ..write('needsHousingSupport: $needsHousingSupport, ')
          ..write('quranMemorization: $quranMemorization, ')
          ..write('attendsIslamicSchool: $attendsIslamicSchool, ')
          ..write('islamicEducationLevel: $islamicEducationLevel, ')
          ..write('hobbies: $hobbies, ')
          ..write('skills: $skills, ')
          ..write('aspirations: $aspirations, ')
          ..write('numberOfSiblings: $numberOfSiblings, ')
          ..write('siblingsDetails: $siblingsDetails, ')
          ..write('additionalNotes: $additionalNotes, ')
          ..write('urgentNeeds: $urgentNeeds, ')
          ..write('specialCircumstances: $specialCircumstances, ')
          ..write('photoPath: $photoPath, ')
          ..write('documentsPath: $documentsPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $SupervisorsTable supervisors = $SupervisorsTable(this);
  late final $OrphansTable orphans = $OrphansTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [supervisors, orphans];
}

typedef $$SupervisorsTableCreateCompanionBuilder = SupervisorsCompanion
    Function({
  Value<String> supervisorId,
  required String fullName,
  required String contactInfo,
  required String location,
  required String publicKey,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$SupervisorsTableUpdateCompanionBuilder = SupervisorsCompanion
    Function({
  Value<String> supervisorId,
  Value<String> fullName,
  Value<String> contactInfo,
  Value<String> location,
  Value<String> publicKey,
  Value<bool> active,
  Value<int> rowid,
});

final class $$SupervisorsTableReferences
    extends BaseReferences<_$AppDb, $SupervisorsTable, Supervisor> {
  $$SupervisorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrphansTable, List<Orphan>> _orphansRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.orphans,
          aliasName: $_aliasNameGenerator(
              db.supervisors.supervisorId, db.orphans.supervisorId));

  $$OrphansTableProcessedTableManager get orphansRefs {
    final manager = $$OrphansTableTableManager($_db, $_db.orphans).filter((f) =>
        f.supervisorId.supervisorId
            .sqlEquals($_itemColumn<String>('supervisor_id')!));

    final cache = $_typedResult.readTableOrNull(_orphansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SupervisorsTableFilterComposer
    extends Composer<_$AppDb, $SupervisorsTable> {
  $$SupervisorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  Expression<bool> orphansRefs(
      Expression<bool> Function($$OrphansTableFilterComposer f) f) {
    final $$OrphansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supervisorId,
        referencedTable: $db.orphans,
        getReferencedColumn: (t) => t.supervisorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrphansTableFilterComposer(
              $db: $db,
              $table: $db.orphans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SupervisorsTableOrderingComposer
    extends Composer<_$AppDb, $SupervisorsTable> {
  $$SupervisorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$SupervisorsTableAnnotationComposer
    extends Composer<_$AppDb, $SupervisorsTable> {
  $$SupervisorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> orphansRefs<T extends Object>(
      Expression<T> Function($$OrphansTableAnnotationComposer a) f) {
    final $$OrphansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supervisorId,
        referencedTable: $db.orphans,
        getReferencedColumn: (t) => t.supervisorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrphansTableAnnotationComposer(
              $db: $db,
              $table: $db.orphans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SupervisorsTableTableManager extends RootTableManager<
    _$AppDb,
    $SupervisorsTable,
    Supervisor,
    $$SupervisorsTableFilterComposer,
    $$SupervisorsTableOrderingComposer,
    $$SupervisorsTableAnnotationComposer,
    $$SupervisorsTableCreateCompanionBuilder,
    $$SupervisorsTableUpdateCompanionBuilder,
    (Supervisor, $$SupervisorsTableReferences),
    Supervisor,
    PrefetchHooks Function({bool orphansRefs})> {
  $$SupervisorsTableTableManager(_$AppDb db, $SupervisorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupervisorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupervisorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupervisorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> supervisorId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> contactInfo = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String> publicKey = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SupervisorsCompanion(
            supervisorId: supervisorId,
            fullName: fullName,
            contactInfo: contactInfo,
            location: location,
            publicKey: publicKey,
            active: active,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> supervisorId = const Value.absent(),
            required String fullName,
            required String contactInfo,
            required String location,
            required String publicKey,
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SupervisorsCompanion.insert(
            supervisorId: supervisorId,
            fullName: fullName,
            contactInfo: contactInfo,
            location: location,
            publicKey: publicKey,
            active: active,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SupervisorsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orphansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orphansRefs) db.orphans],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orphansRefs)
                    await $_getPrefetchedData<Supervisor, $SupervisorsTable,
                            Orphan>(
                        currentTable: table,
                        referencedTable:
                            $$SupervisorsTableReferences._orphansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SupervisorsTableReferences(db, table, p0)
                                .orphansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.supervisorId == item.supervisorId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SupervisorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $SupervisorsTable,
    Supervisor,
    $$SupervisorsTableFilterComposer,
    $$SupervisorsTableOrderingComposer,
    $$SupervisorsTableAnnotationComposer,
    $$SupervisorsTableCreateCompanionBuilder,
    $$SupervisorsTableUpdateCompanionBuilder,
    (Supervisor, $$SupervisorsTableReferences),
    Supervisor,
    PrefetchHooks Function({bool orphansRefs})>;
typedef $$OrphansTableCreateCompanionBuilder = OrphansCompanion Function({
  Value<String> orphanId,
  required String firstName,
  required String lastName,
  required String familyName,
  required Gender gender,
  required DateTime dateOfBirth,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> idNumber,
  required OrphanStatus status,
  Value<String?> lastSeenLocation,
  required DateTime lastUpdated,
  required String supervisorId,
  Value<String?> currentCountry,
  Value<String?> currentGovernorate,
  Value<String?> currentCity,
  Value<String?> currentNeighborhood,
  Value<String?> currentCamp,
  Value<String?> currentStreet,
  Value<String?> currentPhoneNumber,
  Value<String?> fatherFirstName,
  Value<String?> fatherLastName,
  Value<DateTime?> fatherDateOfBirth,
  Value<DateTime?> fatherDateOfDeath,
  Value<String?> fatherCauseOfDeath,
  Value<bool?> fatherAlive,
  Value<String?> fatherEducationLevel,
  Value<String?> fatherWork,
  Value<String?> fatherMonthlyIncome,
  Value<int?> fatherNumberOfWives,
  Value<int?> fatherNumberOfChildren,
  Value<String?> motherFirstName,
  Value<String?> motherLastName,
  Value<DateTime?> motherDateOfBirth,
  Value<DateTime?> motherDateOfDeath,
  Value<String?> motherCauseOfDeath,
  Value<bool?> motherAlive,
  Value<String?> motherEducationLevel,
  Value<String?> motherWork,
  Value<String?> motherMonthlyIncome,
  Value<bool?> motherRemarried,
  Value<bool?> motherNeedsSupport,
  Value<String?> guardianName,
  Value<String?> guardianRelationship,
  Value<String?> guardianEducationLevel,
  Value<String?> guardianWork,
  Value<int?> guardianNumberOfDependents,
  Value<String?> guardianMonthlyIncome,
  Value<EducationLevel?> educationLevel,
  Value<String?> schoolName,
  Value<String?> educationAddress,
  Value<String?> educationCosts,
  Value<String?> studyYear,
  Value<String?> grade,
  Value<String?> educationStage,
  Value<String?> studyType,
  Value<String?> educationAchievement,
  Value<String?> lastStudyResult,
  Value<String?> weakSubjects,
  Value<String?> strongSubjects,
  Value<String?> studyImprovementActions,
  Value<String?> reasonForNotStudying,
  Value<bool?> stoppedStudying,
  Value<String?> reasonForStoppingStufy,
  Value<HealthStatus?> healthStatus,
  Value<PsychologicalStatus?> psychologicalStatus,
  Value<PsychologicalStatus?> behavioralStatus,
  Value<String?> nutritionalStatus,
  Value<String?> disabilityType,
  Value<DisabilityType?> disabilityLevel,
  Value<String?> medicalConditions,
  Value<String?> medications,
  Value<bool?> needsMedicalSupport,
  Value<AccommodationType?> accommodationType,
  Value<String?> accommodationAddress,
  Value<String?> accommodationCondition,
  Value<String?> accommodationOwnership,
  Value<bool?> needsHousingSupport,
  Value<String?> quranMemorization,
  Value<bool?> attendsIslamicSchool,
  Value<String?> islamicEducationLevel,
  Value<String?> hobbies,
  Value<String?> skills,
  Value<String?> aspirations,
  Value<int?> numberOfSiblings,
  Value<String?> siblingsDetails,
  Value<String?> additionalNotes,
  Value<String?> urgentNeeds,
  Value<String?> specialCircumstances,
  Value<String?> photoPath,
  Value<String?> documentsPath,
  Value<int> rowid,
});
typedef $$OrphansTableUpdateCompanionBuilder = OrphansCompanion Function({
  Value<String> orphanId,
  Value<String> firstName,
  Value<String> lastName,
  Value<String> familyName,
  Value<Gender> gender,
  Value<DateTime> dateOfBirth,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> idNumber,
  Value<OrphanStatus> status,
  Value<String?> lastSeenLocation,
  Value<DateTime> lastUpdated,
  Value<String> supervisorId,
  Value<String?> currentCountry,
  Value<String?> currentGovernorate,
  Value<String?> currentCity,
  Value<String?> currentNeighborhood,
  Value<String?> currentCamp,
  Value<String?> currentStreet,
  Value<String?> currentPhoneNumber,
  Value<String?> fatherFirstName,
  Value<String?> fatherLastName,
  Value<DateTime?> fatherDateOfBirth,
  Value<DateTime?> fatherDateOfDeath,
  Value<String?> fatherCauseOfDeath,
  Value<bool?> fatherAlive,
  Value<String?> fatherEducationLevel,
  Value<String?> fatherWork,
  Value<String?> fatherMonthlyIncome,
  Value<int?> fatherNumberOfWives,
  Value<int?> fatherNumberOfChildren,
  Value<String?> motherFirstName,
  Value<String?> motherLastName,
  Value<DateTime?> motherDateOfBirth,
  Value<DateTime?> motherDateOfDeath,
  Value<String?> motherCauseOfDeath,
  Value<bool?> motherAlive,
  Value<String?> motherEducationLevel,
  Value<String?> motherWork,
  Value<String?> motherMonthlyIncome,
  Value<bool?> motherRemarried,
  Value<bool?> motherNeedsSupport,
  Value<String?> guardianName,
  Value<String?> guardianRelationship,
  Value<String?> guardianEducationLevel,
  Value<String?> guardianWork,
  Value<int?> guardianNumberOfDependents,
  Value<String?> guardianMonthlyIncome,
  Value<EducationLevel?> educationLevel,
  Value<String?> schoolName,
  Value<String?> educationAddress,
  Value<String?> educationCosts,
  Value<String?> studyYear,
  Value<String?> grade,
  Value<String?> educationStage,
  Value<String?> studyType,
  Value<String?> educationAchievement,
  Value<String?> lastStudyResult,
  Value<String?> weakSubjects,
  Value<String?> strongSubjects,
  Value<String?> studyImprovementActions,
  Value<String?> reasonForNotStudying,
  Value<bool?> stoppedStudying,
  Value<String?> reasonForStoppingStufy,
  Value<HealthStatus?> healthStatus,
  Value<PsychologicalStatus?> psychologicalStatus,
  Value<PsychologicalStatus?> behavioralStatus,
  Value<String?> nutritionalStatus,
  Value<String?> disabilityType,
  Value<DisabilityType?> disabilityLevel,
  Value<String?> medicalConditions,
  Value<String?> medications,
  Value<bool?> needsMedicalSupport,
  Value<AccommodationType?> accommodationType,
  Value<String?> accommodationAddress,
  Value<String?> accommodationCondition,
  Value<String?> accommodationOwnership,
  Value<bool?> needsHousingSupport,
  Value<String?> quranMemorization,
  Value<bool?> attendsIslamicSchool,
  Value<String?> islamicEducationLevel,
  Value<String?> hobbies,
  Value<String?> skills,
  Value<String?> aspirations,
  Value<int?> numberOfSiblings,
  Value<String?> siblingsDetails,
  Value<String?> additionalNotes,
  Value<String?> urgentNeeds,
  Value<String?> specialCircumstances,
  Value<String?> photoPath,
  Value<String?> documentsPath,
  Value<int> rowid,
});

final class $$OrphansTableReferences
    extends BaseReferences<_$AppDb, $OrphansTable, Orphan> {
  $$OrphansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SupervisorsTable _supervisorIdTable(_$AppDb db) =>
      db.supervisors.createAlias($_aliasNameGenerator(
          db.orphans.supervisorId, db.supervisors.supervisorId));

  $$SupervisorsTableProcessedTableManager get supervisorId {
    final $_column = $_itemColumn<String>('supervisor_id')!;

    final manager = $$SupervisorsTableTableManager($_db, $_db.supervisors)
        .filter((f) => f.supervisorId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supervisorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrphansTableFilterComposer extends Composer<_$AppDb, $OrphansTable> {
  $$OrphansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orphanId => $composableBuilder(
      column: $table.orphanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyName => $composableBuilder(
      column: $table.familyName, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Gender, Gender, int> get gender =>
      $composableBuilder(
          column: $table.gender,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idNumber => $composableBuilder(
      column: $table.idNumber, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrphanStatus, OrphanStatus, int> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentCountry => $composableBuilder(
      column: $table.currentCountry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentGovernorate => $composableBuilder(
      column: $table.currentGovernorate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentCity => $composableBuilder(
      column: $table.currentCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentNeighborhood => $composableBuilder(
      column: $table.currentNeighborhood,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentCamp => $composableBuilder(
      column: $table.currentCamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentStreet => $composableBuilder(
      column: $table.currentStreet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentPhoneNumber => $composableBuilder(
      column: $table.currentPhoneNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherFirstName => $composableBuilder(
      column: $table.fatherFirstName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherLastName => $composableBuilder(
      column: $table.fatherLastName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fatherDateOfBirth => $composableBuilder(
      column: $table.fatherDateOfBirth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fatherDateOfDeath => $composableBuilder(
      column: $table.fatherDateOfDeath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherCauseOfDeath => $composableBuilder(
      column: $table.fatherCauseOfDeath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fatherAlive => $composableBuilder(
      column: $table.fatherAlive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherEducationLevel => $composableBuilder(
      column: $table.fatherEducationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherWork => $composableBuilder(
      column: $table.fatherWork, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherMonthlyIncome => $composableBuilder(
      column: $table.fatherMonthlyIncome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatherNumberOfWives => $composableBuilder(
      column: $table.fatherNumberOfWives,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatherNumberOfChildren => $composableBuilder(
      column: $table.fatherNumberOfChildren,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherFirstName => $composableBuilder(
      column: $table.motherFirstName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherLastName => $composableBuilder(
      column: $table.motherLastName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get motherDateOfBirth => $composableBuilder(
      column: $table.motherDateOfBirth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get motherDateOfDeath => $composableBuilder(
      column: $table.motherDateOfDeath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherCauseOfDeath => $composableBuilder(
      column: $table.motherCauseOfDeath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get motherAlive => $composableBuilder(
      column: $table.motherAlive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherEducationLevel => $composableBuilder(
      column: $table.motherEducationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherWork => $composableBuilder(
      column: $table.motherWork, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherMonthlyIncome => $composableBuilder(
      column: $table.motherMonthlyIncome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get motherRemarried => $composableBuilder(
      column: $table.motherRemarried,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get motherNeedsSupport => $composableBuilder(
      column: $table.motherNeedsSupport,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianName => $composableBuilder(
      column: $table.guardianName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianRelationship => $composableBuilder(
      column: $table.guardianRelationship,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianEducationLevel => $composableBuilder(
      column: $table.guardianEducationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianWork => $composableBuilder(
      column: $table.guardianWork, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get guardianNumberOfDependents => $composableBuilder(
      column: $table.guardianNumberOfDependents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianMonthlyIncome => $composableBuilder(
      column: $table.guardianMonthlyIncome,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EducationLevel?, EducationLevel, int>
      get educationLevel => $composableBuilder(
          column: $table.educationLevel,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationAddress => $composableBuilder(
      column: $table.educationAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationCosts => $composableBuilder(
      column: $table.educationCosts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studyYear => $composableBuilder(
      column: $table.studyYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationStage => $composableBuilder(
      column: $table.educationStage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studyType => $composableBuilder(
      column: $table.studyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationAchievement => $composableBuilder(
      column: $table.educationAchievement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastStudyResult => $composableBuilder(
      column: $table.lastStudyResult,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakSubjects => $composableBuilder(
      column: $table.weakSubjects, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strongSubjects => $composableBuilder(
      column: $table.strongSubjects,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studyImprovementActions => $composableBuilder(
      column: $table.studyImprovementActions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reasonForNotStudying => $composableBuilder(
      column: $table.reasonForNotStudying,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get stoppedStudying => $composableBuilder(
      column: $table.stoppedStudying,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reasonForStoppingStufy => $composableBuilder(
      column: $table.reasonForStoppingStufy,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<HealthStatus?, HealthStatus, int>
      get healthStatus => $composableBuilder(
          column: $table.healthStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<PsychologicalStatus?, PsychologicalStatus, int>
      get psychologicalStatus => $composableBuilder(
          column: $table.psychologicalStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<PsychologicalStatus?, PsychologicalStatus, int>
      get behavioralStatus => $composableBuilder(
          column: $table.behavioralStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disabilityType => $composableBuilder(
      column: $table.disabilityType,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DisabilityType?, DisabilityType, int>
      get disabilityLevel => $composableBuilder(
          column: $table.disabilityLevel,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get medicalConditions => $composableBuilder(
      column: $table.medicalConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medications => $composableBuilder(
      column: $table.medications, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsMedicalSupport => $composableBuilder(
      column: $table.needsMedicalSupport,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccommodationType?, AccommodationType, int>
      get accommodationType => $composableBuilder(
          column: $table.accommodationType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get accommodationAddress => $composableBuilder(
      column: $table.accommodationAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accommodationCondition => $composableBuilder(
      column: $table.accommodationCondition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accommodationOwnership => $composableBuilder(
      column: $table.accommodationOwnership,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsHousingSupport => $composableBuilder(
      column: $table.needsHousingSupport,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quranMemorization => $composableBuilder(
      column: $table.quranMemorization,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get attendsIslamicSchool => $composableBuilder(
      column: $table.attendsIslamicSchool,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get islamicEducationLevel => $composableBuilder(
      column: $table.islamicEducationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hobbies => $composableBuilder(
      column: $table.hobbies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skills => $composableBuilder(
      column: $table.skills, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aspirations => $composableBuilder(
      column: $table.aspirations, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberOfSiblings => $composableBuilder(
      column: $table.numberOfSiblings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siblingsDetails => $composableBuilder(
      column: $table.siblingsDetails,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalNotes => $composableBuilder(
      column: $table.additionalNotes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get urgentNeeds => $composableBuilder(
      column: $table.urgentNeeds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialCircumstances => $composableBuilder(
      column: $table.specialCircumstances,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentsPath => $composableBuilder(
      column: $table.documentsPath, builder: (column) => ColumnFilters(column));

  $$SupervisorsTableFilterComposer get supervisorId {
    final $$SupervisorsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supervisorId,
        referencedTable: $db.supervisors,
        getReferencedColumn: (t) => t.supervisorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupervisorsTableFilterComposer(
              $db: $db,
              $table: $db.supervisors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrphansTableOrderingComposer extends Composer<_$AppDb, $OrphansTable> {
  $$OrphansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orphanId => $composableBuilder(
      column: $table.orphanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyName => $composableBuilder(
      column: $table.familyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idNumber => $composableBuilder(
      column: $table.idNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentCountry => $composableBuilder(
      column: $table.currentCountry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentGovernorate => $composableBuilder(
      column: $table.currentGovernorate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentCity => $composableBuilder(
      column: $table.currentCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentNeighborhood => $composableBuilder(
      column: $table.currentNeighborhood,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentCamp => $composableBuilder(
      column: $table.currentCamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentStreet => $composableBuilder(
      column: $table.currentStreet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentPhoneNumber => $composableBuilder(
      column: $table.currentPhoneNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherFirstName => $composableBuilder(
      column: $table.fatherFirstName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherLastName => $composableBuilder(
      column: $table.fatherLastName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fatherDateOfBirth => $composableBuilder(
      column: $table.fatherDateOfBirth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fatherDateOfDeath => $composableBuilder(
      column: $table.fatherDateOfDeath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherCauseOfDeath => $composableBuilder(
      column: $table.fatherCauseOfDeath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fatherAlive => $composableBuilder(
      column: $table.fatherAlive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherEducationLevel => $composableBuilder(
      column: $table.fatherEducationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherWork => $composableBuilder(
      column: $table.fatherWork, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherMonthlyIncome => $composableBuilder(
      column: $table.fatherMonthlyIncome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatherNumberOfWives => $composableBuilder(
      column: $table.fatherNumberOfWives,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatherNumberOfChildren => $composableBuilder(
      column: $table.fatherNumberOfChildren,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherFirstName => $composableBuilder(
      column: $table.motherFirstName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherLastName => $composableBuilder(
      column: $table.motherLastName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get motherDateOfBirth => $composableBuilder(
      column: $table.motherDateOfBirth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get motherDateOfDeath => $composableBuilder(
      column: $table.motherDateOfDeath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherCauseOfDeath => $composableBuilder(
      column: $table.motherCauseOfDeath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get motherAlive => $composableBuilder(
      column: $table.motherAlive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherEducationLevel => $composableBuilder(
      column: $table.motherEducationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherWork => $composableBuilder(
      column: $table.motherWork, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherMonthlyIncome => $composableBuilder(
      column: $table.motherMonthlyIncome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get motherRemarried => $composableBuilder(
      column: $table.motherRemarried,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get motherNeedsSupport => $composableBuilder(
      column: $table.motherNeedsSupport,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianName => $composableBuilder(
      column: $table.guardianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianRelationship => $composableBuilder(
      column: $table.guardianRelationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianEducationLevel => $composableBuilder(
      column: $table.guardianEducationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianWork => $composableBuilder(
      column: $table.guardianWork,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get guardianNumberOfDependents => $composableBuilder(
      column: $table.guardianNumberOfDependents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianMonthlyIncome => $composableBuilder(
      column: $table.guardianMonthlyIncome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get educationLevel => $composableBuilder(
      column: $table.educationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationAddress => $composableBuilder(
      column: $table.educationAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationCosts => $composableBuilder(
      column: $table.educationCosts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studyYear => $composableBuilder(
      column: $table.studyYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationStage => $composableBuilder(
      column: $table.educationStage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studyType => $composableBuilder(
      column: $table.studyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationAchievement => $composableBuilder(
      column: $table.educationAchievement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastStudyResult => $composableBuilder(
      column: $table.lastStudyResult,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakSubjects => $composableBuilder(
      column: $table.weakSubjects,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strongSubjects => $composableBuilder(
      column: $table.strongSubjects,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studyImprovementActions => $composableBuilder(
      column: $table.studyImprovementActions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonForNotStudying => $composableBuilder(
      column: $table.reasonForNotStudying,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get stoppedStudying => $composableBuilder(
      column: $table.stoppedStudying,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonForStoppingStufy => $composableBuilder(
      column: $table.reasonForStoppingStufy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get healthStatus => $composableBuilder(
      column: $table.healthStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get psychologicalStatus => $composableBuilder(
      column: $table.psychologicalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get behavioralStatus => $composableBuilder(
      column: $table.behavioralStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disabilityType => $composableBuilder(
      column: $table.disabilityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get disabilityLevel => $composableBuilder(
      column: $table.disabilityLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicalConditions => $composableBuilder(
      column: $table.medicalConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medications => $composableBuilder(
      column: $table.medications, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsMedicalSupport => $composableBuilder(
      column: $table.needsMedicalSupport,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accommodationType => $composableBuilder(
      column: $table.accommodationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accommodationAddress => $composableBuilder(
      column: $table.accommodationAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accommodationCondition => $composableBuilder(
      column: $table.accommodationCondition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accommodationOwnership => $composableBuilder(
      column: $table.accommodationOwnership,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsHousingSupport => $composableBuilder(
      column: $table.needsHousingSupport,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quranMemorization => $composableBuilder(
      column: $table.quranMemorization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get attendsIslamicSchool => $composableBuilder(
      column: $table.attendsIslamicSchool,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get islamicEducationLevel => $composableBuilder(
      column: $table.islamicEducationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hobbies => $composableBuilder(
      column: $table.hobbies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skills => $composableBuilder(
      column: $table.skills, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aspirations => $composableBuilder(
      column: $table.aspirations, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberOfSiblings => $composableBuilder(
      column: $table.numberOfSiblings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siblingsDetails => $composableBuilder(
      column: $table.siblingsDetails,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalNotes => $composableBuilder(
      column: $table.additionalNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urgentNeeds => $composableBuilder(
      column: $table.urgentNeeds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialCircumstances => $composableBuilder(
      column: $table.specialCircumstances,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentsPath => $composableBuilder(
      column: $table.documentsPath,
      builder: (column) => ColumnOrderings(column));

  $$SupervisorsTableOrderingComposer get supervisorId {
    final $$SupervisorsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supervisorId,
        referencedTable: $db.supervisors,
        getReferencedColumn: (t) => t.supervisorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupervisorsTableOrderingComposer(
              $db: $db,
              $table: $db.supervisors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrphansTableAnnotationComposer
    extends Composer<_$AppDb, $OrphansTable> {
  $$OrphansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orphanId =>
      $composableBuilder(column: $table.orphanId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get familyName => $composableBuilder(
      column: $table.familyName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Gender, int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrphanStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<String> get currentCountry => $composableBuilder(
      column: $table.currentCountry, builder: (column) => column);

  GeneratedColumn<String> get currentGovernorate => $composableBuilder(
      column: $table.currentGovernorate, builder: (column) => column);

  GeneratedColumn<String> get currentCity => $composableBuilder(
      column: $table.currentCity, builder: (column) => column);

  GeneratedColumn<String> get currentNeighborhood => $composableBuilder(
      column: $table.currentNeighborhood, builder: (column) => column);

  GeneratedColumn<String> get currentCamp => $composableBuilder(
      column: $table.currentCamp, builder: (column) => column);

  GeneratedColumn<String> get currentStreet => $composableBuilder(
      column: $table.currentStreet, builder: (column) => column);

  GeneratedColumn<String> get currentPhoneNumber => $composableBuilder(
      column: $table.currentPhoneNumber, builder: (column) => column);

  GeneratedColumn<String> get fatherFirstName => $composableBuilder(
      column: $table.fatherFirstName, builder: (column) => column);

  GeneratedColumn<String> get fatherLastName => $composableBuilder(
      column: $table.fatherLastName, builder: (column) => column);

  GeneratedColumn<DateTime> get fatherDateOfBirth => $composableBuilder(
      column: $table.fatherDateOfBirth, builder: (column) => column);

  GeneratedColumn<DateTime> get fatherDateOfDeath => $composableBuilder(
      column: $table.fatherDateOfDeath, builder: (column) => column);

  GeneratedColumn<String> get fatherCauseOfDeath => $composableBuilder(
      column: $table.fatherCauseOfDeath, builder: (column) => column);

  GeneratedColumn<bool> get fatherAlive => $composableBuilder(
      column: $table.fatherAlive, builder: (column) => column);

  GeneratedColumn<String> get fatherEducationLevel => $composableBuilder(
      column: $table.fatherEducationLevel, builder: (column) => column);

  GeneratedColumn<String> get fatherWork => $composableBuilder(
      column: $table.fatherWork, builder: (column) => column);

  GeneratedColumn<String> get fatherMonthlyIncome => $composableBuilder(
      column: $table.fatherMonthlyIncome, builder: (column) => column);

  GeneratedColumn<int> get fatherNumberOfWives => $composableBuilder(
      column: $table.fatherNumberOfWives, builder: (column) => column);

  GeneratedColumn<int> get fatherNumberOfChildren => $composableBuilder(
      column: $table.fatherNumberOfChildren, builder: (column) => column);

  GeneratedColumn<String> get motherFirstName => $composableBuilder(
      column: $table.motherFirstName, builder: (column) => column);

  GeneratedColumn<String> get motherLastName => $composableBuilder(
      column: $table.motherLastName, builder: (column) => column);

  GeneratedColumn<DateTime> get motherDateOfBirth => $composableBuilder(
      column: $table.motherDateOfBirth, builder: (column) => column);

  GeneratedColumn<DateTime> get motherDateOfDeath => $composableBuilder(
      column: $table.motherDateOfDeath, builder: (column) => column);

  GeneratedColumn<String> get motherCauseOfDeath => $composableBuilder(
      column: $table.motherCauseOfDeath, builder: (column) => column);

  GeneratedColumn<bool> get motherAlive => $composableBuilder(
      column: $table.motherAlive, builder: (column) => column);

  GeneratedColumn<String> get motherEducationLevel => $composableBuilder(
      column: $table.motherEducationLevel, builder: (column) => column);

  GeneratedColumn<String> get motherWork => $composableBuilder(
      column: $table.motherWork, builder: (column) => column);

  GeneratedColumn<String> get motherMonthlyIncome => $composableBuilder(
      column: $table.motherMonthlyIncome, builder: (column) => column);

  GeneratedColumn<bool> get motherRemarried => $composableBuilder(
      column: $table.motherRemarried, builder: (column) => column);

  GeneratedColumn<bool> get motherNeedsSupport => $composableBuilder(
      column: $table.motherNeedsSupport, builder: (column) => column);

  GeneratedColumn<String> get guardianName => $composableBuilder(
      column: $table.guardianName, builder: (column) => column);

  GeneratedColumn<String> get guardianRelationship => $composableBuilder(
      column: $table.guardianRelationship, builder: (column) => column);

  GeneratedColumn<String> get guardianEducationLevel => $composableBuilder(
      column: $table.guardianEducationLevel, builder: (column) => column);

  GeneratedColumn<String> get guardianWork => $composableBuilder(
      column: $table.guardianWork, builder: (column) => column);

  GeneratedColumn<int> get guardianNumberOfDependents => $composableBuilder(
      column: $table.guardianNumberOfDependents, builder: (column) => column);

  GeneratedColumn<String> get guardianMonthlyIncome => $composableBuilder(
      column: $table.guardianMonthlyIncome, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EducationLevel?, int> get educationLevel =>
      $composableBuilder(
          column: $table.educationLevel, builder: (column) => column);

  GeneratedColumn<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => column);

  GeneratedColumn<String> get educationAddress => $composableBuilder(
      column: $table.educationAddress, builder: (column) => column);

  GeneratedColumn<String> get educationCosts => $composableBuilder(
      column: $table.educationCosts, builder: (column) => column);

  GeneratedColumn<String> get studyYear =>
      $composableBuilder(column: $table.studyYear, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get educationStage => $composableBuilder(
      column: $table.educationStage, builder: (column) => column);

  GeneratedColumn<String> get studyType =>
      $composableBuilder(column: $table.studyType, builder: (column) => column);

  GeneratedColumn<String> get educationAchievement => $composableBuilder(
      column: $table.educationAchievement, builder: (column) => column);

  GeneratedColumn<String> get lastStudyResult => $composableBuilder(
      column: $table.lastStudyResult, builder: (column) => column);

  GeneratedColumn<String> get weakSubjects => $composableBuilder(
      column: $table.weakSubjects, builder: (column) => column);

  GeneratedColumn<String> get strongSubjects => $composableBuilder(
      column: $table.strongSubjects, builder: (column) => column);

  GeneratedColumn<String> get studyImprovementActions => $composableBuilder(
      column: $table.studyImprovementActions, builder: (column) => column);

  GeneratedColumn<String> get reasonForNotStudying => $composableBuilder(
      column: $table.reasonForNotStudying, builder: (column) => column);

  GeneratedColumn<bool> get stoppedStudying => $composableBuilder(
      column: $table.stoppedStudying, builder: (column) => column);

  GeneratedColumn<String> get reasonForStoppingStufy => $composableBuilder(
      column: $table.reasonForStoppingStufy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HealthStatus?, int> get healthStatus =>
      $composableBuilder(
          column: $table.healthStatus, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PsychologicalStatus?, int>
      get psychologicalStatus => $composableBuilder(
          column: $table.psychologicalStatus, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PsychologicalStatus?, int>
      get behavioralStatus => $composableBuilder(
          column: $table.behavioralStatus, builder: (column) => column);

  GeneratedColumn<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus, builder: (column) => column);

  GeneratedColumn<String> get disabilityType => $composableBuilder(
      column: $table.disabilityType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DisabilityType?, int> get disabilityLevel =>
      $composableBuilder(
          column: $table.disabilityLevel, builder: (column) => column);

  GeneratedColumn<String> get medicalConditions => $composableBuilder(
      column: $table.medicalConditions, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
      column: $table.medications, builder: (column) => column);

  GeneratedColumn<bool> get needsMedicalSupport => $composableBuilder(
      column: $table.needsMedicalSupport, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccommodationType?, int>
      get accommodationType => $composableBuilder(
          column: $table.accommodationType, builder: (column) => column);

  GeneratedColumn<String> get accommodationAddress => $composableBuilder(
      column: $table.accommodationAddress, builder: (column) => column);

  GeneratedColumn<String> get accommodationCondition => $composableBuilder(
      column: $table.accommodationCondition, builder: (column) => column);

  GeneratedColumn<String> get accommodationOwnership => $composableBuilder(
      column: $table.accommodationOwnership, builder: (column) => column);

  GeneratedColumn<bool> get needsHousingSupport => $composableBuilder(
      column: $table.needsHousingSupport, builder: (column) => column);

  GeneratedColumn<String> get quranMemorization => $composableBuilder(
      column: $table.quranMemorization, builder: (column) => column);

  GeneratedColumn<bool> get attendsIslamicSchool => $composableBuilder(
      column: $table.attendsIslamicSchool, builder: (column) => column);

  GeneratedColumn<String> get islamicEducationLevel => $composableBuilder(
      column: $table.islamicEducationLevel, builder: (column) => column);

  GeneratedColumn<String> get hobbies =>
      $composableBuilder(column: $table.hobbies, builder: (column) => column);

  GeneratedColumn<String> get skills =>
      $composableBuilder(column: $table.skills, builder: (column) => column);

  GeneratedColumn<String> get aspirations => $composableBuilder(
      column: $table.aspirations, builder: (column) => column);

  GeneratedColumn<int> get numberOfSiblings => $composableBuilder(
      column: $table.numberOfSiblings, builder: (column) => column);

  GeneratedColumn<String> get siblingsDetails => $composableBuilder(
      column: $table.siblingsDetails, builder: (column) => column);

  GeneratedColumn<String> get additionalNotes => $composableBuilder(
      column: $table.additionalNotes, builder: (column) => column);

  GeneratedColumn<String> get urgentNeeds => $composableBuilder(
      column: $table.urgentNeeds, builder: (column) => column);

  GeneratedColumn<String> get specialCircumstances => $composableBuilder(
      column: $table.specialCircumstances, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get documentsPath => $composableBuilder(
      column: $table.documentsPath, builder: (column) => column);

  $$SupervisorsTableAnnotationComposer get supervisorId {
    final $$SupervisorsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supervisorId,
        referencedTable: $db.supervisors,
        getReferencedColumn: (t) => t.supervisorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupervisorsTableAnnotationComposer(
              $db: $db,
              $table: $db.supervisors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrphansTableTableManager extends RootTableManager<
    _$AppDb,
    $OrphansTable,
    Orphan,
    $$OrphansTableFilterComposer,
    $$OrphansTableOrderingComposer,
    $$OrphansTableAnnotationComposer,
    $$OrphansTableCreateCompanionBuilder,
    $$OrphansTableUpdateCompanionBuilder,
    (Orphan, $$OrphansTableReferences),
    Orphan,
    PrefetchHooks Function({bool supervisorId})> {
  $$OrphansTableTableManager(_$AppDb db, $OrphansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrphansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrphansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrphansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> orphanId = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String> familyName = const Value.absent(),
            Value<Gender> gender = const Value.absent(),
            Value<DateTime> dateOfBirth = const Value.absent(),
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> idNumber = const Value.absent(),
            Value<OrphanStatus> status = const Value.absent(),
            Value<String?> lastSeenLocation = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<String> supervisorId = const Value.absent(),
            Value<String?> currentCountry = const Value.absent(),
            Value<String?> currentGovernorate = const Value.absent(),
            Value<String?> currentCity = const Value.absent(),
            Value<String?> currentNeighborhood = const Value.absent(),
            Value<String?> currentCamp = const Value.absent(),
            Value<String?> currentStreet = const Value.absent(),
            Value<String?> currentPhoneNumber = const Value.absent(),
            Value<String?> fatherFirstName = const Value.absent(),
            Value<String?> fatherLastName = const Value.absent(),
            Value<DateTime?> fatherDateOfBirth = const Value.absent(),
            Value<DateTime?> fatherDateOfDeath = const Value.absent(),
            Value<String?> fatherCauseOfDeath = const Value.absent(),
            Value<bool?> fatherAlive = const Value.absent(),
            Value<String?> fatherEducationLevel = const Value.absent(),
            Value<String?> fatherWork = const Value.absent(),
            Value<String?> fatherMonthlyIncome = const Value.absent(),
            Value<int?> fatherNumberOfWives = const Value.absent(),
            Value<int?> fatherNumberOfChildren = const Value.absent(),
            Value<String?> motherFirstName = const Value.absent(),
            Value<String?> motherLastName = const Value.absent(),
            Value<DateTime?> motherDateOfBirth = const Value.absent(),
            Value<DateTime?> motherDateOfDeath = const Value.absent(),
            Value<String?> motherCauseOfDeath = const Value.absent(),
            Value<bool?> motherAlive = const Value.absent(),
            Value<String?> motherEducationLevel = const Value.absent(),
            Value<String?> motherWork = const Value.absent(),
            Value<String?> motherMonthlyIncome = const Value.absent(),
            Value<bool?> motherRemarried = const Value.absent(),
            Value<bool?> motherNeedsSupport = const Value.absent(),
            Value<String?> guardianName = const Value.absent(),
            Value<String?> guardianRelationship = const Value.absent(),
            Value<String?> guardianEducationLevel = const Value.absent(),
            Value<String?> guardianWork = const Value.absent(),
            Value<int?> guardianNumberOfDependents = const Value.absent(),
            Value<String?> guardianMonthlyIncome = const Value.absent(),
            Value<EducationLevel?> educationLevel = const Value.absent(),
            Value<String?> schoolName = const Value.absent(),
            Value<String?> educationAddress = const Value.absent(),
            Value<String?> educationCosts = const Value.absent(),
            Value<String?> studyYear = const Value.absent(),
            Value<String?> grade = const Value.absent(),
            Value<String?> educationStage = const Value.absent(),
            Value<String?> studyType = const Value.absent(),
            Value<String?> educationAchievement = const Value.absent(),
            Value<String?> lastStudyResult = const Value.absent(),
            Value<String?> weakSubjects = const Value.absent(),
            Value<String?> strongSubjects = const Value.absent(),
            Value<String?> studyImprovementActions = const Value.absent(),
            Value<String?> reasonForNotStudying = const Value.absent(),
            Value<bool?> stoppedStudying = const Value.absent(),
            Value<String?> reasonForStoppingStufy = const Value.absent(),
            Value<HealthStatus?> healthStatus = const Value.absent(),
            Value<PsychologicalStatus?> psychologicalStatus =
                const Value.absent(),
            Value<PsychologicalStatus?> behavioralStatus = const Value.absent(),
            Value<String?> nutritionalStatus = const Value.absent(),
            Value<String?> disabilityType = const Value.absent(),
            Value<DisabilityType?> disabilityLevel = const Value.absent(),
            Value<String?> medicalConditions = const Value.absent(),
            Value<String?> medications = const Value.absent(),
            Value<bool?> needsMedicalSupport = const Value.absent(),
            Value<AccommodationType?> accommodationType = const Value.absent(),
            Value<String?> accommodationAddress = const Value.absent(),
            Value<String?> accommodationCondition = const Value.absent(),
            Value<String?> accommodationOwnership = const Value.absent(),
            Value<bool?> needsHousingSupport = const Value.absent(),
            Value<String?> quranMemorization = const Value.absent(),
            Value<bool?> attendsIslamicSchool = const Value.absent(),
            Value<String?> islamicEducationLevel = const Value.absent(),
            Value<String?> hobbies = const Value.absent(),
            Value<String?> skills = const Value.absent(),
            Value<String?> aspirations = const Value.absent(),
            Value<int?> numberOfSiblings = const Value.absent(),
            Value<String?> siblingsDetails = const Value.absent(),
            Value<String?> additionalNotes = const Value.absent(),
            Value<String?> urgentNeeds = const Value.absent(),
            Value<String?> specialCircumstances = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> documentsPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrphansCompanion(
            orphanId: orphanId,
            firstName: firstName,
            lastName: lastName,
            familyName: familyName,
            gender: gender,
            dateOfBirth: dateOfBirth,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            idNumber: idNumber,
            status: status,
            lastSeenLocation: lastSeenLocation,
            lastUpdated: lastUpdated,
            supervisorId: supervisorId,
            currentCountry: currentCountry,
            currentGovernorate: currentGovernorate,
            currentCity: currentCity,
            currentNeighborhood: currentNeighborhood,
            currentCamp: currentCamp,
            currentStreet: currentStreet,
            currentPhoneNumber: currentPhoneNumber,
            fatherFirstName: fatherFirstName,
            fatherLastName: fatherLastName,
            fatherDateOfBirth: fatherDateOfBirth,
            fatherDateOfDeath: fatherDateOfDeath,
            fatherCauseOfDeath: fatherCauseOfDeath,
            fatherAlive: fatherAlive,
            fatherEducationLevel: fatherEducationLevel,
            fatherWork: fatherWork,
            fatherMonthlyIncome: fatherMonthlyIncome,
            fatherNumberOfWives: fatherNumberOfWives,
            fatherNumberOfChildren: fatherNumberOfChildren,
            motherFirstName: motherFirstName,
            motherLastName: motherLastName,
            motherDateOfBirth: motherDateOfBirth,
            motherDateOfDeath: motherDateOfDeath,
            motherCauseOfDeath: motherCauseOfDeath,
            motherAlive: motherAlive,
            motherEducationLevel: motherEducationLevel,
            motherWork: motherWork,
            motherMonthlyIncome: motherMonthlyIncome,
            motherRemarried: motherRemarried,
            motherNeedsSupport: motherNeedsSupport,
            guardianName: guardianName,
            guardianRelationship: guardianRelationship,
            guardianEducationLevel: guardianEducationLevel,
            guardianWork: guardianWork,
            guardianNumberOfDependents: guardianNumberOfDependents,
            guardianMonthlyIncome: guardianMonthlyIncome,
            educationLevel: educationLevel,
            schoolName: schoolName,
            educationAddress: educationAddress,
            educationCosts: educationCosts,
            studyYear: studyYear,
            grade: grade,
            educationStage: educationStage,
            studyType: studyType,
            educationAchievement: educationAchievement,
            lastStudyResult: lastStudyResult,
            weakSubjects: weakSubjects,
            strongSubjects: strongSubjects,
            studyImprovementActions: studyImprovementActions,
            reasonForNotStudying: reasonForNotStudying,
            stoppedStudying: stoppedStudying,
            reasonForStoppingStufy: reasonForStoppingStufy,
            healthStatus: healthStatus,
            psychologicalStatus: psychologicalStatus,
            behavioralStatus: behavioralStatus,
            nutritionalStatus: nutritionalStatus,
            disabilityType: disabilityType,
            disabilityLevel: disabilityLevel,
            medicalConditions: medicalConditions,
            medications: medications,
            needsMedicalSupport: needsMedicalSupport,
            accommodationType: accommodationType,
            accommodationAddress: accommodationAddress,
            accommodationCondition: accommodationCondition,
            accommodationOwnership: accommodationOwnership,
            needsHousingSupport: needsHousingSupport,
            quranMemorization: quranMemorization,
            attendsIslamicSchool: attendsIslamicSchool,
            islamicEducationLevel: islamicEducationLevel,
            hobbies: hobbies,
            skills: skills,
            aspirations: aspirations,
            numberOfSiblings: numberOfSiblings,
            siblingsDetails: siblingsDetails,
            additionalNotes: additionalNotes,
            urgentNeeds: urgentNeeds,
            specialCircumstances: specialCircumstances,
            photoPath: photoPath,
            documentsPath: documentsPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> orphanId = const Value.absent(),
            required String firstName,
            required String lastName,
            required String familyName,
            required Gender gender,
            required DateTime dateOfBirth,
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> idNumber = const Value.absent(),
            required OrphanStatus status,
            Value<String?> lastSeenLocation = const Value.absent(),
            required DateTime lastUpdated,
            required String supervisorId,
            Value<String?> currentCountry = const Value.absent(),
            Value<String?> currentGovernorate = const Value.absent(),
            Value<String?> currentCity = const Value.absent(),
            Value<String?> currentNeighborhood = const Value.absent(),
            Value<String?> currentCamp = const Value.absent(),
            Value<String?> currentStreet = const Value.absent(),
            Value<String?> currentPhoneNumber = const Value.absent(),
            Value<String?> fatherFirstName = const Value.absent(),
            Value<String?> fatherLastName = const Value.absent(),
            Value<DateTime?> fatherDateOfBirth = const Value.absent(),
            Value<DateTime?> fatherDateOfDeath = const Value.absent(),
            Value<String?> fatherCauseOfDeath = const Value.absent(),
            Value<bool?> fatherAlive = const Value.absent(),
            Value<String?> fatherEducationLevel = const Value.absent(),
            Value<String?> fatherWork = const Value.absent(),
            Value<String?> fatherMonthlyIncome = const Value.absent(),
            Value<int?> fatherNumberOfWives = const Value.absent(),
            Value<int?> fatherNumberOfChildren = const Value.absent(),
            Value<String?> motherFirstName = const Value.absent(),
            Value<String?> motherLastName = const Value.absent(),
            Value<DateTime?> motherDateOfBirth = const Value.absent(),
            Value<DateTime?> motherDateOfDeath = const Value.absent(),
            Value<String?> motherCauseOfDeath = const Value.absent(),
            Value<bool?> motherAlive = const Value.absent(),
            Value<String?> motherEducationLevel = const Value.absent(),
            Value<String?> motherWork = const Value.absent(),
            Value<String?> motherMonthlyIncome = const Value.absent(),
            Value<bool?> motherRemarried = const Value.absent(),
            Value<bool?> motherNeedsSupport = const Value.absent(),
            Value<String?> guardianName = const Value.absent(),
            Value<String?> guardianRelationship = const Value.absent(),
            Value<String?> guardianEducationLevel = const Value.absent(),
            Value<String?> guardianWork = const Value.absent(),
            Value<int?> guardianNumberOfDependents = const Value.absent(),
            Value<String?> guardianMonthlyIncome = const Value.absent(),
            Value<EducationLevel?> educationLevel = const Value.absent(),
            Value<String?> schoolName = const Value.absent(),
            Value<String?> educationAddress = const Value.absent(),
            Value<String?> educationCosts = const Value.absent(),
            Value<String?> studyYear = const Value.absent(),
            Value<String?> grade = const Value.absent(),
            Value<String?> educationStage = const Value.absent(),
            Value<String?> studyType = const Value.absent(),
            Value<String?> educationAchievement = const Value.absent(),
            Value<String?> lastStudyResult = const Value.absent(),
            Value<String?> weakSubjects = const Value.absent(),
            Value<String?> strongSubjects = const Value.absent(),
            Value<String?> studyImprovementActions = const Value.absent(),
            Value<String?> reasonForNotStudying = const Value.absent(),
            Value<bool?> stoppedStudying = const Value.absent(),
            Value<String?> reasonForStoppingStufy = const Value.absent(),
            Value<HealthStatus?> healthStatus = const Value.absent(),
            Value<PsychologicalStatus?> psychologicalStatus =
                const Value.absent(),
            Value<PsychologicalStatus?> behavioralStatus = const Value.absent(),
            Value<String?> nutritionalStatus = const Value.absent(),
            Value<String?> disabilityType = const Value.absent(),
            Value<DisabilityType?> disabilityLevel = const Value.absent(),
            Value<String?> medicalConditions = const Value.absent(),
            Value<String?> medications = const Value.absent(),
            Value<bool?> needsMedicalSupport = const Value.absent(),
            Value<AccommodationType?> accommodationType = const Value.absent(),
            Value<String?> accommodationAddress = const Value.absent(),
            Value<String?> accommodationCondition = const Value.absent(),
            Value<String?> accommodationOwnership = const Value.absent(),
            Value<bool?> needsHousingSupport = const Value.absent(),
            Value<String?> quranMemorization = const Value.absent(),
            Value<bool?> attendsIslamicSchool = const Value.absent(),
            Value<String?> islamicEducationLevel = const Value.absent(),
            Value<String?> hobbies = const Value.absent(),
            Value<String?> skills = const Value.absent(),
            Value<String?> aspirations = const Value.absent(),
            Value<int?> numberOfSiblings = const Value.absent(),
            Value<String?> siblingsDetails = const Value.absent(),
            Value<String?> additionalNotes = const Value.absent(),
            Value<String?> urgentNeeds = const Value.absent(),
            Value<String?> specialCircumstances = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> documentsPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrphansCompanion.insert(
            orphanId: orphanId,
            firstName: firstName,
            lastName: lastName,
            familyName: familyName,
            gender: gender,
            dateOfBirth: dateOfBirth,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            idNumber: idNumber,
            status: status,
            lastSeenLocation: lastSeenLocation,
            lastUpdated: lastUpdated,
            supervisorId: supervisorId,
            currentCountry: currentCountry,
            currentGovernorate: currentGovernorate,
            currentCity: currentCity,
            currentNeighborhood: currentNeighborhood,
            currentCamp: currentCamp,
            currentStreet: currentStreet,
            currentPhoneNumber: currentPhoneNumber,
            fatherFirstName: fatherFirstName,
            fatherLastName: fatherLastName,
            fatherDateOfBirth: fatherDateOfBirth,
            fatherDateOfDeath: fatherDateOfDeath,
            fatherCauseOfDeath: fatherCauseOfDeath,
            fatherAlive: fatherAlive,
            fatherEducationLevel: fatherEducationLevel,
            fatherWork: fatherWork,
            fatherMonthlyIncome: fatherMonthlyIncome,
            fatherNumberOfWives: fatherNumberOfWives,
            fatherNumberOfChildren: fatherNumberOfChildren,
            motherFirstName: motherFirstName,
            motherLastName: motherLastName,
            motherDateOfBirth: motherDateOfBirth,
            motherDateOfDeath: motherDateOfDeath,
            motherCauseOfDeath: motherCauseOfDeath,
            motherAlive: motherAlive,
            motherEducationLevel: motherEducationLevel,
            motherWork: motherWork,
            motherMonthlyIncome: motherMonthlyIncome,
            motherRemarried: motherRemarried,
            motherNeedsSupport: motherNeedsSupport,
            guardianName: guardianName,
            guardianRelationship: guardianRelationship,
            guardianEducationLevel: guardianEducationLevel,
            guardianWork: guardianWork,
            guardianNumberOfDependents: guardianNumberOfDependents,
            guardianMonthlyIncome: guardianMonthlyIncome,
            educationLevel: educationLevel,
            schoolName: schoolName,
            educationAddress: educationAddress,
            educationCosts: educationCosts,
            studyYear: studyYear,
            grade: grade,
            educationStage: educationStage,
            studyType: studyType,
            educationAchievement: educationAchievement,
            lastStudyResult: lastStudyResult,
            weakSubjects: weakSubjects,
            strongSubjects: strongSubjects,
            studyImprovementActions: studyImprovementActions,
            reasonForNotStudying: reasonForNotStudying,
            stoppedStudying: stoppedStudying,
            reasonForStoppingStufy: reasonForStoppingStufy,
            healthStatus: healthStatus,
            psychologicalStatus: psychologicalStatus,
            behavioralStatus: behavioralStatus,
            nutritionalStatus: nutritionalStatus,
            disabilityType: disabilityType,
            disabilityLevel: disabilityLevel,
            medicalConditions: medicalConditions,
            medications: medications,
            needsMedicalSupport: needsMedicalSupport,
            accommodationType: accommodationType,
            accommodationAddress: accommodationAddress,
            accommodationCondition: accommodationCondition,
            accommodationOwnership: accommodationOwnership,
            needsHousingSupport: needsHousingSupport,
            quranMemorization: quranMemorization,
            attendsIslamicSchool: attendsIslamicSchool,
            islamicEducationLevel: islamicEducationLevel,
            hobbies: hobbies,
            skills: skills,
            aspirations: aspirations,
            numberOfSiblings: numberOfSiblings,
            siblingsDetails: siblingsDetails,
            additionalNotes: additionalNotes,
            urgentNeeds: urgentNeeds,
            specialCircumstances: specialCircumstances,
            photoPath: photoPath,
            documentsPath: documentsPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrphansTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({supervisorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supervisorId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supervisorId,
                    referencedTable:
                        $$OrphansTableReferences._supervisorIdTable(db),
                    referencedColumn: $$OrphansTableReferences
                        ._supervisorIdTable(db)
                        .supervisorId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrphansTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $OrphansTable,
    Orphan,
    $$OrphansTableFilterComposer,
    $$OrphansTableOrderingComposer,
    $$OrphansTableAnnotationComposer,
    $$OrphansTableCreateCompanionBuilder,
    $$OrphansTableUpdateCompanionBuilder,
    (Orphan, $$OrphansTableReferences),
    Orphan,
    PrefetchHooks Function({bool supervisorId})>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$SupervisorsTableTableManager get supervisors =>
      $$SupervisorsTableTableManager(_db, _db.supervisors);
  $$OrphansTableTableManager get orphans =>
      $$OrphansTableTableManager(_db, _db.orphans);
}
