import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? closeButtonText,
  String? confirmButtonText,
  VoidCallback? onClosePressed,
  VoidCallback? onConfirmPressed,
  bool showCloseButton = true,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/icons/electric.png',
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 3),
            Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              content,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showCloseButton) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClosePressed?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00A6FF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    closeButtonText ?? 'Batal',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 24),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmPressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00A6FF),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  confirmButtonText ?? 'OK',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
