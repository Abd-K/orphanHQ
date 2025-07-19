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
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
  @override
  List<GeneratedColumn> get $columns => [
        orphanId,
        fullName,
        dateOfBirth,
        status,
        lastSeenLocation,
        lastUpdated,
        supervisorId
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
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
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
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      dateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth'])!,
      status: $OrphansTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      lastSeenLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_seen_location']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id'])!,
    );
  }

  @override
  $OrphansTable createAlias(String alias) {
    return $OrphansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrphanStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrphanStatus>(OrphanStatus.values);
}

class Orphan extends DataClass implements Insertable<Orphan> {
  final String orphanId;
  final String fullName;
  final DateTime dateOfBirth;
  final OrphanStatus status;
  final String? lastSeenLocation;
  final DateTime lastUpdated;
  final String supervisorId;
  const Orphan(
      {required this.orphanId,
      required this.fullName,
      required this.dateOfBirth,
      required this.status,
      this.lastSeenLocation,
      required this.lastUpdated,
      required this.supervisorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['orphan_id'] = Variable<String>(orphanId);
    map['full_name'] = Variable<String>(fullName);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    {
      map['status'] =
          Variable<int>($OrphansTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || lastSeenLocation != null) {
      map['last_seen_location'] = Variable<String>(lastSeenLocation);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['supervisor_id'] = Variable<String>(supervisorId);
    return map;
  }

  OrphansCompanion toCompanion(bool nullToAbsent) {
    return OrphansCompanion(
      orphanId: Value(orphanId),
      fullName: Value(fullName),
      dateOfBirth: Value(dateOfBirth),
      status: Value(status),
      lastSeenLocation: lastSeenLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenLocation),
      lastUpdated: Value(lastUpdated),
      supervisorId: Value(supervisorId),
    );
  }

  factory Orphan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Orphan(
      orphanId: serializer.fromJson<String>(json['orphanId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      status: $OrphansTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      lastSeenLocation: serializer.fromJson<String?>(json['lastSeenLocation']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      supervisorId: serializer.fromJson<String>(json['supervisorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orphanId': serializer.toJson<String>(orphanId),
      'fullName': serializer.toJson<String>(fullName),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'status':
          serializer.toJson<int>($OrphansTable.$converterstatus.toJson(status)),
      'lastSeenLocation': serializer.toJson<String?>(lastSeenLocation),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'supervisorId': serializer.toJson<String>(supervisorId),
    };
  }

  Orphan copyWith(
          {String? orphanId,
          String? fullName,
          DateTime? dateOfBirth,
          OrphanStatus? status,
          Value<String?> lastSeenLocation = const Value.absent(),
          DateTime? lastUpdated,
          String? supervisorId}) =>
      Orphan(
        orphanId: orphanId ?? this.orphanId,
        fullName: fullName ?? this.fullName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        status: status ?? this.status,
        lastSeenLocation: lastSeenLocation.present
            ? lastSeenLocation.value
            : this.lastSeenLocation,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        supervisorId: supervisorId ?? this.supervisorId,
      );
  Orphan copyWithCompanion(OrphansCompanion data) {
    return Orphan(
      orphanId: data.orphanId.present ? data.orphanId.value : this.orphanId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      status: data.status.present ? data.status.value : this.status,
      lastSeenLocation: data.lastSeenLocation.present
          ? data.lastSeenLocation.value
          : this.lastSeenLocation,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Orphan(')
          ..write('orphanId: $orphanId, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('status: $status, ')
          ..write('lastSeenLocation: $lastSeenLocation, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('supervisorId: $supervisorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(orphanId, fullName, dateOfBirth, status,
      lastSeenLocation, lastUpdated, supervisorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Orphan &&
          other.orphanId == this.orphanId &&
          other.fullName == this.fullName &&
          other.dateOfBirth == this.dateOfBirth &&
          other.status == this.status &&
          other.lastSeenLocation == this.lastSeenLocation &&
          other.lastUpdated == this.lastUpdated &&
          other.supervisorId == this.supervisorId);
}

class OrphansCompanion extends UpdateCompanion<Orphan> {
  final Value<String> orphanId;
  final Value<String> fullName;
  final Value<DateTime> dateOfBirth;
  final Value<OrphanStatus> status;
  final Value<String?> lastSeenLocation;
  final Value<DateTime> lastUpdated;
  final Value<String> supervisorId;
  final Value<int> rowid;
  const OrphansCompanion({
    this.orphanId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.status = const Value.absent(),
    this.lastSeenLocation = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrphansCompanion.insert({
    this.orphanId = const Value.absent(),
    required String fullName,
    required DateTime dateOfBirth,
    required OrphanStatus status,
    this.lastSeenLocation = const Value.absent(),
    required DateTime lastUpdated,
    required String supervisorId,
    this.rowid = const Value.absent(),
  })  : fullName = Value(fullName),
        dateOfBirth = Value(dateOfBirth),
        status = Value(status),
        lastUpdated = Value(lastUpdated),
        supervisorId = Value(supervisorId);
  static Insertable<Orphan> custom({
    Expression<String>? orphanId,
    Expression<String>? fullName,
    Expression<DateTime>? dateOfBirth,
    Expression<int>? status,
    Expression<String>? lastSeenLocation,
    Expression<DateTime>? lastUpdated,
    Expression<String>? supervisorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orphanId != null) 'orphan_id': orphanId,
      if (fullName != null) 'full_name': fullName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (status != null) 'status': status,
      if (lastSeenLocation != null) 'last_seen_location': lastSeenLocation,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrphansCompanion copyWith(
      {Value<String>? orphanId,
      Value<String>? fullName,
      Value<DateTime>? dateOfBirth,
      Value<OrphanStatus>? status,
      Value<String?>? lastSeenLocation,
      Value<DateTime>? lastUpdated,
      Value<String>? supervisorId,
      Value<int>? rowid}) {
    return OrphansCompanion(
      orphanId: orphanId ?? this.orphanId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
      lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      supervisorId: supervisorId ?? this.supervisorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orphanId.present) {
      map['orphan_id'] = Variable<String>(orphanId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrphansCompanion(')
          ..write('orphanId: $orphanId, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('status: $status, ')
          ..write('lastSeenLocation: $lastSeenLocation, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('supervisorId: $supervisorId, ')
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
  required String fullName,
  required DateTime dateOfBirth,
  required OrphanStatus status,
  Value<String?> lastSeenLocation,
  required DateTime lastUpdated,
  required String supervisorId,
  Value<int> rowid,
});
typedef $$OrphansTableUpdateCompanionBuilder = OrphansCompanion Function({
  Value<String> orphanId,
  Value<String> fullName,
  Value<DateTime> dateOfBirth,
  Value<OrphanStatus> status,
  Value<String?> lastSeenLocation,
  Value<DateTime> lastUpdated,
  Value<String> supervisorId,
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

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrphanStatus, OrphanStatus, int> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrphanStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastSeenLocation => $composableBuilder(
      column: $table.lastSeenLocation, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

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
            Value<String> fullName = const Value.absent(),
            Value<DateTime> dateOfBirth = const Value.absent(),
            Value<OrphanStatus> status = const Value.absent(),
            Value<String?> lastSeenLocation = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<String> supervisorId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrphansCompanion(
            orphanId: orphanId,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            status: status,
            lastSeenLocation: lastSeenLocation,
            lastUpdated: lastUpdated,
            supervisorId: supervisorId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> orphanId = const Value.absent(),
            required String fullName,
            required DateTime dateOfBirth,
            required OrphanStatus status,
            Value<String?> lastSeenLocation = const Value.absent(),
            required DateTime lastUpdated,
            required String supervisorId,
            Value<int> rowid = const Value.absent(),
          }) =>
              OrphansCompanion.insert(
            orphanId: orphanId,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            status: status,
            lastSeenLocation: lastSeenLocation,
            lastUpdated: lastUpdated,
            supervisorId: supervisorId,
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
