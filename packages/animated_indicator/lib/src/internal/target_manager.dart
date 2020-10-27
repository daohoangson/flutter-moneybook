import 'package:flutter/widgets.dart';

mixin TargetManager<T extends StatefulWidget> on State<T> {
  Widget buildManagerWidget({Widget child}) => _InheritedWidget(
        child: child,
        targetManager: this,
      );

  void onContainerPainting(Offset offset, Size size);

  void onContainerPainted();

  void onActiveTargetPainting(Offset offset, Size size, Object tag);

  static TargetManager of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedWidget>()
      ?.targetManager;
}

class _InheritedWidget extends InheritedWidget {
  final TargetManager targetManager;

  const _InheritedWidget({Widget child, Key key, this.targetManager})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(_InheritedWidget oldWidget) =>
      !identical(targetManager, oldWidget.targetManager);
}
