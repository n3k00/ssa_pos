import 'package:drift/drift.dart';

class Vouchers extends Table {
  TextColumn get id => text()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
  TextColumn get dateAndTime => text().named('date_and_time')();
  TextColumn get paymentStatus =>
      text().named('payment_status').withDefault(const Constant('payment_due'))();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn get facebookAccount => text().named('facebook_account').nullable()();
  TextColumn get parcelNumber => text().named('parcel_number')();
  TextColumn get note => text().nullable()();
  TextColumn get itemImagePath => text().named('item_image_path').nullable()();
  TextColumn get dispatchReceiptImagePath =>
      text().named('dispatch_receipt_image_path').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
