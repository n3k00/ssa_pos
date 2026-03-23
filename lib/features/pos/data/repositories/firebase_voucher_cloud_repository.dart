import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_cloud_repository.dart';

class FirebaseVoucherCloudRepository implements VoucherCloudRepository {
  FirebaseVoucherCloudRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _vouchersCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated Firebase user found.');
    }

    return _firestore
        .collection('accounts')
        .doc(user.uid)
        .collection('vouchers');
  }

  @override
  Future<void> upsert(Voucher voucher, {required String deviceId}) async {
    final syncedAt =
        voucher.syncedAt ?? DateTime.now().toUtc().toIso8601String();
    final createdDeviceId = voucher.createdDeviceId ?? deviceId;

    await _vouchersCollection().doc(voucher.id).set({
      'id': voucher.id,
      'createdAt': voucher.createdAt.toUtc().toIso8601String(),
      'updatedAt': voucher.updatedAt.toUtc().toIso8601String(),
      'dateAndTime': voucher.dateAndTime,
      'paymentStatus': voucher.paymentStatus,
      'name': voucher.name,
      'phone': voucher.phone,
      'address': voucher.address,
      'facebookAccount': voucher.facebookAccount,
      'parcelNumber': voucher.parcelNumber,
      'note': voucher.note,
      // Local file paths are device-specific. Keep them out of Firestore until
      // Storage-backed image sync is implemented.
      'dispatchReceiptSavedAt': voucher.dispatchReceiptSavedAt,
      'createdDeviceId': createdDeviceId,
      'syncedAt': syncedAt,
    }, SetOptions(merge: true));
  }

  @override
  Future<List<Voucher>> fetchAll() async {
    final snapshot = await _vouchersCollection()
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => _fromCloudMap(doc.id, doc.data()))
        .toList(growable: false);
  }

  Voucher _fromCloudMap(String docId, Map<String, dynamic> map) {
    final createdAtIso =
        (map['createdAt'] as String?) ?? DateTime.now().toUtc().toIso8601String();
    final updatedAtIso = (map['updatedAt'] as String?) ?? createdAtIso;

    return Voucher(
      id: (map['id'] as String?) ?? docId,
      createdAt: DateTime.parse(createdAtIso),
      updatedAt: DateTime.parse(updatedAtIso),
      dateAndTime: (map['dateAndTime'] as String?) ?? createdAtIso,
      paymentStatus: (map['paymentStatus'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      address: (map['address'] as String?) ?? '',
      facebookAccount: map['facebookAccount'] as String?,
      parcelNumber: (map['parcelNumber'] as String?) ?? '',
      note: map['note'] as String?,
      itemImagePath: null,
      dispatchReceiptImagePath: null,
      dispatchReceiptSavedAt: map['dispatchReceiptSavedAt'] as String?,
      syncStatus: 'synced',
      syncedAt: map['syncedAt'] as String?,
      createdDeviceId: map['createdDeviceId'] as String?,
    );
  }
}
