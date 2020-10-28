import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';

import 'amount_field.dart';
import 'categories_widget.dart';
import 'new_line_data.dart';
import 'submit_button.dart';
import 'types_widget.dart';

class NewLineWidget extends StatelessWidget {
  final String bookId;

  const NewLineWidget(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          children: [
            const TypesWidget(),
            Padding(
              child: Column(
                children: [
                  AmountField(onSubmitted: () => _submit(context)),
                  const CategoriesWidget(),
                  SubmitButton(onSubmitted: () => _submit(context)),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      );

  void _submit(BuildContext context) async {
    final amountController = context.read(amountProvider);
    final amountInt = int.tryParse(amountController.text);
    if (amountInt == null || amountInt < 0) return;

    final category = context.read(categoryProvider).value;
    final isExpense = context.read(isExpenseProvider).value;

    final repository = await context.read(repositoryProvider.future);
    await repository.createBookLine(
      bookId,
      LineModel(
        amount: (isExpense ? -1 : 1) * amountInt,
        category: category,
      ),
    );

    amountController.clear();
    context.read(focusNodeProvider).unfocus();
  }
}
