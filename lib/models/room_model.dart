import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  final String id;
  final String roomNumber;
  final String description;
  final bool isOccupied;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomModel({
    required this.id,
    required this.roomNumber,
    required this.description,
    required this.isOccupied,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'description': description,
      'isOccupied': isOccupied,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RoomModel(
      id: doc.id,
      roomNumber: data['roomNumber'] ?? '',
      description: data['description'] ?? '',
      isOccupied: data['isOccupied'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
