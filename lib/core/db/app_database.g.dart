// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VouchersTable extends Vouchers with TableInfo<$VouchersTable, Voucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateAndTimeMeta = const VerificationMeta(
    'dateAndTime',
  );
  @override
  late final GeneratedColumn<String> dateAndTime = GeneratedColumn<String>(
    'date_and_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    defaultValue: const Constant('payment_due'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facebookAccountMeta = const VerificationMeta(
    'facebookAccount',
  );
  @override
  late final GeneratedColumn<String> facebookAccount = GeneratedColumn<String>(
    'facebook_account',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelNumberMeta = const VerificationMeta(
    'parcelNumber',
  );
  @override
  late final GeneratedColumn<String> parcelNumber = GeneratedColumn<String>(
    'parcel_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemImagePathMeta = const VerificationMeta(
    'itemImagePath',
  );
  @override
  late final GeneratedColumn<String> itemImagePath = GeneratedColumn<String>(
    'item_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dispatchReceiptImagePathMeta =
      const VerificationMeta('dispatchReceiptImagePath');
  @override
  late final GeneratedColumn<String> dispatchReceiptImagePath =
      GeneratedColumn<String>(
        'dispatch_receipt_image_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    dateAndTime,
    paymentStatus,
    name,
    phone,
    address,
    facebookAccount,
    parcelNumber,
    note,
    itemImagePath,
    dispatchReceiptImagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vouchers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Voucher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('date_and_time')) {
      context.handle(
        _dateAndTimeMeta,
        dateAndTime.isAcceptableOrUnknown(
          data['date_and_time']!,
          _dateAndTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateAndTimeMeta);
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('facebook_account')) {
      context.handle(
        _facebookAccountMeta,
        facebookAccount.isAcceptableOrUnknown(
          data['facebook_account']!,
          _facebookAccountMeta,
        ),
      );
    }
    if (data.containsKey('parcel_number')) {
      context.handle(
        _parcelNumberMeta,
        parcelNumber.isAcceptableOrUnknown(
          data['parcel_number']!,
          _parcelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parcelNumberMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('item_image_path')) {
      context.handle(
        _itemImagePathMeta,
        itemImagePath.isAcceptableOrUnknown(
          data['item_image_path']!,
          _itemImagePathMeta,
        ),
      );
    }
    if (data.containsKey('dispatch_receipt_image_path')) {
      context.handle(
        _dispatchReceiptImagePathMeta,
        dispatchReceiptImagePath.isAcceptableOrUnknown(
          data['dispatch_receipt_image_path']!,
          _dispatchReceiptImagePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Voucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voucher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      dateAndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_and_time'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      facebookAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facebook_account'],
      ),
      parcelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_number'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      itemImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_image_path'],
      ),
      dispatchReceiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dispatch_receipt_image_path'],
      ),
    );
  }

  @override
  $VouchersTable createAlias(String alias) {
    return $VouchersTable(attachedDatabase, alias);
  }
}

