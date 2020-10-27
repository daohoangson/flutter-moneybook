import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          Row(
            children: [
              Expanded(child: _typeIncomeButton),
              Expanded(child: _typeExpenseButton),
            ],
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

  Widget get _typeExpenseButton => FlatButton(
        child: Consumer(
          builder: (__, watch, _) => Text(
            _strings.lineAddExpense,
            style: watch(_isExpenseProvider).value
                ? TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ),
        onPressed: () {
          isExpense = true;
          focusNode.requestFocus();
        },
      );

  Widget get _typeIncomeButton => FlatButton(
        child: Consumer(
          builder: (__, watch, _) => Text(
            _strings.lineAddIncome,
            style: !watch(_isExpenseProvider).value
                ? TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ),
        onPressed: () {
          isExpense = false;
          focusNode.requestFocus();
        },
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
