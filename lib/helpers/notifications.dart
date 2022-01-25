import 'package:flutter/material.dart';

class NotificationHelper {
  static info(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        content: Text(
          msg,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
  static error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        content: Text(
          msg,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
