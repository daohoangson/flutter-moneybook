import 'package:flutter/widgets.dart';

typedef UpdateTarget = void Function(Offset offset, Size size, Object tag);

extension UpdateTarget_ on UpdateTarget {
  Widget widget({Widget child}) => _InheritedWidget(
        child: child,
        updateTarget: this,
      );

  static UpdateTarget of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedWidget>()
      ?.updateTarget;
}

class _InheritedWidget extends InheritedWidget {
  final UpdateTarget updateTarget;

  const _InheritedWidget({Widget child, Key key, this.updateTarget})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(_InheritedWidget oldWidget) =>
      !identical(updateTarget, oldWidget.updateTarget);
}
