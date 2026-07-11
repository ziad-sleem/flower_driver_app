import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDriverToken({
    required String driverId,
    required String token,
  }) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveUserToken({
    required String userId,
    required String token,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> getUserToken(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) return null;

    return doc.data()?['fcmToken'];
  }

  Future<String?> getDriverToken(String driverId) async {
    final doc = await _firestore.collection('drivers').doc(driverId).get();

    if (!doc.exists) return null;

    return doc.data()?['fcmToken'];
  }
}
