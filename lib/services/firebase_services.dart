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

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('roleId', isEqualTo: 'user')
          .get();

      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel(
          id: doc.id,
          email: data['email'],
          fullname: data['fullname'],
          origin: data['origin'],
          phone: data['phone'],
          startDate: (data['startDate'] as Timestamp).toDate(),
          roomId: data['roomId'],
          roleId: data['roleId'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();

      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        return UserModel(
          id: user.uid,
          email: data['email'],
          fullname: data['fullname'],
          origin: data['origin'],
          phone: data['phone'],
          startDate: (data['startDate'] as Timestamp).toDate(),
          roomId: data['roomId'],
          roleId: data['roleId'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }

  Stream<PowerUsageModel> getRoomControling(String roomNumber) {
    return _rtdb
        .ref()
        .child('controling')
        .child(roomNumber)
        .onValue
        .map((event) {
      final data = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      return PowerUsageModel.fromRealtime(data);
    });
  }

  Stream<PowerUsageModel> getRoomPowerUsage(String roomNumber) {
    return _rtdb
        .ref()
        .child('monitoring')
        .child(roomNumber)
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
      await _rtdb.ref().child('controling').child(roomNumber).update({
        'jam': jam,
        'tanggal': tanggal,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetDeviceMonitoring(String roomNumber) async {
    try {
      await _rtdb.ref().child('monitoring').child(roomNumber).update({
        'current': 0,
        'energy': 0,
        'power': 0,
        'powerFactor': 0,
        'voltage': 0,
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
