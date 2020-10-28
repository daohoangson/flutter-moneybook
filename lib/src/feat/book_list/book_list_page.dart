import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'book_widget.dart';
import 'new_book_fab.dart';

class BookListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).bookList),
      ),
      body: FutureBuilder<List<String>>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final bookIds = snapshot.data;
            return ListView.builder(
              itemBuilder: (_, i) => BookWidget(bookIds[i]),
              itemCount: bookIds.length,
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return const Center(child: CircularProgressIndicator());
        },
        future: watch(userBooksProvider.last),
      ),
      floatingActionButton: NewBookFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
