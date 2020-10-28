import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneybook/src/data/riverpod.dart';

final colorExpense = Colors.orange[200];
final colorIncome = Colors.lime[200];

final amountProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final categoriesProvider = Provider<List<LineCategory>>((ref) {
  final isExpense = ref.watch(isExpenseProvider).value;
  final categories = isExpense ? expenseCategories : incomeCategories;

  final category = ref.read(categoryProvider);
  if (!categories.contains(category.value)) {
    // unset category if it's not in the same group
    category.value = null;
  }

  return categories;
});

final categoryProvider =
    ChangeNotifierProvider((_) => ValueNotifier<LineCategory>(null));

final focusNodeProvider = Provider<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());
  return focusNode;
});

final isExpenseProvider = ChangeNotifierProvider((_) => ValueNotifier(true));
