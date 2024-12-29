// lib/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaliko/models/power_usage_model.dart';
import 'package:kaliko/models/room_model.dart';
import 'package:kaliko/models/user_model.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRoom(RoomModel room) async {
    try {
      await _firestore.collection('rooms').doc(room.id).set(room.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<PowerUsageModel> getRoomPowerUsage(String roomNumber) {
    return _rtdb
        .ref()
        .child('monitoring')
        .child('kamar$roomNumber')
        .onValue
        .map((event) {
      final data = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      return PowerUsageModel.fromRealtime(data);
    });
  }

  Future<void> updateDeviceControl(
      String roomNumber, String jam, String tanggal) async {
    try {
      await _rtdb.ref().child('controlling').child('kamar$roomNumber').update({
        'jam': jam,
        'tanggal': tanggal,
        'lastUpdated': ServerValue.timestamp,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> savePowerUsageHistory(
      String roomId, PowerUsageModel powerUsage) async {
    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('power_history')
          .add(powerUsage.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
