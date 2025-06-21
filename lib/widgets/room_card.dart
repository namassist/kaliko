import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaliko/models/user_model.dart';

class RoomCard extends StatefulWidget {
  final String id;
  final String roomId;
  final String name;
  final UserModel user;
  final VoidCallback? onDelete;

  const RoomCard(
      {super.key,
      required this.id,
      required this.roomId,
      required this.name,
      required this.user,
      this.onDelete});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _isDeleteMode = false;

  void _handleTap() {
    if (_isDeleteMode) {
      setState(() {
        _isDeleteMode = false;
      });
    } else {
      Navigator.pushNamed(
        context,
        '/admin/detail-room',
        arguments: {
          'user': widget.user,
        },
      );
    }
  }

  void _handleLongPress() {
    if (widget.onDelete != null) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isDeleteMode = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/bed.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.roomId,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_isDeleteMode,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _isDeleteMode ? 1.0 : 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.person_remove_rounded,
                                      color: Colors.white, size: 40),
                                  onPressed: widget.onDelete,
                                  tooltip: 'Hentikan Sewa',
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Hentikan Sewa Pengguna Ini?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
