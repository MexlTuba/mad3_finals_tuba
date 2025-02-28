import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mad3_finals_tuba/services/information_service.dart';

class WaitingDialog extends StatelessWidget {
  static Future<T?> show<T>(BuildContext context,
      {required Future<T> future, String? prompt, Color? color}) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dCon) {
            return WaitingDialog(prompt: prompt, color: color);
          });
      T result = await future;
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return result;
    } catch (e, st) {
      print(e);
      print(st);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Info.showSnackbarMessage(
          context,
          message: e.toString(),
          duration: const Duration(seconds: 1),
        );
      }
      return null;
    }
  }

  final String? prompt;
  final Color? color;

  const WaitingDialog({super.key, this.prompt, this.color});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitRipple(
              color: color ?? Colors.white,
              size: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              prompt ?? "Please wait . . .",
              style: TextStyle(color: color ?? Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
