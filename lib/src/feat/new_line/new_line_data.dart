import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneybook/src/data/builtin_tags.dart';
import 'package:moneybook/src/data/riverpod.dart';

final colorExpense = Colors.orange[200];
final colorIncome = Colors.lime[200];

final amountProvider = ChangeNotifierProvider((_) => TextEditingController());

final categoriesProvider = Provider<List<LineCategory>>((ref) {
  final isExpense = ref.watch(isExpenseProvider).value;
  return isExpense ? expenseCategories : incomeCategories;
});

final _categoryProvider =
    ChangeNotifierProvider((_) => ValueNotifier<LineCategory>(null));

final categoryProvider = Provider<LineCategoryValue>((ref) {
  final value = ref.watch(_categoryProvider).value;
  final categories = ref.watch(categoriesProvider);
  return LineCategoryValue(
    categories.contains(value) ? value : null,
    ref.read,
  );
});

class LineCategoryValue {
  final LineCategory _value;
  final Reader _read;

  LineCategoryValue(this._value, this._read);

  LineCategory get value => _value;
  set value(LineCategory v) => _read(_categoryProvider).value = v;
}

final focusNodeProvider = Provider<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());
  return focusNode;
});

final isExpenseProvider = ChangeNotifierProvider((_) => ValueNotifier(true));

final noteProvider = ChangeNotifierProvider((_) => TextEditingController());

final tagSuggestionsProvider = Provider<List<String>>((ref) {
  final note = ref.watch(noteProvider).text;
  if (note.isNotEmpty) return const [];

  final category = ref.watch(categoryProvider).value;
  return category?.tags ?? const [];
});
