// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kakaoIdMeta = const VerificationMeta(
    'kakaoId',
  );
  @override
  late final GeneratedColumn<String> kakaoId = GeneratedColumn<String>(
    'kakao_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('사용자'),
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPledgesMeta = const VerificationMeta(
    'totalPledges',
  );
  @override
  late final GeneratedColumn<int> totalPledges = GeneratedColumn<int>(
    'total_pledges',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _successPledgesMeta = const VerificationMeta(
    'successPledges',
  );
  @override
  late final GeneratedColumn<int> successPledges = GeneratedColumn<int>(
    'success_pledges',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kakaoId,
    accessToken,
    nickname,
    profileImageUrl,
    totalPledges,
    successPledges,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kakao_id')) {
      context.handle(
        _kakaoIdMeta,
        kakaoId.isAcceptableOrUnknown(data['kakao_id']!, _kakaoIdMeta),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('total_pledges')) {
      context.handle(
        _totalPledgesMeta,
        totalPledges.isAcceptableOrUnknown(
          data['total_pledges']!,
          _totalPledgesMeta,
        ),
      );
    }
    if (data.containsKey('success_pledges')) {
      context.handle(
        _successPledgesMeta,
        successPledges.isAcceptableOrUnknown(
          data['success_pledges']!,
          _successPledgesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kakaoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kakao_id'],
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      totalPledges: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pledges'],
      )!,
      successPledges: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}success_pledges'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;

  /// 카카오 고유 ID (연동 전 null)
  final String? kakaoId;

  /// 카카오 액세스 토큰 (KakaoPay 결제에 사용)
  final String? accessToken;
  final String nickname;
  final String? profileImageUrl;
  final int totalPledges;
  final int successPledges;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    this.kakaoId,
    this.accessToken,
    required this.nickname,
    this.profileImageUrl,
    required this.totalPledges,
    required this.successPledges,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || kakaoId != null) {
      map['kakao_id'] = Variable<String>(kakaoId);
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    map['total_pledges'] = Variable<int>(totalPledges);
    map['success_pledges'] = Variable<int>(successPledges);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      kakaoId: kakaoId == null && nullToAbsent
          ? const Value.absent()
          : Value(kakaoId),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      nickname: Value(nickname),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      totalPledges: Value(totalPledges),
      successPledges: Value(successPledges),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      kakaoId: serializer.fromJson<String?>(json['kakaoId']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      nickname: serializer.fromJson<String>(json['nickname']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      totalPledges: serializer.fromJson<int>(json['totalPledges']),
      successPledges: serializer.fromJson<int>(json['successPledges']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kakaoId': serializer.toJson<String?>(kakaoId),
      'accessToken': serializer.toJson<String?>(accessToken),
      'nickname': serializer.toJson<String>(nickname),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'totalPledges': serializer.toJson<int>(totalPledges),
      'successPledges': serializer.toJson<int>(successPledges),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    Value<String?> kakaoId = const Value.absent(),
    Value<String?> accessToken = const Value.absent(),
    String? nickname,
    Value<String?> profileImageUrl = const Value.absent(),
    int? totalPledges,
    int? successPledges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    kakaoId: kakaoId.present ? kakaoId.value : this.kakaoId,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    nickname: nickname ?? this.nickname,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    totalPledges: totalPledges ?? this.totalPledges,
    successPledges: successPledges ?? this.successPledges,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      kakaoId: data.kakaoId.present ? data.kakaoId.value : this.kakaoId,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      totalPledges: data.totalPledges.present
          ? data.totalPledges.value
          : this.totalPledges,
      successPledges: data.successPledges.present
          ? data.successPledges.value
          : this.successPledges,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('kakaoId: $kakaoId, ')
          ..write('accessToken: $accessToken, ')
          ..write('nickname: $nickname, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('totalPledges: $totalPledges, ')
          ..write('successPledges: $successPledges, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kakaoId,
    accessToken,
    nickname,
    profileImageUrl,
    totalPledges,
    successPledges,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.kakaoId == this.kakaoId &&
          other.accessToken == this.accessToken &&
          other.nickname == this.nickname &&
          other.profileImageUrl == this.profileImageUrl &&
          other.totalPledges == this.totalPledges &&
          other.successPledges == this.successPledges &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String?> kakaoId;
  final Value<String?> accessToken;
  final Value<String> nickname;
  final Value<String?> profileImageUrl;
  final Value<int> totalPledges;
  final Value<int> successPledges;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.kakaoId = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.nickname = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.totalPledges = const Value.absent(),
    this.successPledges = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.kakaoId = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.nickname = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.totalPledges = const Value.absent(),
    this.successPledges = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? kakaoId,
    Expression<String>? accessToken,
    Expression<String>? nickname,
    Expression<String>? profileImageUrl,
    Expression<int>? totalPledges,
    Expression<int>? successPledges,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kakaoId != null) 'kakao_id': kakaoId,
      if (accessToken != null) 'access_token': accessToken,
      if (nickname != null) 'nickname': nickname,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (totalPledges != null) 'total_pledges': totalPledges,
      if (successPledges != null) 'success_pledges': successPledges,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String?>? kakaoId,
    Value<String?>? accessToken,
    Value<String>? nickname,
    Value<String?>? profileImageUrl,
    Value<int>? totalPledges,
    Value<int>? successPledges,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      kakaoId: kakaoId ?? this.kakaoId,
      accessToken: accessToken ?? this.accessToken,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      totalPledges: totalPledges ?? this.totalPledges,
      successPledges: successPledges ?? this.successPledges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kakaoId.present) {
      map['kakao_id'] = Variable<String>(kakaoId.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (totalPledges.present) {
      map['total_pledges'] = Variable<int>(totalPledges.value);
    }
    if (successPledges.present) {
      map['success_pledges'] = Variable<int>(successPledges.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('kakaoId: $kakaoId, ')
          ..write('accessToken: $accessToken, ')
          ..write('nickname: $nickname, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('totalPledges: $totalPledges, ')
          ..write('successPledges: $successPledges, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VowsTable extends Vows with TableInfo<$VowsTable, Vow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pledgeTypeMeta = const VerificationMeta(
    'pledgeType',
  );
  @override
  late final GeneratedColumn<String> pledgeType = GeneratedColumn<String>(
    'pledge_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _conditionJsonMeta = const VerificationMeta(
    'conditionJson',
  );
  @override
  late final GeneratedColumn<String> conditionJson = GeneratedColumn<String>(
    'condition_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _penaltyAmountMeta = const VerificationMeta(
    'penaltyAmount',
  );
  @override
  late final GeneratedColumn<int> penaltyAmount = GeneratedColumn<int>(
    'penalty_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _penaltyRecipientMeta = const VerificationMeta(
    'penaltyRecipient',
  );
  @override
  late final GeneratedColumn<String> penaltyRecipient = GeneratedColumn<String>(
    'penalty_recipient',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verificationIntervalDaysMeta =
      const VerificationMeta('verificationIntervalDays');
  @override
  late final GeneratedColumn<int> verificationIntervalDays =
      GeneratedColumn<int>(
        'verification_interval_days',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      );
  static const VerificationMeta _totalVerificationsMeta =
      const VerificationMeta('totalVerifications');
  @override
  late final GeneratedColumn<int> totalVerifications = GeneratedColumn<int>(
    'total_verifications',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _passedVerificationsMeta =
      const VerificationMeta('passedVerifications');
  @override
  late final GeneratedColumn<int> passedVerifications = GeneratedColumn<int>(
    'passed_verifications',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalFinesPaidMeta = const VerificationMeta(
    'totalFinesPaid',
  );
  @override
  late final GeneratedColumn<int> totalFinesPaid = GeneratedColumn<int>(
    'total_fines_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    description,
    pledgeType,
    status,
    conditionJson,
    penaltyAmount,
    penaltyRecipient,
    startDate,
    endDate,
    verificationIntervalDays,
    totalVerifications,
    passedVerifications,
    totalFinesPaid,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vows';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('pledge_type')) {
      context.handle(
        _pledgeTypeMeta,
        pledgeType.isAcceptableOrUnknown(data['pledge_type']!, _pledgeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_pledgeTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('condition_json')) {
      context.handle(
        _conditionJsonMeta,
        conditionJson.isAcceptableOrUnknown(
          data['condition_json']!,
          _conditionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionJsonMeta);
    }
    if (data.containsKey('penalty_amount')) {
      context.handle(
        _penaltyAmountMeta,
        penaltyAmount.isAcceptableOrUnknown(
          data['penalty_amount']!,
          _penaltyAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_penaltyAmountMeta);
    }
    if (data.containsKey('penalty_recipient')) {
      context.handle(
        _penaltyRecipientMeta,
        penaltyRecipient.isAcceptableOrUnknown(
          data['penalty_recipient']!,
          _penaltyRecipientMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('verification_interval_days')) {
      context.handle(
        _verificationIntervalDaysMeta,
        verificationIntervalDays.isAcceptableOrUnknown(
          data['verification_interval_days']!,
          _verificationIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('total_verifications')) {
      context.handle(
        _totalVerificationsMeta,
        totalVerifications.isAcceptableOrUnknown(
          data['total_verifications']!,
          _totalVerificationsMeta,
        ),
      );
    }
    if (data.containsKey('passed_verifications')) {
      context.handle(
        _passedVerificationsMeta,
        passedVerifications.isAcceptableOrUnknown(
          data['passed_verifications']!,
          _passedVerificationsMeta,
        ),
      );
    }
    if (data.containsKey('total_fines_paid')) {
      context.handle(
        _totalFinesPaidMeta,
        totalFinesPaid.isAcceptableOrUnknown(
          data['total_fines_paid']!,
          _totalFinesPaidMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      pledgeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pledge_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      conditionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_json'],
      )!,
      penaltyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}penalty_amount'],
      )!,
      penaltyRecipient: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}penalty_recipient'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      verificationIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verification_interval_days'],
      )!,
      totalVerifications: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_verifications'],
      )!,
      passedVerifications: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}passed_verifications'],
      )!,
      totalFinesPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_fines_paid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VowsTable createAlias(String alias) {
    return $VowsTable(attachedDatabase, alias);
  }
}

class Vow extends DataClass implements Insertable<Vow> {
  final int id;
  final int userId;
  final String title;
  final String? description;

  /// VowType.name 문자열 저장
  /// (screenTime | sleep | steps | exercise | custom)
  final String pledgeType;

  /// PledgeStatus.name 문자열 저장
  final String status;

  /// VowCondition JSON 문자열
  final String conditionJson;

  /// 위반 1회당 벌금 (원)
  final int penaltyAmount;

  /// 기부 단체명 또는 지인 이름 (null = 미설정)
  final String? penaltyRecipient;
  final DateTime startDate;
  final DateTime endDate;

  /// 검증 주기 (일 단위, 1 = 매일)
  final int verificationIntervalDays;
  final int totalVerifications;
  final int passedVerifications;

  /// 누적 납부 벌금 총액 (원)
  final int totalFinesPaid;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Vow({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.pledgeType,
    required this.status,
    required this.conditionJson,
    required this.penaltyAmount,
    this.penaltyRecipient,
    required this.startDate,
    required this.endDate,
    required this.verificationIntervalDays,
    required this.totalVerifications,
    required this.passedVerifications,
    required this.totalFinesPaid,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['pledge_type'] = Variable<String>(pledgeType);
    map['status'] = Variable<String>(status);
    map['condition_json'] = Variable<String>(conditionJson);
    map['penalty_amount'] = Variable<int>(penaltyAmount);
    if (!nullToAbsent || penaltyRecipient != null) {
      map['penalty_recipient'] = Variable<String>(penaltyRecipient);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['verification_interval_days'] = Variable<int>(verificationIntervalDays);
    map['total_verifications'] = Variable<int>(totalVerifications);
    map['passed_verifications'] = Variable<int>(passedVerifications);
    map['total_fines_paid'] = Variable<int>(totalFinesPaid);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VowsCompanion toCompanion(bool nullToAbsent) {
    return VowsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      pledgeType: Value(pledgeType),
      status: Value(status),
      conditionJson: Value(conditionJson),
      penaltyAmount: Value(penaltyAmount),
      penaltyRecipient: penaltyRecipient == null && nullToAbsent
          ? const Value.absent()
          : Value(penaltyRecipient),
      startDate: Value(startDate),
      endDate: Value(endDate),
      verificationIntervalDays: Value(verificationIntervalDays),
      totalVerifications: Value(totalVerifications),
      passedVerifications: Value(passedVerifications),
      totalFinesPaid: Value(totalFinesPaid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Vow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      pledgeType: serializer.fromJson<String>(json['pledgeType']),
      status: serializer.fromJson<String>(json['status']),
      conditionJson: serializer.fromJson<String>(json['conditionJson']),
      penaltyAmount: serializer.fromJson<int>(json['penaltyAmount']),
      penaltyRecipient: serializer.fromJson<String?>(json['penaltyRecipient']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      verificationIntervalDays: serializer.fromJson<int>(
        json['verificationIntervalDays'],
      ),
      totalVerifications: serializer.fromJson<int>(json['totalVerifications']),
      passedVerifications: serializer.fromJson<int>(
        json['passedVerifications'],
      ),
      totalFinesPaid: serializer.fromJson<int>(json['totalFinesPaid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'pledgeType': serializer.toJson<String>(pledgeType),
      'status': serializer.toJson<String>(status),
      'conditionJson': serializer.toJson<String>(conditionJson),
      'penaltyAmount': serializer.toJson<int>(penaltyAmount),
      'penaltyRecipient': serializer.toJson<String?>(penaltyRecipient),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'verificationIntervalDays': serializer.toJson<int>(
        verificationIntervalDays,
      ),
      'totalVerifications': serializer.toJson<int>(totalVerifications),
      'passedVerifications': serializer.toJson<int>(passedVerifications),
      'totalFinesPaid': serializer.toJson<int>(totalFinesPaid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Vow copyWith({
    int? id,
    int? userId,
    String? title,
    Value<String?> description = const Value.absent(),
    String? pledgeType,
    String? status,
    String? conditionJson,
    int? penaltyAmount,
    Value<String?> penaltyRecipient = const Value.absent(),
    DateTime? startDate,
    DateTime? endDate,
    int? verificationIntervalDays,
    int? totalVerifications,
    int? passedVerifications,
    int? totalFinesPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Vow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    pledgeType: pledgeType ?? this.pledgeType,
    status: status ?? this.status,
    conditionJson: conditionJson ?? this.conditionJson,
    penaltyAmount: penaltyAmount ?? this.penaltyAmount,
    penaltyRecipient: penaltyRecipient.present
        ? penaltyRecipient.value
        : this.penaltyRecipient,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    verificationIntervalDays:
        verificationIntervalDays ?? this.verificationIntervalDays,
    totalVerifications: totalVerifications ?? this.totalVerifications,
    passedVerifications: passedVerifications ?? this.passedVerifications,
    totalFinesPaid: totalFinesPaid ?? this.totalFinesPaid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Vow copyWithCompanion(VowsCompanion data) {
    return Vow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      pledgeType: data.pledgeType.present
          ? data.pledgeType.value
          : this.pledgeType,
      status: data.status.present ? data.status.value : this.status,
      conditionJson: data.conditionJson.present
          ? data.conditionJson.value
          : this.conditionJson,
      penaltyAmount: data.penaltyAmount.present
          ? data.penaltyAmount.value
          : this.penaltyAmount,
      penaltyRecipient: data.penaltyRecipient.present
          ? data.penaltyRecipient.value
          : this.penaltyRecipient,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      verificationIntervalDays: data.verificationIntervalDays.present
          ? data.verificationIntervalDays.value
          : this.verificationIntervalDays,
      totalVerifications: data.totalVerifications.present
          ? data.totalVerifications.value
          : this.totalVerifications,
      passedVerifications: data.passedVerifications.present
          ? data.passedVerifications.value
          : this.passedVerifications,
      totalFinesPaid: data.totalFinesPaid.present
          ? data.totalFinesPaid.value
          : this.totalFinesPaid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('pledgeType: $pledgeType, ')
          ..write('status: $status, ')
          ..write('conditionJson: $conditionJson, ')
          ..write('penaltyAmount: $penaltyAmount, ')
          ..write('penaltyRecipient: $penaltyRecipient, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('verificationIntervalDays: $verificationIntervalDays, ')
          ..write('totalVerifications: $totalVerifications, ')
          ..write('passedVerifications: $passedVerifications, ')
          ..write('totalFinesPaid: $totalFinesPaid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    description,
    pledgeType,
    status,
    conditionJson,
    penaltyAmount,
    penaltyRecipient,
    startDate,
    endDate,
    verificationIntervalDays,
    totalVerifications,
    passedVerifications,
    totalFinesPaid,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.pledgeType == this.pledgeType &&
          other.status == this.status &&
          other.conditionJson == this.conditionJson &&
          other.penaltyAmount == this.penaltyAmount &&
          other.penaltyRecipient == this.penaltyRecipient &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.verificationIntervalDays == this.verificationIntervalDays &&
          other.totalVerifications == this.totalVerifications &&
          other.passedVerifications == this.passedVerifications &&
          other.totalFinesPaid == this.totalFinesPaid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VowsCompanion extends UpdateCompanion<Vow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> pledgeType;
  final Value<String> status;
  final Value<String> conditionJson;
  final Value<int> penaltyAmount;
  final Value<String?> penaltyRecipient;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> verificationIntervalDays;
  final Value<int> totalVerifications;
  final Value<int> passedVerifications;
  final Value<int> totalFinesPaid;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.pledgeType = const Value.absent(),
    this.status = const Value.absent(),
    this.conditionJson = const Value.absent(),
    this.penaltyAmount = const Value.absent(),
    this.penaltyRecipient = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.verificationIntervalDays = const Value.absent(),
    this.totalVerifications = const Value.absent(),
    this.passedVerifications = const Value.absent(),
    this.totalFinesPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String title,
    this.description = const Value.absent(),
    required String pledgeType,
    this.status = const Value.absent(),
    required String conditionJson,
    required int penaltyAmount,
    this.penaltyRecipient = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.verificationIntervalDays = const Value.absent(),
    this.totalVerifications = const Value.absent(),
    this.passedVerifications = const Value.absent(),
    this.totalFinesPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       title = Value(title),
       pledgeType = Value(pledgeType),
       conditionJson = Value(conditionJson),
       penaltyAmount = Value(penaltyAmount),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Vow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? pledgeType,
    Expression<String>? status,
    Expression<String>? conditionJson,
    Expression<int>? penaltyAmount,
    Expression<String>? penaltyRecipient,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? verificationIntervalDays,
    Expression<int>? totalVerifications,
    Expression<int>? passedVerifications,
    Expression<int>? totalFinesPaid,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (pledgeType != null) 'pledge_type': pledgeType,
      if (status != null) 'status': status,
      if (conditionJson != null) 'condition_json': conditionJson,
      if (penaltyAmount != null) 'penalty_amount': penaltyAmount,
      if (penaltyRecipient != null) 'penalty_recipient': penaltyRecipient,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (verificationIntervalDays != null)
        'verification_interval_days': verificationIntervalDays,
      if (totalVerifications != null) 'total_verifications': totalVerifications,
      if (passedVerifications != null)
        'passed_verifications': passedVerifications,
      if (totalFinesPaid != null) 'total_fines_paid': totalFinesPaid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? pledgeType,
    Value<String>? status,
    Value<String>? conditionJson,
    Value<int>? penaltyAmount,
    Value<String?>? penaltyRecipient,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? verificationIntervalDays,
    Value<int>? totalVerifications,
    Value<int>? passedVerifications,
    Value<int>? totalFinesPaid,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      pledgeType: pledgeType ?? this.pledgeType,
      status: status ?? this.status,
      conditionJson: conditionJson ?? this.conditionJson,
      penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      penaltyRecipient: penaltyRecipient ?? this.penaltyRecipient,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      verificationIntervalDays:
          verificationIntervalDays ?? this.verificationIntervalDays,
      totalVerifications: totalVerifications ?? this.totalVerifications,
      passedVerifications: passedVerifications ?? this.passedVerifications,
      totalFinesPaid: totalFinesPaid ?? this.totalFinesPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pledgeType.present) {
      map['pledge_type'] = Variable<String>(pledgeType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (conditionJson.present) {
      map['condition_json'] = Variable<String>(conditionJson.value);
    }
    if (penaltyAmount.present) {
      map['penalty_amount'] = Variable<int>(penaltyAmount.value);
    }
    if (penaltyRecipient.present) {
      map['penalty_recipient'] = Variable<String>(penaltyRecipient.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (verificationIntervalDays.present) {
      map['verification_interval_days'] = Variable<int>(
        verificationIntervalDays.value,
      );
    }
    if (totalVerifications.present) {
      map['total_verifications'] = Variable<int>(totalVerifications.value);
    }
    if (passedVerifications.present) {
      map['passed_verifications'] = Variable<int>(passedVerifications.value);
    }
    if (totalFinesPaid.present) {
      map['total_fines_paid'] = Variable<int>(totalFinesPaid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('pledgeType: $pledgeType, ')
          ..write('status: $status, ')
          ..write('conditionJson: $conditionJson, ')
          ..write('penaltyAmount: $penaltyAmount, ')
          ..write('penaltyRecipient: $penaltyRecipient, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('verificationIntervalDays: $verificationIntervalDays, ')
          ..write('totalVerifications: $totalVerifications, ')
          ..write('passedVerifications: $passedVerifications, ')
          ..write('totalFinesPaid: $totalFinesPaid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VerificationsTable extends Verifications
    with TableInfo<$VerificationsTable, Verification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vowIdMeta = const VerificationMeta('vowId');
  @override
  late final GeneratedColumn<int> vowId = GeneratedColumn<int>(
    'vow_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vows (id)',
    ),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verifiedAtMeta = const VerificationMeta(
    'verifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> verifiedAt = GeneratedColumn<DateTime>(
    'verified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPassedMeta = const VerificationMeta(
    'isPassed',
  );
  @override
  late final GeneratedColumn<bool> isPassed = GeneratedColumn<bool>(
    'is_passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _measuredDataJsonMeta = const VerificationMeta(
    'measuredDataJson',
  );
  @override
  late final GeneratedColumn<String> measuredDataJson = GeneratedColumn<String>(
    'measured_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vowId,
    targetDate,
    verifiedAt,
    isPassed,
    measuredDataJson,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vow_id')) {
      context.handle(
        _vowIdMeta,
        vowId.isAcceptableOrUnknown(data['vow_id']!, _vowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vowIdMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('verified_at')) {
      context.handle(
        _verifiedAtMeta,
        verifiedAt.isAcceptableOrUnknown(data['verified_at']!, _verifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_verifiedAtMeta);
    }
    if (data.containsKey('is_passed')) {
      context.handle(
        _isPassedMeta,
        isPassed.isAcceptableOrUnknown(data['is_passed']!, _isPassedMeta),
      );
    } else if (isInserting) {
      context.missing(_isPassedMeta);
    }
    if (data.containsKey('measured_data_json')) {
      context.handle(
        _measuredDataJsonMeta,
        measuredDataJson.isAcceptableOrUnknown(
          data['measured_data_json']!,
          _measuredDataJsonMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vow_id'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      verifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}verified_at'],
      )!,
      isPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_passed'],
      )!,
      measuredDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measured_data_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VerificationsTable createAlias(String alias) {
    return $VerificationsTable(attachedDatabase, alias);
  }
}

class Verification extends DataClass implements Insertable<Verification> {
  final int id;
  final int vowId;

  /// 검증 대상 날짜 (당일 자정 기준)
  final DateTime targetDate;

  /// 실제 검증 수행 시각
  final DateTime verifiedAt;
  final bool isPassed;

  /// 측정된 실제 값 JSON (예: {"steps": 8500, "duration_min": 0})
  final String? measuredDataJson;

  /// 수동 메모
  final String? notes;
  final DateTime createdAt;
  const Verification({
    required this.id,
    required this.vowId,
    required this.targetDate,
    required this.verifiedAt,
    required this.isPassed,
    this.measuredDataJson,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vow_id'] = Variable<int>(vowId);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['verified_at'] = Variable<DateTime>(verifiedAt);
    map['is_passed'] = Variable<bool>(isPassed);
    if (!nullToAbsent || measuredDataJson != null) {
      map['measured_data_json'] = Variable<String>(measuredDataJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VerificationsCompanion toCompanion(bool nullToAbsent) {
    return VerificationsCompanion(
      id: Value(id),
      vowId: Value(vowId),
      targetDate: Value(targetDate),
      verifiedAt: Value(verifiedAt),
      isPassed: Value(isPassed),
      measuredDataJson: measuredDataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(measuredDataJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Verification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verification(
      id: serializer.fromJson<int>(json['id']),
      vowId: serializer.fromJson<int>(json['vowId']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      verifiedAt: serializer.fromJson<DateTime>(json['verifiedAt']),
      isPassed: serializer.fromJson<bool>(json['isPassed']),
      measuredDataJson: serializer.fromJson<String?>(json['measuredDataJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vowId': serializer.toJson<int>(vowId),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'verifiedAt': serializer.toJson<DateTime>(verifiedAt),
      'isPassed': serializer.toJson<bool>(isPassed),
      'measuredDataJson': serializer.toJson<String?>(measuredDataJson),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Verification copyWith({
    int? id,
    int? vowId,
    DateTime? targetDate,
    DateTime? verifiedAt,
    bool? isPassed,
    Value<String?> measuredDataJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Verification(
    id: id ?? this.id,
    vowId: vowId ?? this.vowId,
    targetDate: targetDate ?? this.targetDate,
    verifiedAt: verifiedAt ?? this.verifiedAt,
    isPassed: isPassed ?? this.isPassed,
    measuredDataJson: measuredDataJson.present
        ? measuredDataJson.value
        : this.measuredDataJson,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Verification copyWithCompanion(VerificationsCompanion data) {
    return Verification(
      id: data.id.present ? data.id.value : this.id,
      vowId: data.vowId.present ? data.vowId.value : this.vowId,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      verifiedAt: data.verifiedAt.present
          ? data.verifiedAt.value
          : this.verifiedAt,
      isPassed: data.isPassed.present ? data.isPassed.value : this.isPassed,
      measuredDataJson: data.measuredDataJson.present
          ? data.measuredDataJson.value
          : this.measuredDataJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verification(')
          ..write('id: $id, ')
          ..write('vowId: $vowId, ')
          ..write('targetDate: $targetDate, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('isPassed: $isPassed, ')
          ..write('measuredDataJson: $measuredDataJson, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vowId,
    targetDate,
    verifiedAt,
    isPassed,
    measuredDataJson,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verification &&
          other.id == this.id &&
          other.vowId == this.vowId &&
          other.targetDate == this.targetDate &&
          other.verifiedAt == this.verifiedAt &&
          other.isPassed == this.isPassed &&
          other.measuredDataJson == this.measuredDataJson &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class VerificationsCompanion extends UpdateCompanion<Verification> {
  final Value<int> id;
  final Value<int> vowId;
  final Value<DateTime> targetDate;
  final Value<DateTime> verifiedAt;
  final Value<bool> isPassed;
  final Value<String?> measuredDataJson;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const VerificationsCompanion({
    this.id = const Value.absent(),
    this.vowId = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.isPassed = const Value.absent(),
    this.measuredDataJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VerificationsCompanion.insert({
    this.id = const Value.absent(),
    required int vowId,
    required DateTime targetDate,
    required DateTime verifiedAt,
    required bool isPassed,
    this.measuredDataJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vowId = Value(vowId),
       targetDate = Value(targetDate),
       verifiedAt = Value(verifiedAt),
       isPassed = Value(isPassed);
  static Insertable<Verification> custom({
    Expression<int>? id,
    Expression<int>? vowId,
    Expression<DateTime>? targetDate,
    Expression<DateTime>? verifiedAt,
    Expression<bool>? isPassed,
    Expression<String>? measuredDataJson,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vowId != null) 'vow_id': vowId,
      if (targetDate != null) 'target_date': targetDate,
      if (verifiedAt != null) 'verified_at': verifiedAt,
      if (isPassed != null) 'is_passed': isPassed,
      if (measuredDataJson != null) 'measured_data_json': measuredDataJson,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VerificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? vowId,
    Value<DateTime>? targetDate,
    Value<DateTime>? verifiedAt,
    Value<bool>? isPassed,
    Value<String?>? measuredDataJson,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return VerificationsCompanion(
      id: id ?? this.id,
      vowId: vowId ?? this.vowId,
      targetDate: targetDate ?? this.targetDate,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isPassed: isPassed ?? this.isPassed,
      measuredDataJson: measuredDataJson ?? this.measuredDataJson,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vowId.present) {
      map['vow_id'] = Variable<int>(vowId.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (verifiedAt.present) {
      map['verified_at'] = Variable<DateTime>(verifiedAt.value);
    }
    if (isPassed.present) {
      map['is_passed'] = Variable<bool>(isPassed.value);
    }
    if (measuredDataJson.present) {
      map['measured_data_json'] = Variable<String>(measuredDataJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerificationsCompanion(')
          ..write('id: $id, ')
          ..write('vowId: $vowId, ')
          ..write('targetDate: $targetDate, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('isPassed: $isPassed, ')
          ..write('measuredDataJson: $measuredDataJson, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ViolationsTable extends Violations
    with TableInfo<$ViolationsTable, Violation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ViolationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vowIdMeta = const VerificationMeta('vowId');
  @override
  late final GeneratedColumn<int> vowId = GeneratedColumn<int>(
    'vow_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vows (id)',
    ),
  );
  static const VerificationMeta _verificationIdMeta = const VerificationMeta(
    'verificationId',
  );
  @override
  late final GeneratedColumn<int> verificationId = GeneratedColumn<int>(
    'verification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES verifications (id)',
    ),
  );
  static const VerificationMeta _violatedAtMeta = const VerificationMeta(
    'violatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> violatedAt = GeneratedColumn<DateTime>(
    'violated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _penaltyAmountMeta = const VerificationMeta(
    'penaltyAmount',
  );
  @override
  late final GeneratedColumn<int> penaltyAmount = GeneratedColumn<int>(
    'penalty_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _kakaoTidMeta = const VerificationMeta(
    'kakaoTid',
  );
  @override
  late final GeneratedColumn<String> kakaoTid = GeneratedColumn<String>(
    'kakao_tid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kakaoApprovalUrlMeta = const VerificationMeta(
    'kakaoApprovalUrl',
  );
  @override
  late final GeneratedColumn<String> kakaoApprovalUrl = GeneratedColumn<String>(
    'kakao_approval_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentErrorMessageMeta =
      const VerificationMeta('paymentErrorMessage');
  @override
  late final GeneratedColumn<String> paymentErrorMessage =
      GeneratedColumn<String>(
        'payment_error_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vowId,
    verificationId,
    violatedAt,
    penaltyAmount,
    paymentStatus,
    kakaoTid,
    kakaoApprovalUrl,
    paymentErrorMessage,
    paidAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'violations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Violation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vow_id')) {
      context.handle(
        _vowIdMeta,
        vowId.isAcceptableOrUnknown(data['vow_id']!, _vowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vowIdMeta);
    }
    if (data.containsKey('verification_id')) {
      context.handle(
        _verificationIdMeta,
        verificationId.isAcceptableOrUnknown(
          data['verification_id']!,
          _verificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verificationIdMeta);
    }
    if (data.containsKey('violated_at')) {
      context.handle(
        _violatedAtMeta,
        violatedAt.isAcceptableOrUnknown(data['violated_at']!, _violatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_violatedAtMeta);
    }
    if (data.containsKey('penalty_amount')) {
      context.handle(
        _penaltyAmountMeta,
        penaltyAmount.isAcceptableOrUnknown(
          data['penalty_amount']!,
          _penaltyAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_penaltyAmountMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('kakao_tid')) {
      context.handle(
        _kakaoTidMeta,
        kakaoTid.isAcceptableOrUnknown(data['kakao_tid']!, _kakaoTidMeta),
      );
    }
    if (data.containsKey('kakao_approval_url')) {
      context.handle(
        _kakaoApprovalUrlMeta,
        kakaoApprovalUrl.isAcceptableOrUnknown(
          data['kakao_approval_url']!,
          _kakaoApprovalUrlMeta,
        ),
      );
    }
    if (data.containsKey('payment_error_message')) {
      context.handle(
        _paymentErrorMessageMeta,
        paymentErrorMessage.isAcceptableOrUnknown(
          data['payment_error_message']!,
          _paymentErrorMessageMeta,
        ),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Violation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Violation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vow_id'],
      )!,
      verificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verification_id'],
      )!,
      violatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}violated_at'],
      )!,
      penaltyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}penalty_amount'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      kakaoTid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kakao_tid'],
      ),
      kakaoApprovalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kakao_approval_url'],
      ),
      paymentErrorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_error_message'],
      ),
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ViolationsTable createAlias(String alias) {
    return $ViolationsTable(attachedDatabase, alias);
  }
}

class Violation extends DataClass implements Insertable<Violation> {
  final int id;
  final int vowId;
  final int verificationId;
  final DateTime violatedAt;

  /// 해당 위반의 부과 벌금 (원)
  final int penaltyAmount;

  /// PaymentStatus.name 문자열
  /// (pending | processing | completed | failed)
  final String paymentStatus;

  /// 카카오페이 거래 고유 ID (TID)
  final String? kakaoTid;

  /// 카카오페이 결제 승인 ID
  final String? kakaoApprovalUrl;
  final String? paymentErrorMessage;
  final DateTime? paidAt;
  final DateTime createdAt;
  const Violation({
    required this.id,
    required this.vowId,
    required this.verificationId,
    required this.violatedAt,
    required this.penaltyAmount,
    required this.paymentStatus,
    this.kakaoTid,
    this.kakaoApprovalUrl,
    this.paymentErrorMessage,
    this.paidAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vow_id'] = Variable<int>(vowId);
    map['verification_id'] = Variable<int>(verificationId);
    map['violated_at'] = Variable<DateTime>(violatedAt);
    map['penalty_amount'] = Variable<int>(penaltyAmount);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || kakaoTid != null) {
      map['kakao_tid'] = Variable<String>(kakaoTid);
    }
    if (!nullToAbsent || kakaoApprovalUrl != null) {
      map['kakao_approval_url'] = Variable<String>(kakaoApprovalUrl);
    }
    if (!nullToAbsent || paymentErrorMessage != null) {
      map['payment_error_message'] = Variable<String>(paymentErrorMessage);
    }
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ViolationsCompanion toCompanion(bool nullToAbsent) {
    return ViolationsCompanion(
      id: Value(id),
      vowId: Value(vowId),
      verificationId: Value(verificationId),
      violatedAt: Value(violatedAt),
      penaltyAmount: Value(penaltyAmount),
      paymentStatus: Value(paymentStatus),
      kakaoTid: kakaoTid == null && nullToAbsent
          ? const Value.absent()
          : Value(kakaoTid),
      kakaoApprovalUrl: kakaoApprovalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(kakaoApprovalUrl),
      paymentErrorMessage: paymentErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentErrorMessage),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      createdAt: Value(createdAt),
    );
  }

  factory Violation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Violation(
      id: serializer.fromJson<int>(json['id']),
      vowId: serializer.fromJson<int>(json['vowId']),
      verificationId: serializer.fromJson<int>(json['verificationId']),
      violatedAt: serializer.fromJson<DateTime>(json['violatedAt']),
      penaltyAmount: serializer.fromJson<int>(json['penaltyAmount']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      kakaoTid: serializer.fromJson<String?>(json['kakaoTid']),
      kakaoApprovalUrl: serializer.fromJson<String?>(json['kakaoApprovalUrl']),
      paymentErrorMessage: serializer.fromJson<String?>(
        json['paymentErrorMessage'],
      ),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vowId': serializer.toJson<int>(vowId),
      'verificationId': serializer.toJson<int>(verificationId),
      'violatedAt': serializer.toJson<DateTime>(violatedAt),
      'penaltyAmount': serializer.toJson<int>(penaltyAmount),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'kakaoTid': serializer.toJson<String?>(kakaoTid),
      'kakaoApprovalUrl': serializer.toJson<String?>(kakaoApprovalUrl),
      'paymentErrorMessage': serializer.toJson<String?>(paymentErrorMessage),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Violation copyWith({
    int? id,
    int? vowId,
    int? verificationId,
    DateTime? violatedAt,
    int? penaltyAmount,
    String? paymentStatus,
    Value<String?> kakaoTid = const Value.absent(),
    Value<String?> kakaoApprovalUrl = const Value.absent(),
    Value<String?> paymentErrorMessage = const Value.absent(),
    Value<DateTime?> paidAt = const Value.absent(),
    DateTime? createdAt,
  }) => Violation(
    id: id ?? this.id,
    vowId: vowId ?? this.vowId,
    verificationId: verificationId ?? this.verificationId,
    violatedAt: violatedAt ?? this.violatedAt,
    penaltyAmount: penaltyAmount ?? this.penaltyAmount,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    kakaoTid: kakaoTid.present ? kakaoTid.value : this.kakaoTid,
    kakaoApprovalUrl: kakaoApprovalUrl.present
        ? kakaoApprovalUrl.value
        : this.kakaoApprovalUrl,
    paymentErrorMessage: paymentErrorMessage.present
        ? paymentErrorMessage.value
        : this.paymentErrorMessage,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Violation copyWithCompanion(ViolationsCompanion data) {
    return Violation(
      id: data.id.present ? data.id.value : this.id,
      vowId: data.vowId.present ? data.vowId.value : this.vowId,
      verificationId: data.verificationId.present
          ? data.verificationId.value
          : this.verificationId,
      violatedAt: data.violatedAt.present
          ? data.violatedAt.value
          : this.violatedAt,
      penaltyAmount: data.penaltyAmount.present
          ? data.penaltyAmount.value
          : this.penaltyAmount,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      kakaoTid: data.kakaoTid.present ? data.kakaoTid.value : this.kakaoTid,
      kakaoApprovalUrl: data.kakaoApprovalUrl.present
          ? data.kakaoApprovalUrl.value
          : this.kakaoApprovalUrl,
      paymentErrorMessage: data.paymentErrorMessage.present
          ? data.paymentErrorMessage.value
          : this.paymentErrorMessage,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Violation(')
          ..write('id: $id, ')
          ..write('vowId: $vowId, ')
          ..write('verificationId: $verificationId, ')
          ..write('violatedAt: $violatedAt, ')
          ..write('penaltyAmount: $penaltyAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('kakaoTid: $kakaoTid, ')
          ..write('kakaoApprovalUrl: $kakaoApprovalUrl, ')
          ..write('paymentErrorMessage: $paymentErrorMessage, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vowId,
    verificationId,
    violatedAt,
    penaltyAmount,
    paymentStatus,
    kakaoTid,
    kakaoApprovalUrl,
    paymentErrorMessage,
    paidAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Violation &&
          other.id == this.id &&
          other.vowId == this.vowId &&
          other.verificationId == this.verificationId &&
          other.violatedAt == this.violatedAt &&
          other.penaltyAmount == this.penaltyAmount &&
          other.paymentStatus == this.paymentStatus &&
          other.kakaoTid == this.kakaoTid &&
          other.kakaoApprovalUrl == this.kakaoApprovalUrl &&
          other.paymentErrorMessage == this.paymentErrorMessage &&
          other.paidAt == this.paidAt &&
          other.createdAt == this.createdAt);
}

class ViolationsCompanion extends UpdateCompanion<Violation> {
  final Value<int> id;
  final Value<int> vowId;
  final Value<int> verificationId;
  final Value<DateTime> violatedAt;
  final Value<int> penaltyAmount;
  final Value<String> paymentStatus;
  final Value<String?> kakaoTid;
  final Value<String?> kakaoApprovalUrl;
  final Value<String?> paymentErrorMessage;
  final Value<DateTime?> paidAt;
  final Value<DateTime> createdAt;
  const ViolationsCompanion({
    this.id = const Value.absent(),
    this.vowId = const Value.absent(),
    this.verificationId = const Value.absent(),
    this.violatedAt = const Value.absent(),
    this.penaltyAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.kakaoTid = const Value.absent(),
    this.kakaoApprovalUrl = const Value.absent(),
    this.paymentErrorMessage = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ViolationsCompanion.insert({
    this.id = const Value.absent(),
    required int vowId,
    required int verificationId,
    required DateTime violatedAt,
    required int penaltyAmount,
    this.paymentStatus = const Value.absent(),
    this.kakaoTid = const Value.absent(),
    this.kakaoApprovalUrl = const Value.absent(),
    this.paymentErrorMessage = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vowId = Value(vowId),
       verificationId = Value(verificationId),
       violatedAt = Value(violatedAt),
       penaltyAmount = Value(penaltyAmount);
  static Insertable<Violation> custom({
    Expression<int>? id,
    Expression<int>? vowId,
    Expression<int>? verificationId,
    Expression<DateTime>? violatedAt,
    Expression<int>? penaltyAmount,
    Expression<String>? paymentStatus,
    Expression<String>? kakaoTid,
    Expression<String>? kakaoApprovalUrl,
    Expression<String>? paymentErrorMessage,
    Expression<DateTime>? paidAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vowId != null) 'vow_id': vowId,
      if (verificationId != null) 'verification_id': verificationId,
      if (violatedAt != null) 'violated_at': violatedAt,
      if (penaltyAmount != null) 'penalty_amount': penaltyAmount,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (kakaoTid != null) 'kakao_tid': kakaoTid,
      if (kakaoApprovalUrl != null) 'kakao_approval_url': kakaoApprovalUrl,
      if (paymentErrorMessage != null)
        'payment_error_message': paymentErrorMessage,
      if (paidAt != null) 'paid_at': paidAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ViolationsCompanion copyWith({
    Value<int>? id,
    Value<int>? vowId,
    Value<int>? verificationId,
    Value<DateTime>? violatedAt,
    Value<int>? penaltyAmount,
    Value<String>? paymentStatus,
    Value<String?>? kakaoTid,
    Value<String?>? kakaoApprovalUrl,
    Value<String?>? paymentErrorMessage,
    Value<DateTime?>? paidAt,
    Value<DateTime>? createdAt,
  }) {
    return ViolationsCompanion(
      id: id ?? this.id,
      vowId: vowId ?? this.vowId,
      verificationId: verificationId ?? this.verificationId,
      violatedAt: violatedAt ?? this.violatedAt,
      penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      kakaoTid: kakaoTid ?? this.kakaoTid,
      kakaoApprovalUrl: kakaoApprovalUrl ?? this.kakaoApprovalUrl,
      paymentErrorMessage: paymentErrorMessage ?? this.paymentErrorMessage,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vowId.present) {
      map['vow_id'] = Variable<int>(vowId.value);
    }
    if (verificationId.present) {
      map['verification_id'] = Variable<int>(verificationId.value);
    }
    if (violatedAt.present) {
      map['violated_at'] = Variable<DateTime>(violatedAt.value);
    }
    if (penaltyAmount.present) {
      map['penalty_amount'] = Variable<int>(penaltyAmount.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (kakaoTid.present) {
      map['kakao_tid'] = Variable<String>(kakaoTid.value);
    }
    if (kakaoApprovalUrl.present) {
      map['kakao_approval_url'] = Variable<String>(kakaoApprovalUrl.value);
    }
    if (paymentErrorMessage.present) {
      map['payment_error_message'] = Variable<String>(
        paymentErrorMessage.value,
      );
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ViolationsCompanion(')
          ..write('id: $id, ')
          ..write('vowId: $vowId, ')
          ..write('verificationId: $verificationId, ')
          ..write('violatedAt: $violatedAt, ')
          ..write('penaltyAmount: $penaltyAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('kakaoTid: $kakaoTid, ')
          ..write('kakaoApprovalUrl: $kakaoApprovalUrl, ')
          ..write('paymentErrorMessage: $paymentErrorMessage, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $VowsTable vows = $VowsTable(this);
  late final $VerificationsTable verifications = $VerificationsTable(this);
  late final $ViolationsTable violations = $ViolationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    vows,
    verifications,
    violations,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> kakaoId,
      Value<String?> accessToken,
      Value<String> nickname,
      Value<String?> profileImageUrl,
      Value<int> totalPledges,
      Value<int> successPledges,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> kakaoId,
      Value<String?> accessToken,
      Value<String> nickname,
      Value<String?> profileImageUrl,
      Value<int> totalPledges,
      Value<int> successPledges,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VowsTable, List<Vow>> _vowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vows,
    aliasName: $_aliasNameGenerator(db.users.id, db.vows.userId),
  );

  $$VowsTableProcessedTableManager get vowsRefs {
    final manager = $$VowsTableTableManager(
      $_db,
      $_db.vows,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kakaoId => $composableBuilder(
    column: $table.kakaoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPledges => $composableBuilder(
    column: $table.totalPledges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successPledges => $composableBuilder(
    column: $table.successPledges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vowsRefs(
    Expression<bool> Function($$VowsTableFilterComposer f) f,
  ) {
    final $$VowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableFilterComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kakaoId => $composableBuilder(
    column: $table.kakaoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPledges => $composableBuilder(
    column: $table.totalPledges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successPledges => $composableBuilder(
    column: $table.successPledges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kakaoId =>
      $composableBuilder(column: $table.kakaoId, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPledges => $composableBuilder(
    column: $table.totalPledges,
    builder: (column) => column,
  );

  GeneratedColumn<int> get successPledges => $composableBuilder(
    column: $table.successPledges,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> vowsRefs<T extends Object>(
    Expression<T> Function($$VowsTableAnnotationComposer a) f,
  ) {
    final $$VowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableAnnotationComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool vowsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> kakaoId = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<int> totalPledges = const Value.absent(),
                Value<int> successPledges = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                kakaoId: kakaoId,
                accessToken: accessToken,
                nickname: nickname,
                profileImageUrl: profileImageUrl,
                totalPledges: totalPledges,
                successPledges: successPledges,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> kakaoId = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<int> totalPledges = const Value.absent(),
                Value<int> successPledges = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                kakaoId: kakaoId,
                accessToken: accessToken,
                nickname: nickname,
                profileImageUrl: profileImageUrl,
                totalPledges: totalPledges,
                successPledges: successPledges,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({vowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vowsRefs) db.vows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vowsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Vow>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences._vowsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableReferences(db, table, p0).vowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool vowsRefs})
    >;
typedef $$VowsTableCreateCompanionBuilder =
    VowsCompanion Function({
      Value<int> id,
      required int userId,
      required String title,
      Value<String?> description,
      required String pledgeType,
      Value<String> status,
      required String conditionJson,
      required int penaltyAmount,
      Value<String?> penaltyRecipient,
      required DateTime startDate,
      required DateTime endDate,
      Value<int> verificationIntervalDays,
      Value<int> totalVerifications,
      Value<int> passedVerifications,
      Value<int> totalFinesPaid,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$VowsTableUpdateCompanionBuilder =
    VowsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> title,
      Value<String?> description,
      Value<String> pledgeType,
      Value<String> status,
      Value<String> conditionJson,
      Value<int> penaltyAmount,
      Value<String?> penaltyRecipient,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> verificationIntervalDays,
      Value<int> totalVerifications,
      Value<int> passedVerifications,
      Value<int> totalFinesPaid,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$VowsTableReferences
    extends BaseReferences<_$AppDatabase, $VowsTable, Vow> {
  $$VowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.vows.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VerificationsTable, List<Verification>>
  _verificationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verifications,
    aliasName: $_aliasNameGenerator(db.vows.id, db.verifications.vowId),
  );

  $$VerificationsTableProcessedTableManager get verificationsRefs {
    final manager = $$VerificationsTableTableManager(
      $_db,
      $_db.verifications,
    ).filter((f) => f.vowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verificationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ViolationsTable, List<Violation>>
  _violationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.violations,
    aliasName: $_aliasNameGenerator(db.vows.id, db.violations.vowId),
  );

  $$ViolationsTableProcessedTableManager get violationsRefs {
    final manager = $$ViolationsTableTableManager(
      $_db,
      $_db.violations,
    ).filter((f) => f.vowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_violationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VowsTableFilterComposer extends Composer<_$AppDatabase, $VowsTable> {
  $$VowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pledgeType => $composableBuilder(
    column: $table.pledgeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get penaltyRecipient => $composableBuilder(
    column: $table.penaltyRecipient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verificationIntervalDays => $composableBuilder(
    column: $table.verificationIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVerifications => $composableBuilder(
    column: $table.totalVerifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passedVerifications => $composableBuilder(
    column: $table.passedVerifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFinesPaid => $composableBuilder(
    column: $table.totalFinesPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> verificationsRefs(
    Expression<bool> Function($$VerificationsTableFilterComposer f) f,
  ) {
    final $$VerificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verifications,
      getReferencedColumn: (t) => t.vowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificationsTableFilterComposer(
            $db: $db,
            $table: $db.verifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> violationsRefs(
    Expression<bool> Function($$ViolationsTableFilterComposer f) f,
  ) {
    final $$ViolationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.vowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableFilterComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VowsTableOrderingComposer extends Composer<_$AppDatabase, $VowsTable> {
  $$VowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pledgeType => $composableBuilder(
    column: $table.pledgeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get penaltyRecipient => $composableBuilder(
    column: $table.penaltyRecipient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verificationIntervalDays => $composableBuilder(
    column: $table.verificationIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVerifications => $composableBuilder(
    column: $table.totalVerifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passedVerifications => $composableBuilder(
    column: $table.passedVerifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFinesPaid => $composableBuilder(
    column: $table.totalFinesPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VowsTable> {
  $$VowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pledgeType => $composableBuilder(
    column: $table.pledgeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get penaltyRecipient => $composableBuilder(
    column: $table.penaltyRecipient,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get verificationIntervalDays => $composableBuilder(
    column: $table.verificationIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVerifications => $composableBuilder(
    column: $table.totalVerifications,
    builder: (column) => column,
  );

  GeneratedColumn<int> get passedVerifications => $composableBuilder(
    column: $table.passedVerifications,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalFinesPaid => $composableBuilder(
    column: $table.totalFinesPaid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> verificationsRefs<T extends Object>(
    Expression<T> Function($$VerificationsTableAnnotationComposer a) f,
  ) {
    final $$VerificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verifications,
      getReferencedColumn: (t) => t.vowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.verifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> violationsRefs<T extends Object>(
    Expression<T> Function($$ViolationsTableAnnotationComposer a) f,
  ) {
    final $$ViolationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.vowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableAnnotationComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VowsTable,
          Vow,
          $$VowsTableFilterComposer,
          $$VowsTableOrderingComposer,
          $$VowsTableAnnotationComposer,
          $$VowsTableCreateCompanionBuilder,
          $$VowsTableUpdateCompanionBuilder,
          (Vow, $$VowsTableReferences),
          Vow,
          PrefetchHooks Function({
            bool userId,
            bool verificationsRefs,
            bool violationsRefs,
          })
        > {
  $$VowsTableTableManager(_$AppDatabase db, $VowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> pledgeType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> conditionJson = const Value.absent(),
                Value<int> penaltyAmount = const Value.absent(),
                Value<String?> penaltyRecipient = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> verificationIntervalDays = const Value.absent(),
                Value<int> totalVerifications = const Value.absent(),
                Value<int> passedVerifications = const Value.absent(),
                Value<int> totalFinesPaid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VowsCompanion(
                id: id,
                userId: userId,
                title: title,
                description: description,
                pledgeType: pledgeType,
                status: status,
                conditionJson: conditionJson,
                penaltyAmount: penaltyAmount,
                penaltyRecipient: penaltyRecipient,
                startDate: startDate,
                endDate: endDate,
                verificationIntervalDays: verificationIntervalDays,
                totalVerifications: totalVerifications,
                passedVerifications: passedVerifications,
                totalFinesPaid: totalFinesPaid,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String title,
                Value<String?> description = const Value.absent(),
                required String pledgeType,
                Value<String> status = const Value.absent(),
                required String conditionJson,
                required int penaltyAmount,
                Value<String?> penaltyRecipient = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                Value<int> verificationIntervalDays = const Value.absent(),
                Value<int> totalVerifications = const Value.absent(),
                Value<int> passedVerifications = const Value.absent(),
                Value<int> totalFinesPaid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VowsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                description: description,
                pledgeType: pledgeType,
                status: status,
                conditionJson: conditionJson,
                penaltyAmount: penaltyAmount,
                penaltyRecipient: penaltyRecipient,
                startDate: startDate,
                endDate: endDate,
                verificationIntervalDays: verificationIntervalDays,
                totalVerifications: totalVerifications,
                passedVerifications: passedVerifications,
                totalFinesPaid: totalFinesPaid,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VowsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                verificationsRefs = false,
                violationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (verificationsRefs) db.verifications,
                    if (violationsRefs) db.violations,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable: $$VowsTableReferences
                                        ._userIdTable(db),
                                    referencedColumn: $$VowsTableReferences
                                        ._userIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (verificationsRefs)
                        await $_getPrefetchedData<
                          Vow,
                          $VowsTable,
                          Verification
                        >(
                          currentTable: table,
                          referencedTable: $$VowsTableReferences
                              ._verificationsRefsTable(db),
                          managerFromTypedResult: (p0) => $$VowsTableReferences(
                            db,
                            table,
                            p0,
                          ).verificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vowId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (violationsRefs)
                        await $_getPrefetchedData<Vow, $VowsTable, Violation>(
                          currentTable: table,
                          referencedTable: $$VowsTableReferences
                              ._violationsRefsTable(db),
                          managerFromTypedResult: (p0) => $$VowsTableReferences(
                            db,
                            table,
                            p0,
                          ).violationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vowId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VowsTable,
      Vow,
      $$VowsTableFilterComposer,
      $$VowsTableOrderingComposer,
      $$VowsTableAnnotationComposer,
      $$VowsTableCreateCompanionBuilder,
      $$VowsTableUpdateCompanionBuilder,
      (Vow, $$VowsTableReferences),
      Vow,
      PrefetchHooks Function({
        bool userId,
        bool verificationsRefs,
        bool violationsRefs,
      })
    >;
typedef $$VerificationsTableCreateCompanionBuilder =
    VerificationsCompanion Function({
      Value<int> id,
      required int vowId,
      required DateTime targetDate,
      required DateTime verifiedAt,
      required bool isPassed,
      Value<String?> measuredDataJson,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$VerificationsTableUpdateCompanionBuilder =
    VerificationsCompanion Function({
      Value<int> id,
      Value<int> vowId,
      Value<DateTime> targetDate,
      Value<DateTime> verifiedAt,
      Value<bool> isPassed,
      Value<String?> measuredDataJson,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$VerificationsTableReferences
    extends BaseReferences<_$AppDatabase, $VerificationsTable, Verification> {
  $$VerificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VowsTable _vowIdTable(_$AppDatabase db) => db.vows.createAlias(
    $_aliasNameGenerator(db.verifications.vowId, db.vows.id),
  );

  $$VowsTableProcessedTableManager get vowId {
    final $_column = $_itemColumn<int>('vow_id')!;

    final manager = $$VowsTableTableManager(
      $_db,
      $_db.vows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ViolationsTable, List<Violation>>
  _violationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.violations,
    aliasName: $_aliasNameGenerator(
      db.verifications.id,
      db.violations.verificationId,
    ),
  );

  $$ViolationsTableProcessedTableManager get violationsRefs {
    final manager = $$ViolationsTableTableManager(
      $_db,
      $_db.violations,
    ).filter((f) => f.verificationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_violationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VerificationsTableFilterComposer
    extends Composer<_$AppDatabase, $VerificationsTable> {
  $$VerificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measuredDataJson => $composableBuilder(
    column: $table.measuredDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VowsTableFilterComposer get vowId {
    final $$VowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableFilterComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> violationsRefs(
    Expression<bool> Function($$ViolationsTableFilterComposer f) f,
  ) {
    final $$ViolationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.verificationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableFilterComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VerificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $VerificationsTable> {
  $$VerificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measuredDataJson => $composableBuilder(
    column: $table.measuredDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VowsTableOrderingComposer get vowId {
    final $$VowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableOrderingComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerificationsTable> {
  $$VerificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPassed =>
      $composableBuilder(column: $table.isPassed, builder: (column) => column);

  GeneratedColumn<String> get measuredDataJson => $composableBuilder(
    column: $table.measuredDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VowsTableAnnotationComposer get vowId {
    final $$VowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableAnnotationComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> violationsRefs<T extends Object>(
    Expression<T> Function($$ViolationsTableAnnotationComposer a) f,
  ) {
    final $$ViolationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.violations,
      getReferencedColumn: (t) => t.verificationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ViolationsTableAnnotationComposer(
            $db: $db,
            $table: $db.violations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VerificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerificationsTable,
          Verification,
          $$VerificationsTableFilterComposer,
          $$VerificationsTableOrderingComposer,
          $$VerificationsTableAnnotationComposer,
          $$VerificationsTableCreateCompanionBuilder,
          $$VerificationsTableUpdateCompanionBuilder,
          (Verification, $$VerificationsTableReferences),
          Verification,
          PrefetchHooks Function({bool vowId, bool violationsRefs})
        > {
  $$VerificationsTableTableManager(_$AppDatabase db, $VerificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vowId = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<DateTime> verifiedAt = const Value.absent(),
                Value<bool> isPassed = const Value.absent(),
                Value<String?> measuredDataJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VerificationsCompanion(
                id: id,
                vowId: vowId,
                targetDate: targetDate,
                verifiedAt: verifiedAt,
                isPassed: isPassed,
                measuredDataJson: measuredDataJson,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vowId,
                required DateTime targetDate,
                required DateTime verifiedAt,
                required bool isPassed,
                Value<String?> measuredDataJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VerificationsCompanion.insert(
                id: id,
                vowId: vowId,
                targetDate: targetDate,
                verifiedAt: verifiedAt,
                isPassed: isPassed,
                measuredDataJson: measuredDataJson,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VerificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vowId = false, violationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (violationsRefs) db.violations],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (vowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vowId,
                                referencedTable: $$VerificationsTableReferences
                                    ._vowIdTable(db),
                                referencedColumn: $$VerificationsTableReferences
                                    ._vowIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (violationsRefs)
                    await $_getPrefetchedData<
                      Verification,
                      $VerificationsTable,
                      Violation
                    >(
                      currentTable: table,
                      referencedTable: $$VerificationsTableReferences
                          ._violationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VerificationsTableReferences(
                            db,
                            table,
                            p0,
                          ).violationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.verificationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VerificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerificationsTable,
      Verification,
      $$VerificationsTableFilterComposer,
      $$VerificationsTableOrderingComposer,
      $$VerificationsTableAnnotationComposer,
      $$VerificationsTableCreateCompanionBuilder,
      $$VerificationsTableUpdateCompanionBuilder,
      (Verification, $$VerificationsTableReferences),
      Verification,
      PrefetchHooks Function({bool vowId, bool violationsRefs})
    >;
typedef $$ViolationsTableCreateCompanionBuilder =
    ViolationsCompanion Function({
      Value<int> id,
      required int vowId,
      required int verificationId,
      required DateTime violatedAt,
      required int penaltyAmount,
      Value<String> paymentStatus,
      Value<String?> kakaoTid,
      Value<String?> kakaoApprovalUrl,
      Value<String?> paymentErrorMessage,
      Value<DateTime?> paidAt,
      Value<DateTime> createdAt,
    });
typedef $$ViolationsTableUpdateCompanionBuilder =
    ViolationsCompanion Function({
      Value<int> id,
      Value<int> vowId,
      Value<int> verificationId,
      Value<DateTime> violatedAt,
      Value<int> penaltyAmount,
      Value<String> paymentStatus,
      Value<String?> kakaoTid,
      Value<String?> kakaoApprovalUrl,
      Value<String?> paymentErrorMessage,
      Value<DateTime?> paidAt,
      Value<DateTime> createdAt,
    });

final class $$ViolationsTableReferences
    extends BaseReferences<_$AppDatabase, $ViolationsTable, Violation> {
  $$ViolationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VowsTable _vowIdTable(_$AppDatabase db) => db.vows.createAlias(
    $_aliasNameGenerator(db.violations.vowId, db.vows.id),
  );

  $$VowsTableProcessedTableManager get vowId {
    final $_column = $_itemColumn<int>('vow_id')!;

    final manager = $$VowsTableTableManager(
      $_db,
      $_db.vows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VerificationsTable _verificationIdTable(_$AppDatabase db) =>
      db.verifications.createAlias(
        $_aliasNameGenerator(db.violations.verificationId, db.verifications.id),
      );

  $$VerificationsTableProcessedTableManager get verificationId {
    final $_column = $_itemColumn<int>('verification_id')!;

    final manager = $$VerificationsTableTableManager(
      $_db,
      $_db.verifications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_verificationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ViolationsTableFilterComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get violatedAt => $composableBuilder(
    column: $table.violatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kakaoTid => $composableBuilder(
    column: $table.kakaoTid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kakaoApprovalUrl => $composableBuilder(
    column: $table.kakaoApprovalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentErrorMessage => $composableBuilder(
    column: $table.paymentErrorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VowsTableFilterComposer get vowId {
    final $$VowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableFilterComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificationsTableFilterComposer get verificationId {
    final $$VerificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificationId,
      referencedTable: $db.verifications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificationsTableFilterComposer(
            $db: $db,
            $table: $db.verifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get violatedAt => $composableBuilder(
    column: $table.violatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kakaoTid => $composableBuilder(
    column: $table.kakaoTid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kakaoApprovalUrl => $composableBuilder(
    column: $table.kakaoApprovalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentErrorMessage => $composableBuilder(
    column: $table.paymentErrorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VowsTableOrderingComposer get vowId {
    final $$VowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableOrderingComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificationsTableOrderingComposer get verificationId {
    final $$VerificationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificationId,
      referencedTable: $db.verifications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificationsTableOrderingComposer(
            $db: $db,
            $table: $db.verifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get violatedAt => $composableBuilder(
    column: $table.violatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get penaltyAmount => $composableBuilder(
    column: $table.penaltyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kakaoTid =>
      $composableBuilder(column: $table.kakaoTid, builder: (column) => column);

  GeneratedColumn<String> get kakaoApprovalUrl => $composableBuilder(
    column: $table.kakaoApprovalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentErrorMessage => $composableBuilder(
    column: $table.paymentErrorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VowsTableAnnotationComposer get vowId {
    final $$VowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vowId,
      referencedTable: $db.vows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VowsTableAnnotationComposer(
            $db: $db,
            $table: $db.vows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificationsTableAnnotationComposer get verificationId {
    final $$VerificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificationId,
      referencedTable: $db.verifications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.verifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ViolationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ViolationsTable,
          Violation,
          $$ViolationsTableFilterComposer,
          $$ViolationsTableOrderingComposer,
          $$ViolationsTableAnnotationComposer,
          $$ViolationsTableCreateCompanionBuilder,
          $$ViolationsTableUpdateCompanionBuilder,
          (Violation, $$ViolationsTableReferences),
          Violation,
          PrefetchHooks Function({bool vowId, bool verificationId})
        > {
  $$ViolationsTableTableManager(_$AppDatabase db, $ViolationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ViolationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ViolationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ViolationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vowId = const Value.absent(),
                Value<int> verificationId = const Value.absent(),
                Value<DateTime> violatedAt = const Value.absent(),
                Value<int> penaltyAmount = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> kakaoTid = const Value.absent(),
                Value<String?> kakaoApprovalUrl = const Value.absent(),
                Value<String?> paymentErrorMessage = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ViolationsCompanion(
                id: id,
                vowId: vowId,
                verificationId: verificationId,
                violatedAt: violatedAt,
                penaltyAmount: penaltyAmount,
                paymentStatus: paymentStatus,
                kakaoTid: kakaoTid,
                kakaoApprovalUrl: kakaoApprovalUrl,
                paymentErrorMessage: paymentErrorMessage,
                paidAt: paidAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vowId,
                required int verificationId,
                required DateTime violatedAt,
                required int penaltyAmount,
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> kakaoTid = const Value.absent(),
                Value<String?> kakaoApprovalUrl = const Value.absent(),
                Value<String?> paymentErrorMessage = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ViolationsCompanion.insert(
                id: id,
                vowId: vowId,
                verificationId: verificationId,
                violatedAt: violatedAt,
                penaltyAmount: penaltyAmount,
                paymentStatus: paymentStatus,
                kakaoTid: kakaoTid,
                kakaoApprovalUrl: kakaoApprovalUrl,
                paymentErrorMessage: paymentErrorMessage,
                paidAt: paidAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ViolationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vowId = false, verificationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (vowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vowId,
                                referencedTable: $$ViolationsTableReferences
                                    ._vowIdTable(db),
                                referencedColumn: $$ViolationsTableReferences
                                    ._vowIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (verificationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.verificationId,
                                referencedTable: $$ViolationsTableReferences
                                    ._verificationIdTable(db),
                                referencedColumn: $$ViolationsTableReferences
                                    ._verificationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ViolationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ViolationsTable,
      Violation,
      $$ViolationsTableFilterComposer,
      $$ViolationsTableOrderingComposer,
      $$ViolationsTableAnnotationComposer,
      $$ViolationsTableCreateCompanionBuilder,
      $$ViolationsTableUpdateCompanionBuilder,
      (Violation, $$ViolationsTableReferences),
      Violation,
      PrefetchHooks Function({bool vowId, bool verificationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$VowsTableTableManager get vows => $$VowsTableTableManager(_db, _db.vows);
  $$VerificationsTableTableManager get verifications =>
      $$VerificationsTableTableManager(_db, _db.verifications);
  $$ViolationsTableTableManager get violations =>
      $$ViolationsTableTableManager(_db, _db.violations);
}
