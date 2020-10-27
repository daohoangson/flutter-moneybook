import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'internal.dart';

class AnimatedIndicatorTarget extends SingleChildRenderObjectWidget {
  final bool isActive;
  final Object tag;

  AnimatedIndicatorTarget({
    Widget child,
    this.isActive = false,
    Key key,
    this.tag,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAnimatedIndicatorTarget()
      ..updateTarget = UpdateTarget_.of(context)
      ..isActive = isActive
      ..tag = tag;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderAnimatedIndicatorTarget renderObject) {
    renderObject
      ..updateTarget = UpdateTarget_.of(context)
      ..isActive = isActive
      ..tag = tag;
  }
}

class _RenderAnimatedIndicatorTarget extends RenderProxyBox {
  UpdateTarget _updateTarget;
  set updateTarget(UpdateTarget v) {
    if (identical(v, _updateTarget)) return;
    _updateTarget = v;
    markNeedsPaint();
  }

  bool _isActive;
  set isActive(bool v) {
    if (v == _isActive) return;
    _isActive = v;
    markNeedsPaint();
  }

  Object _tag;
  set tag(Object v) {
    if (v == _tag) return;
    _tag = v;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_isActive == true) {
      _updateTarget?.call(offset, size, _tag);
    }

    super.paint(context, offset);
  }
}
