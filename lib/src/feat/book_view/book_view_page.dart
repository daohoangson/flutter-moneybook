import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';

import 'line_widget.dart';
import 'new_line_fab.dart';

final _linesProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getLines(bookId));

class BookViewPage extends ConsumerWidget {
  final BookModel book;

  BookViewPage(this.book, {Key key})
      : assert(book != null),
        super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name ?? book.id),
      ),
      body: StreamBuilder<List<LineModel>>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final lines = snapshot.data;
            return ListView.builder(
              itemBuilder: (_, i) => LineWidget(lines[i]),
              itemCount: lines.length,
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return const Center(child: CircularProgressIndicator());
        },
        stream: reader(_linesProvider.call(book.id).stream),
      ),
      floatingActionButton: NewLineFab(book),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
