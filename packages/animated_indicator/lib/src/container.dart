import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'internal.dart';

class AnimatedIndicator extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final OnNewAnimation onNewAnimation;
  final PainterBuilder painterBuilder;

  const AnimatedIndicator({
    this.child,
    this.curve = Curves.easeOut,
    this.duration = const Duration(milliseconds: 200),
    Key key,
    this.onNewAnimation,
    this.painterBuilder,
  })  : assert(duration != null),
        super(key: key);

  @override
  State<AnimatedIndicator> createState() => _AnimatedIndicatorState();
}

typedef PainterBuilder = CustomPainter Function(
    BuildContext context, Rect rect);

typedef OnNewAnimation = void Function(Animation<double> animation, Object tag);

class _AnimatedIndicatorState extends State<AnimatedIndicator>
    with TickerProviderStateMixin {
  final key = GlobalKey();

  Animation<Rect> _animation;
  AnimationController _controller;
  Animation<double> _curve;
  Rect _targetRect;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _curve = widget.curve != null
        ? CurvedAnimation(parent: _controller, curve: widget.curve)
        : _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => updateTarget.widget(
        child: CustomPaint(
          child: widget.child,
          key: key,
          painter: _buildPainter(context),
        ),
      );

  void updateTarget(Offset offset, Size size, Object tag) {
    if (offset == null || size == null) return;

    final oldRect = _targetRect;
    final newRect =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    if (newRect == oldRect) return;
    _targetRect = newRect;

    if (_controller.isAnimating) {
      _animation =
          RectTween(begin: _animation.value, end: newRect).animate(_curve);
    } else {
      _animation =
          RectTween(begin: oldRect ?? newRect, end: newRect).animate(_curve);
    }
    _animation.addListener(() => setState(() {}));

    widget.onNewAnimation?.call(_curve, tag);

    return WidgetsBinding.instance.addPostFrameCallback((_) => _controller
      ..reset()
      ..forward());
  }

  CustomPainter _buildPainter(BuildContext context) {
    final offset = (key.currentContext?.findRenderObject() as RenderBox)
            ?.localToGlobal(Offset.zero) ??
        Offset.zero;
    final r = _animation?.value ?? _targetRect ?? Rect.zero;
    final rect = Rect.fromPoints(r.topLeft - offset, r.bottomRight - offset);
    return widget.painterBuilder?.call(context, rect) ??
        _DefaultPainter(Theme.of(context).accentColor, rect);
  }
}

class _DefaultPainter extends CustomPainter {
  final Color color;
  final Rect rect;

  _DefaultPainter(this.color, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    if (color == null || rect == null) return;
    canvas.drawRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_DefaultPainter oldDelegate) =>
      color != oldDelegate.color || rect != oldDelegate.rect;
}
