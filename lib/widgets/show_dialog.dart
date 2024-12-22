import 'package:flutter/material.dart';

// Reusable Dialog Widget with two buttons: Close and Confirm
Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String? content,
  String? closeButtonText,
  String? confirmButtonText,
  VoidCallback? onClosePressed,
  VoidCallback? onConfirmPressed,
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
            const Text("Pemberitahuan",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              "Apakah benar melakukan pembayaran?",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (onClosePressed != null) {
                    onClosePressed(); // Execute custom close action
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00A6FF),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  closeButtonText ?? 'Close',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (onClosePressed != null) {
                    onClosePressed(); // Execute custom close action
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00A6FF),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  confirmButtonText ?? 'Close',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
