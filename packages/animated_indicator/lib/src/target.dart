import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'internal/target_manager.dart';

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
      ..manager = TargetManager.of(context)
      ..isActive = isActive
      ..tag = tag;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderAnimatedIndicatorTarget renderObject) {
    renderObject
      ..manager = TargetManager.of(context)
      ..isActive = isActive
      ..tag = tag;
  }
}

class _RenderAnimatedIndicatorTarget extends RenderProxyBox {
  TargetManager _manager;
  set manager(TargetManager v) {
    if (identical(v, _manager)) return;
    _manager = v;
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
      _manager?.onActiveTargetPainting(offset, size, _tag);
    }

    super.paint(context, offset);
  }
}
