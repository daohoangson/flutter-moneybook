import 'dart:math';

import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_indicator/flutter_animated_indicator.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

final _controllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final _isExpenseProvider = ChangeNotifierProvider((_) => ValueNotifier(true));

class NewLineWidget extends StatefulWidget {
  final String bookId;

  const NewLineWidget(this.bookId, {Key key}) : super(key: key);

  @override
  State<NewLineWidget> createState() => _NewLineState();
}

class _NewLineState extends State<NewLineWidget> {
  final focusNode = FocusNode();

  Animation<Color> _indicatorColor;

  @override
  void dispose() {
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
                    child: Consumer(
                      builder: (_, watch, __) => Text(
                        watch(_isExpenseProvider).value
                            ? _strings.lineAddExpense
                            : _strings.lineAddIncome,
                      ),
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
            child: _TypeExpenseText(),
            padding: const EdgeInsets.all(8),
          ),
        ),
        onTap: () {
          isExpense = true;
          focusNode.requestFocus();
        },
        behavior: HitTestBehavior.translucent,
      );

  Widget get _typeIncomeButton => GestureDetector(
        child: Center(
          child: Padding(
            child: _TypeIncomeText(),
            padding: const EdgeInsets.all(8),
          ),
        ),
        onTap: () {
          isExpense = false;
          focusNode.requestFocus();
        },
        behavior: HitTestBehavior.translucent,
      );

  Strings get _strings => Strings.of(context);

  void _submit() async {
    final amount = int.tryParse(controller.text);
    if (amount == null || amount < 0) return;

    final repository = context.read(repositoryProvider);
    await repository.createBookLine(
      widget.bookId,
      LineModel(amount: (isExpense ? -1 : 1) * amount),
    );

    controller.clear();
    focusNode.unfocus();
  }
}

extension _BuildContext on _NewLineState {
  TextEditingController get controller => context.read(_controllerProvider);

  bool get isExpense => context.read(_isExpenseProvider).value;
  set isExpense(bool v) => context.read(_isExpenseProvider).value = v;
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

class _TypeExpenseText extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader reader) {
    final isExpense = reader(_isExpenseProvider).value;
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
  @override
  Widget build(BuildContext context, ScopedReader reader) {
    final isIncome = !reader(_isExpenseProvider).value;
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
