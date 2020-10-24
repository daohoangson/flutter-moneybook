import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/feat/book_view/book_view_page.dart';

class BookWidget extends StatelessWidget {
  final BookModel book;

  const BookWidget(this.book, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(book.name),
        subtitle: Text(book.balance.toString()),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => BookViewPage(book))),
      );
}
