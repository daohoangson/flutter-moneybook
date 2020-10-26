import 'package:flutter/widgets.dart';

class Strings {
  const Strings._();

  static final app = 'moneybook';

  final save = 'Save';

  final home = 'Money Book';

  final bookList = 'Books';
  final bookNameLabel = 'Book name';
  final bookNameHint = 'Personal book';

  final lineAddExpense = 'Add expense';
  final lineAddIncome = 'Add income';
  final lineAmountLabel = 'Amount';
  final lineAmountHint = '0';

  static Strings of(BuildContext _) => const Strings._();
}
