import 'dart:math';

import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_indicator/flutter_animated_indicator.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

class NewLineWidget extends StatefulWidget {
  final String bookId;

  const NewLineWidget(this.bookId, {Key key}) : super(key: key);

  @override
  State<NewLineWidget> createState() => _NewLineState();
}

class _NewLineState extends State<NewLineWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  var _isExpense = true;
  Animation<Color> _indicatorColor;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AnimatedIndicator(
            child: Row(
              children: [
                Expanded(child: _typeIncomeButton),
                Expanded(child: _typeExpenseButton),
              ],
            ),
            onNewAnimation: (animation, tag) {
              _indicatorColor = ColorTween(
                begin: _indicatorColor?.value ?? Colors.transparent,
                end: tag == true
                    ? Colors.red
                    : Theme.of(context).secondaryHeaderColor,
              ).animate(animation);
            },
            painterBuilder: (_, rect) =>
                _IndicatorPainter(_indicatorColor?.value, rect),
          ),
          Padding(
            child: Column(
              children: [
                _amountField,
                Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) => FlatButton(
                      child: child,
                      onPressed: controller.text.isEmpty ? null : _submit,
                    ),
                    child: Text(
                      _isExpense
                          ? _strings.lineAddExpense
                          : _strings.lineAddIncome,
                    ),
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget get _amountField => TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: _strings.lineAmountLabel,
          hintText: _strings.lineAmountHint,
        ),
        focusNode: focusNode,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      );

  Widget get _typeExpenseButton => GestureDetector(
        child: Center(
          child: Padding(
            child: AnimatedIndicatorTarget(
              child: Padding(
                child: Text(
                  _strings.lineAddExpense,
                  style: _isExpense
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              isActive: _isExpense,
              tag: true,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
        onTap: () {
          setState(() => _isExpense = true);
          focusNode.requestFocus();
        },
        behavior: HitTestBehavior.translucent,
      );

  Widget get _typeIncomeButton => GestureDetector(
        child: Center(
          child: Padding(
            child: AnimatedIndicatorTarget(
              child: Padding(
                child: Text(
                  _strings.lineAddIncome,
                  style: !_isExpense
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              isActive: !_isExpense,
              tag: false,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
        onTap: () {
          setState(() => _isExpense = false);
          focusNode.requestFocus();
        },
        behavior: HitTestBehavior.translucent,
      );

  Strings get _strings => Strings.of(context);

  void _submit() async {
    final repository = context.read(repositoryProvider);
    final amount = int.tryParse(controller.text);
    await repository.createBookLine(
      widget.bookId,
      LineModel(amount: (_isExpense ? -1 : 1) * amount),
    );

    controller.clear();
    focusNode.unfocus();
  }
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
