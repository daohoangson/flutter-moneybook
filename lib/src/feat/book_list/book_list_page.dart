import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'book_widget.dart';
import 'new_book_fab.dart';

final _booksProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(repositoryProvider).getBooks());

class BookListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).bookList),
      ),
      body: StreamBuilder<List<BookModel>>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final books = snapshot.data;
            return ListView.builder(
              itemBuilder: (_, i) => BookWidget(books[i]),
              itemCount: books.length,
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return const Center(child: CircularProgressIndicator());
        },
        stream: reader(_booksProvider.stream),
      ),
      floatingActionButton: NewBookFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
