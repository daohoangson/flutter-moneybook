import 'package:flutter/material.dart';
import 'package:moneybook/src/feat/book_view/line_list_widget.dart';
import 'package:moneybook/src/widget/book_name_widget.dart';

import 'book_stats_widget.dart';
import 'new_line_fab.dart';

class BookViewPage extends StatefulWidget {
  final String bookId;

  BookViewPage(this.bookId, {Key key}) : super(key: key);

  @override
  _BookViewPageState createState() => _BookViewPageState();
}

class _BookViewPageState extends State<BookViewPage> {
  final anchor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BookNameWidget(widget.bookId),
      ),
      body: Column(
        children: [
          BookStatsWidget(widget.bookId),
          Expanded(
            child: LineListWidget(
              widget.bookId,
              upperLimit: anchor,
            ),
          ),
        ],
        key: anchor,
      ),
      floatingActionButton: NewLineFab(widget.bookId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
