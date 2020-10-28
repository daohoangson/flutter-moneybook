import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/book_view/book_view_page.dart';

class BookWidget extends ConsumerWidget {
  final String bookId;

  const BookWidget(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return FutureBuilder<BookModel>(
      builder: (_, snapshot) {
        final book = snapshot.data;
        return ListTile(
          title: Text(book?.name ?? ''),
          subtitle: Text(book?.balance?.toString() ?? ''),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BookViewPage(bookId))),
        );
      },
      future: watch(bookProvider(bookId).last),
    );
  }
}
