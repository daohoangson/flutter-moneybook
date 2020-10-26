import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget get _typeExpenseButton => FlatButton(
        child: Text(
          _strings.lineAddExpense,
          style: _isExpense ? TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        onPressed: () {
          setState(() => _isExpense = true);
          focusNode.requestFocus();
        },
      );

  Widget get _typeIncomeButton => FlatButton(
        child: Text(
          _strings.lineAddIncome,
          style: !_isExpense ? TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        onPressed: () {
          setState(() => _isExpense = false);
          focusNode.requestFocus();
        },
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
