import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/book_list/book_list_page.dart';
import 'package:moneybook/src/feat/book_view/book_view_page.dart';
import 'package:moneybook/src/l10n/strings.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final placeholder = Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).home),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );

    return FutureBuilder<String>(
      builder: (_, snapshot) {
        if (!snapshot.hasData) return placeholder;

        final currentBookId = snapshot.data;
        if (currentBookId.isEmpty) return BookListPage();

        return BookViewPage(
          currentBookId,
          isHomePage: true,
        );
      },
      future: watch(currentBookIdProvider.future),
    );
  }
}
