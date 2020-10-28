import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'new_line_data.dart';

class SubmitButton extends ConsumerWidget {
  final VoidCallback onSubmitted;

  const SubmitButton({Key key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    final amount = reader(amountProvider);
    final isExpense = reader(isExpenseProvider).value;
    final strings = Strings.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: amount,
        builder: (_, child) => FlatButton(
          child: child,
          onPressed: amount.text.isEmpty ? null : onSubmitted,
        ),
        child: Text(
          isExpense ? strings.lineAddExpense : strings.lineAddIncome,
        ),
      ),
    );
  }
}
