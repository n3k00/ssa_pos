class Voucher {
  static const Object _unset = Object();

  const Voucher({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.dateAndTime,
    required this.paymentStatus,
    required this.name,
    required this.phone,
    required this.address,
    required this.parcelNumber,
    this.facebookAccount,
    this.note,
    this.itemImagePath,
    this.dispatchReceiptImagePath,
    this.dispatchReceiptSavedAt,
    this.syncStatus = 'pending',
    this.syncedAt,
    this.createdDeviceId,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
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
  final String? dispatchReceiptSavedAt;
  final String syncStatus;
  final String? syncedAt;
  final String? createdDeviceId;

  Voucher copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dateAndTime,
    String? paymentStatus,
    String? name,
    String? phone,
    String? address,
    Object? facebookAccount = _unset,
    String? parcelNumber,
    Object? note = _unset,
    Object? itemImagePath = _unset,
    Object? dispatchReceiptImagePath = _unset,
    Object? dispatchReceiptSavedAt = _unset,
    String? syncStatus,
    Object? syncedAt = _unset,
    Object? createdDeviceId = _unset,
  }) {
    return Voucher(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      facebookAccount: identical(facebookAccount, _unset)
          ? this.facebookAccount
          : facebookAccount as String?,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      note: identical(note, _unset) ? this.note : note as String?,
      itemImagePath: identical(itemImagePath, _unset)
          ? this.itemImagePath
          : itemImagePath as String?,
      dispatchReceiptImagePath: identical(dispatchReceiptImagePath, _unset)
          ? this.dispatchReceiptImagePath
          : dispatchReceiptImagePath as String?,
      dispatchReceiptSavedAt: identical(dispatchReceiptSavedAt, _unset)
          ? this.dispatchReceiptSavedAt
          : dispatchReceiptSavedAt as String?,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: identical(syncedAt, _unset) ? this.syncedAt : syncedAt as String?,
      createdDeviceId: identical(createdDeviceId, _unset)
          ? this.createdDeviceId
          : createdDeviceId as String?,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'date_and_time': dateAndTime,
      'payment_status': paymentStatus,
      'name': name,
      'phone': phone,
      'address': address,
      'facebook_account': facebookAccount,
      'parcel_number': parcelNumber,
      'note': note,
      'item_image_path': itemImagePath,
      'dispatch_receipt_image_path': dispatchReceiptImagePath,
      'dispatch_receipt_saved_at': dispatchReceiptSavedAt,
      'sync_status': syncStatus,
      'synced_at': syncedAt,
      'created_device_id': createdDeviceId,
    };
  }

  factory Voucher.fromMap(Map<String, Object?> map) {
    return Voucher(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      dateAndTime: map['date_and_time'] as String,
      paymentStatus: map['payment_status'] as String? ?? 'payment_due',
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      facebookAccount: map['facebook_account'] as String?,
      parcelNumber: map['parcel_number'] as String,
      note: map['note'] as String?,
      itemImagePath: map['item_image_path'] as String?,
      dispatchReceiptImagePath: map['dispatch_receipt_image_path'] as String?,
      dispatchReceiptSavedAt: map['dispatch_receipt_saved_at'] as String?,
      syncStatus: map['sync_status'] as String? ?? 'pending',
      syncedAt: map['synced_at'] as String?,
      createdDeviceId: map['created_device_id'] as String?,
    );
  }
}
