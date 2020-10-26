import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget child;

  UnfocusWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
