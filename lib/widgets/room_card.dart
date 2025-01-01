import 'package:flutter/material.dart';
import 'package:kaliko/models/user_model.dart';

class RoomCard extends StatelessWidget {
  final String id;
  final String roomId;
  final String name;
  final UserModel user;

  const RoomCard(
      {super.key,
      required this.id,
      required this.roomId,
      required this.name,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/admin/detail-room',
          arguments: {
            'user': user,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bed.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 8.0),
              Text(
                roomId,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
