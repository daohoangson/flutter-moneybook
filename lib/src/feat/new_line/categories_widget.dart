import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_indicator/flutter_animated_indicator.dart';
import 'package:moneybook/src/data/riverpod.dart';

import 'new_line_data.dart';

class CategoriesWidget extends ConsumerWidget {
  const CategoriesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categories = watch(categoriesProvider);
    final isExpense = watch(isExpenseProvider).value;

    return SingleChildScrollView(
      child: AnimatedIndicator(
        child: Row(
          children: categories
              .map((category) => _CategoryWidget(category: category))
              .toList(growable: false),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
        ),
        painterBuilder: (_, rect) => _IndicatorPainter(
          isExpense ? colorExpense : colorIncome,
          rect,
        ),
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}

class _CategoryWidget extends ConsumerWidget {
  final LineCategory category;

  _CategoryWidget({this.category, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final value = watch(categoryProvider);
    final isActive = this.category == value.value;

    return GestureDetector(
      child: Padding(
        child: Stack(
          children: [
            Opacity(child: _buildText(context, true), opacity: 0),
            Positioned.fill(
              child: Center(
                child: AnimatedIndicatorTarget(
                  child: _buildText(context, isActive),
                  isActive: isActive,
                  tag: category,
                ),
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      ),
      onTap: () {
        if (isActive) {
          value.value = null;
        } else {
          value.value = category;
          context.read(focusNodeProvider).requestFocus();
        }
      },
      behavior: HitTestBehavior.translucent,
    );
  }

  Widget _buildText(BuildContext context, bool isActive) => Padding(
        child: Text(
          category.id,
          style: TextStyle(
            fontSize: DefaultTextStyle.of(context).style.fontSize * 1.5,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 3),
      );
}

class _IndicatorPainter extends CustomPainter {
  final Color color;
  final Rect rect;

  _IndicatorPainter(this.color, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    if (color == null || rect == null) return;
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomRight,
      Paint()
        ..color = color
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) =>
      color != oldDelegate.color || rect != oldDelegate.rect;
}
