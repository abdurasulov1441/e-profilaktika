import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarService {
  static const errorColor = Colors.red;
  static const okColor = Colors.green;

  static Future<void> showSnackBar(
      BuildContext context, String message, bool error) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // final snackBar = SnackBar(
    //   content: Text(message),
    //   backgroundColor: error ? errorColor : okColor,
    // );
    showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        error
            ? CustomSnackBar.error(message: message)
            : CustomSnackBar.success(message: message));

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
