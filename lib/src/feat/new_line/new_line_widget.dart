import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';

import 'amount_field.dart';
import 'categories_widget.dart';
import 'new_line_data.dart';
import 'submit_button.dart';
import 'note.dart';
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
                  const CategoriesWidget(),
                  AmountField(onSubmitted: () => _submit(context)),
                  NoteField(onSubmitted: () => _submit(context)),
                  Row(
                    children: [
                      const Expanded(child: TagSuggestionsWidget()),
                      SubmitButton(onSubmitted: () => _submit(context)),
                    ],
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
              ),
              padding: const EdgeInsets.all(8),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      );

  void _submit(BuildContext context) async {
    final amountController = context.read(amountProvider);
    final amountInt = int.tryParse(amountController.text);
    if (amountInt == null || amountInt < 0) {
      context.read(focusNodeProvider).requestFocus();
      return;
    }

    final category = context.read(categoryProvider).value;
    final isExpense = context.read(isExpenseProvider).value;
    final note = context.read(noteProvider);

    final repository = await context.read(repositoryProvider.future);
    await repository.createBookLine(
      bookId,
      LineModel(
        amount: (isExpense ? -1 : 1) * amountInt,
        category: category,
        note: note.text,
      ),
    );

    amountController.clear();
    note.clear();
  }
}
