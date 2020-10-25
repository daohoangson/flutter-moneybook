import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/book_view/line_list_widget.dart';
import 'package:moneybook/src/widget/book_name_widget.dart';

import 'book_stats_widget.dart';
import 'new_line_fab.dart';

class BookViewPage extends ConsumerWidget {
  final String bookId;

  BookViewPage(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return Scaffold(
      appBar: AppBar(
        title: BookNameWidget(bookId),
      ),
      body: Column(
        children: [
          BookStatsWidget(bookId),
          Expanded(child: LineListWidget(bookId)),
        ],
      ),
      floatingActionButton: NewLineFab(bookId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
