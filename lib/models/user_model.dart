import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String fullname;
  final String origin;
  final String phone;
  final DateTime startDate;
  final String roomId;
  final String roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullname,
    required this.origin,
    required this.phone,
    required this.startDate,
    required this.roomId,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'origin': origin,
      'phone': phone,
      'startDate': startDate,
      'roomId': roomId,
      'roleId': roleId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      fullname: data['fullname'] ?? '',
      origin: data['origin'] ?? '',
      phone: data['phone'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      roomId: data['roomId'] ?? '',
      roleId: data['roleId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