class Voucher extends DataClass implements Insertable<Voucher> {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String dateAndTime;
  final String paymentStatus;
  final String name;
  final String phone;
  final String address;
  final String? facebookAccount;
  final String parcelNumber;
  final String? note;
  final String? itemImagePath;
  final String? dispatchReceiptImagePath;
  const Voucher({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.dateAndTime,
    required this.paymentStatus,
    required this.name,
    required this.phone,
    required this.address,
    this.facebookAccount,
    required this.parcelNumber,
    this.note,
    this.itemImagePath,
    this.dispatchReceiptImagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['date_and_time'] = Variable<String>(dateAndTime);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || facebookAccount != null) {
      map['facebook_account'] = Variable<String>(facebookAccount);
    }
    map['parcel_number'] = Variable<String>(parcelNumber);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || itemImagePath != null) {
      map['item_image_path'] = Variable<String>(itemImagePath);
    }
    if (!nullToAbsent || dispatchReceiptImagePath != null) {
      map['dispatch_receipt_image_path'] = Variable<String>(
        dispatchReceiptImagePath,
      );
    }
    return map;
  }

  VouchersCompanion toCompanion(bool nullToAbsent) {
    return VouchersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dateAndTime: Value(dateAndTime),
      paymentStatus: Value(paymentStatus),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      facebookAccount: facebookAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(facebookAccount),
      parcelNumber: Value(parcelNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      itemImagePath: itemImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(itemImagePath),
      dispatchReceiptImagePath: dispatchReceiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(dispatchReceiptImagePath),
    );
  }

  factory Voucher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voucher(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      dateAndTime: serializer.fromJson<String>(json['dateAndTime']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      facebookAccount: serializer.fromJson<String?>(json['facebookAccount']),
      parcelNumber: serializer.fromJson<String>(json['parcelNumber']),
      note: serializer.fromJson<String?>(json['note']),
      itemImagePath: serializer.fromJson<String?>(json['itemImagePath']),
      dispatchReceiptImagePath: serializer.fromJson<String?>(
        json['dispatchReceiptImagePath'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'dateAndTime': serializer.toJson<String>(dateAndTime),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'facebookAccount': serializer.toJson<String?>(facebookAccount),
      'parcelNumber': serializer.toJson<String>(parcelNumber),
      'note': serializer.toJson<String?>(note),
      'itemImagePath': serializer.toJson<String?>(itemImagePath),
      'dispatchReceiptImagePath': serializer.toJson<String?>(
        dispatchReceiptImagePath,
      ),
    };
  }

  Voucher copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? dateAndTime,
    String? paymentStatus,
    String? name,
    String? phone,
    String? address,
    Value<String?> facebookAccount = const Value.absent(),
    String? parcelNumber,
    Value<String?> note = const Value.absent(),
    Value<String?> itemImagePath = const Value.absent(),
    Value<String?> dispatchReceiptImagePath = const Value.absent(),
  }) => Voucher(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dateAndTime: dateAndTime ?? this.dateAndTime,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    facebookAccount: facebookAccount.present
        ? facebookAccount.value
        : this.facebookAccount,
    parcelNumber: parcelNumber ?? this.parcelNumber,
    note: note.present ? note.value : this.note,
    itemImagePath: itemImagePath.present
        ? itemImagePath.value
        : this.itemImagePath,
    dispatchReceiptImagePath: dispatchReceiptImagePath.present
        ? dispatchReceiptImagePath.value
        : this.dispatchReceiptImagePath,
  );
  Voucher copyWithCompanion(VouchersCompanion data) {
    return Voucher(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dateAndTime: data.dateAndTime.present
          ? data.dateAndTime.value
          : this.dateAndTime,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      facebookAccount: data.facebookAccount.present
          ? data.facebookAccount.value
          : this.facebookAccount,
      parcelNumber: data.parcelNumber.present
          ? data.parcelNumber.value
          : this.parcelNumber,
      note: data.note.present ? data.note.value : this.note,
      itemImagePath: data.itemImagePath.present
          ? data.itemImagePath.value
          : this.itemImagePath,
      dispatchReceiptImagePath: data.dispatchReceiptImagePath.present
          ? data.dispatchReceiptImagePath.value
          : this.dispatchReceiptImagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voucher(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dateAndTime: $dateAndTime, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('facebookAccount: $facebookAccount, ')
          ..write('parcelNumber: $parcelNumber, ')
          ..write('note: $note, ')
          ..write('itemImagePath: $itemImagePath, ')
          ..write('dispatchReceiptImagePath: $dispatchReceiptImagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    dateAndTime,
    paymentStatus,
    name,
    phone,
    address,
    facebookAccount,
    parcelNumber,
    note,
    itemImagePath,
    dispatchReceiptImagePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voucher &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dateAndTime == this.dateAndTime &&
          other.paymentStatus == this.paymentStatus &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.facebookAccount == this.facebookAccount &&
          other.parcelNumber == this.parcelNumber &&
          other.note == this.note &&
          other.itemImagePath == this.itemImagePath &&
          other.dispatchReceiptImagePath == this.dispatchReceiptImagePath);
}

class VouchersCompanion extends UpdateCompanion<Voucher> {
  final Value<String> id;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> dateAndTime;
  final Value<String> paymentStatus;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String?> facebookAccount;
  final Value<String> parcelNumber;
  final Value<String?> note;
  final Value<String?> itemImagePath;
  final Value<String?> dispatchReceiptImagePath;
  final Value<int> rowid;
  const VouchersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dateAndTime = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.facebookAccount = const Value.absent(),
    this.parcelNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.itemImagePath = const Value.absent(),
    this.dispatchReceiptImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VouchersCompanion.insert({
    required String id,
    required String createdAt,
    required String updatedAt,
    required String dateAndTime,
    this.paymentStatus = const Value.absent(),
    required String name,
    required String phone,
    required String address,
    this.facebookAccount = const Value.absent(),
    required String parcelNumber,
    this.note = const Value.absent(),
    this.itemImagePath = const Value.absent(),
    this.dispatchReceiptImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       dateAndTime = Value(dateAndTime),
       name = Value(name),
       phone = Value(phone),
       address = Value(address),
       parcelNumber = Value(parcelNumber);
  static Insertable<Voucher> custom({
    Expression<String>? id,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? dateAndTime,
    Expression<String>? paymentStatus,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? facebookAccount,
    Expression<String>? parcelNumber,
    Expression<String>? note,
    Expression<String>? itemImagePath,
    Expression<String>? dispatchReceiptImagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dateAndTime != null) 'date_and_time': dateAndTime,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (facebookAccount != null) 'facebook_account': facebookAccount,
      if (parcelNumber != null) 'parcel_number': parcelNumber,
      if (note != null) 'note': note,
      if (itemImagePath != null) 'item_image_path': itemImagePath,
      if (dispatchReceiptImagePath != null)
        'dispatch_receipt_image_path': dispatchReceiptImagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VouchersCompanion copyWith({
    Value<String>? id,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String>? dateAndTime,
    Value<String>? paymentStatus,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String?>? facebookAccount,
    Value<String>? parcelNumber,
    Value<String?>? note,
    Value<String?>? itemImagePath,
    Value<String?>? dispatchReceiptImagePath,
    Value<int>? rowid,
  }) {
    return VouchersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      facebookAccount: facebookAccount ?? this.facebookAccount,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      note: note ?? this.note,
      itemImagePath: itemImagePath ?? this.itemImagePath,
      dispatchReceiptImagePath:
          dispatchReceiptImagePath ?? this.dispatchReceiptImagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (dateAndTime.present) {
      map['date_and_time'] = Variable<String>(dateAndTime.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (facebookAccount.present) {
      map['facebook_account'] = Variable<String>(facebookAccount.value);
    }
    if (parcelNumber.present) {
      map['parcel_number'] = Variable<String>(parcelNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (itemImagePath.present) {
      map['item_image_path'] = Variable<String>(itemImagePath.value);
    }
    if (dispatchReceiptImagePath.present) {
      map['dispatch_receipt_image_path'] = Variable<String>(
        dispatchReceiptImagePath.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VouchersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dateAndTime: $dateAndTime, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('facebookAccount: $facebookAccount, ')
          ..write('parcelNumber: $parcelNumber, ')
          ..write('note: $note, ')
          ..write('itemImagePath: $itemImagePath, ')
          ..write('dispatchReceiptImagePath: $dispatchReceiptImagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VouchersTable vouchers = $VouchersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vouchers];
}

typedef $$VouchersTableCreateCompanionBuilder =
    VouchersCompanion Function({
      required String id,
      required String createdAt,
      required String updatedAt,
      required String dateAndTime,
      Value<String> paymentStatus,
      required String name,
      required String phone,
      required String address,
      Value<String?> facebookAccount,
      required String parcelNumber,
      Value<String?> note,
      Value<String?> itemImagePath,
      Value<String?> dispatchReceiptImagePath,
      Value<int> rowid,
    });
typedef $$VouchersTableUpdateCompanionBuilder =
    VouchersCompanion Function({
      Value<String> id,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String> dateAndTime,
      Value<String> paymentStatus,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String?> facebookAccount,
      Value<String> parcelNumber,
      Value<String?> note,
      Value<String?> itemImagePath,
      Value<String?> dispatchReceiptImagePath,
      Value<int> rowid,
    });

class $$VouchersTableFilterComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateAndTime => $composableBuilder(
    column: $table.dateAndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facebookAccount => $composableBuilder(
    column: $table.facebookAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemImagePath => $composableBuilder(
    column: $table.itemImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dispatchReceiptImagePath => $composableBuilder(
    column: $table.dispatchReceiptImagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VouchersTableOrderingComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateAndTime => $composableBuilder(
    column: $table.dateAndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facebookAccount => $composableBuilder(
    column: $table.facebookAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemImagePath => $composableBuilder(
    column: $table.itemImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dispatchReceiptImagePath => $composableBuilder(
    column: $table.dispatchReceiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VouchersTableAnnotationComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get dateAndTime => $composableBuilder(
    column: $table.dateAndTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get facebookAccount => $composableBuilder(
    column: $table.facebookAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get itemImagePath => $composableBuilder(
    column: $table.itemImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dispatchReceiptImagePath => $composableBuilder(
    column: $table.dispatchReceiptImagePath,
    builder: (column) => column,
  );
}

class $$VouchersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VouchersTable,
          Voucher,
          $$VouchersTableFilterComposer,
          $$VouchersTableOrderingComposer,
          $$VouchersTableAnnotationComposer,
          $$VouchersTableCreateCompanionBuilder,
          $$VouchersTableUpdateCompanionBuilder,
          (Voucher, BaseReferences<_$AppDatabase, $VouchersTable, Voucher>),
          Voucher,
          PrefetchHooks Function()
        > {
  $$VouchersTableTableManager(_$AppDatabase db, $VouchersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VouchersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VouchersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VouchersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String> dateAndTime = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> facebookAccount = const Value.absent(),
                Value<String> parcelNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> itemImagePath = const Value.absent(),
                Value<String?> dispatchReceiptImagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VouchersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dateAndTime: dateAndTime,
                paymentStatus: paymentStatus,
                name: name,
                phone: phone,
                address: address,
                facebookAccount: facebookAccount,
                parcelNumber: parcelNumber,
                note: note,
                itemImagePath: itemImagePath,
                dispatchReceiptImagePath: dispatchReceiptImagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String createdAt,
                required String updatedAt,
                required String dateAndTime,
                Value<String> paymentStatus = const Value.absent(),
                required String name,
                required String phone,
                required String address,
                Value<String?> facebookAccount = const Value.absent(),
                required String parcelNumber,
                Value<String?> note = const Value.absent(),
                Value<String?> itemImagePath = const Value.absent(),
                Value<String?> dispatchReceiptImagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VouchersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dateAndTime: dateAndTime,
                paymentStatus: paymentStatus,
                name: name,
                phone: phone,
                address: address,
                facebookAccount: facebookAccount,
                parcelNumber: parcelNumber,
                note: note,
                itemImagePath: itemImagePath,
                dispatchReceiptImagePath: dispatchReceiptImagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VouchersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VouchersTable,
      Voucher,
      $$VouchersTableFilterComposer,
      $$VouchersTableOrderingComposer,
      $$VouchersTableAnnotationComposer,
      $$VouchersTableCreateCompanionBuilder,
      $$VouchersTableUpdateCompanionBuilder,
      (Voucher, BaseReferences<_$AppDatabase, $VouchersTable, Voucher>),
      Voucher,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VouchersTableTableManager get vouchers =>
      $$VouchersTableTableManager(_db, _db.vouchers);
}
