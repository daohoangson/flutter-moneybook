import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'target_manager.dart';

class InternalContainer extends SingleChildRenderObjectWidget {
  InternalContainer({Widget child, Key key}) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderInternalContainer()..manager = TargetManager.of(context);

  @override
  void updateRenderObject(
          BuildContext context, _RenderInternalContainer renderObject) =>
      renderObject.manager = TargetManager.of(context);
}

class _RenderInternalContainer extends RenderProxyBox {
  TargetManager _manager;
  set manager(TargetManager v) {
    if (identical(v, _manager)) return;
    _manager = v;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _manager?.onContainerPainting(offset, size);
    super.paint(context, offset);
    _manager?.onContainerPainted();
  }
}
