import 'package:flutter/material.dart';

class Info {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackbarMessage(BuildContext context,
          {required String message,
          String? label,
          Duration duration = const Duration(seconds: 1)}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) Text(label),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        duration: duration,
      ),
    );
  }
}
