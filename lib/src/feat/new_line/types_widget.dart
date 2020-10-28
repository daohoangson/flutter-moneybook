import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_indicator/flutter_animated_indicator.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'new_line_data.dart';

class TypesWidget extends StatefulWidget {
  const TypesWidget({Key key}) : super(key: key);

  @override
  State<TypesWidget> createState() => _TypesState();
}

class _TypesState extends State<TypesWidget> {
  Animation<Color> _indicatorColor;

  @override
  Widget build(BuildContext _) => AnimatedIndicator(
        child: Row(
          children: [
            Expanded(
              child: const _TypeButton(
                child: _TypeIncomeText(),
                isExpense: false,
              ),
            ),
            Expanded(
              child: const _TypeButton(
                child: _TypeExpenseText(),
                isExpense: true,
              ),
            ),
          ],
        ),
        onNewAnimation: (animation, tag) {
          _indicatorColor = ColorTween(
            begin: _indicatorColor?.value ?? Colors.transparent,
            end: tag == true ? colorExpense : colorIncome,
          ).animate(animation);
        },
        painterBuilder: (_, rect) =>
            _IndicatorPainter(_indicatorColor?.value, rect),
      );
}

class _IndicatorPainter extends CustomPainter {
  final Color color;
  final Rect rect;

  _IndicatorPainter(this.color, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    if (color == null || rect == null) return;
    final path = Path();
    final radius = min(rect.width / 2, rect.height / 2);

    final topLeft = rect.topLeft;
    path.moveTo(topLeft.dx, topLeft.dy + radius);
    path.quadraticBezierTo(
        topLeft.dx, topLeft.dy, topLeft.dx + radius, topLeft.dy);

    final topRight = rect.topRight;
    path.lineTo(topRight.dx - radius, topRight.dy);
    path.quadraticBezierTo(
        topRight.dx, topRight.dy, topRight.dx, topRight.dy + radius);

    final bottomRight = rect.bottomRight;
    path.lineTo(bottomRight.dx, bottomRight.dy - radius);
    path.quadraticBezierTo(bottomRight.dx, bottomRight.dy,
        bottomRight.dx - radius, bottomRight.dy);

    final bottomLeft = rect.bottomLeft;
    path.lineTo(bottomLeft.dx + radius, bottomLeft.dy);
    path.quadraticBezierTo(
        bottomLeft.dx, bottomLeft.dy, bottomLeft.dx, bottomLeft.dy - radius);

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) =>
      color != oldDelegate.color || rect != oldDelegate.rect;
}

class _TypeButton extends StatelessWidget {
  final Widget child;
  final bool isExpense;

  const _TypeButton({this.child, this.isExpense, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Center(
          child: Padding(
            child: child,
            padding: const EdgeInsets.all(8),
          ),
        ),
        onTap: () {
          context.read(isExpenseProvider).value = isExpense;
          context.read(focusNodeProvider).requestFocus();
        },
        behavior: HitTestBehavior.translucent,
      );
}

class _TypeExpenseText extends ConsumerWidget {
  const _TypeExpenseText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isExpense = watch(isExpenseProvider).value;
    final text = Strings.of(context).lineAddExpense;
    return AnimatedIndicatorTarget(
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontWeight: isExpense ? FontWeight.bold : null),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      isActive: isExpense,
      tag: true,
    );
  }
}

class _TypeIncomeText extends ConsumerWidget {
  const _TypeIncomeText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isIncome = !watch(isExpenseProvider).value;
    final text = Strings.of(context).lineAddIncome;
    return AnimatedIndicatorTarget(
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontWeight: isIncome ? FontWeight.bold : null),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      isActive: isIncome,
      tag: false,
    );
  }
}
