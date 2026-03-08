class Voucher {
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

  Voucher copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dateAndTime,
    String? paymentStatus,
    String? name,
    String? phone,
    String? address,
    String? facebookAccount,
    String? parcelNumber,
    String? note,
    String? itemImagePath,
    String? dispatchReceiptImagePath,
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
      facebookAccount: facebookAccount ?? this.facebookAccount,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      note: note ?? this.note,
      itemImagePath: itemImagePath ?? this.itemImagePath,
      dispatchReceiptImagePath:
          dispatchReceiptImagePath ?? this.dispatchReceiptImagePath,
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
    );
  }
}
