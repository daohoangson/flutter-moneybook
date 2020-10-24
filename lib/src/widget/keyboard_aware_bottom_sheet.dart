import 'package:flutter/widgets.dart';

class KeyboardAwareBottomSheet extends StatelessWidget {
  final Widget child;

  const KeyboardAwareBottomSheet({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        child: child,
        padding: _padding(context),
      );

  EdgeInsets _padding(BuildContext context) =>
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom);
}
