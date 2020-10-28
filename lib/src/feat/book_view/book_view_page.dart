import 'package:flutter/material.dart';
import 'package:moneybook/src/data/persistence.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/book_list/book_list_page.dart';
import 'package:moneybook/src/feat/new_line/new_line_widget.dart';
import 'package:moneybook/src/widget/book_name_widget.dart';
import 'package:moneybook/src/widget/unfocus_widget.dart';

import 'book_id_picker.dart';
import 'book_stats_widget.dart';
import 'line_list_widget.dart';

class BookViewPage extends StatefulWidget {
  final String bookId;
  final bool isHomePage;

  BookViewPage(this.bookId, {this.isHomePage = false, Key key})
      : super(key: key);

  @override
  _BookViewPageState createState() => _BookViewPageState();
}

class _BookViewPageState extends State<BookViewPage> {
  final anchor = GlobalKey();

  @override
  void initState() {
    super.initState();
    context
        .read(persistenceProvider.future)
        .then((p) => p.currentBookId = widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: BookNameWidget(widget.bookId),
            onTap: () => _showBookPicker(context),
          ),
          actions: [
            if (widget.isHomePage)
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => BookListPage())),
              )
          ],
        ),
        body: Column(
          children: [
            BookStatsWidget(widget.bookId),
            NewLineWidget(widget.bookId),
            Expanded(
              child: LineListWidget(
                widget.bookId,
                upperLimit: anchor,
              ),
            ),
          ],
          key: anchor,
        ),
      ),
    );
  }

  void _showBookPicker(BuildContext context) async {
    final replacementBookId = await showModalBottomSheet(
      context: context,
      builder: (_) => BookIdPicker(
        selectedBookId: widget.bookId,
      ),
    );

    if (replacementBookId == null) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => BookViewPage(
          replacementBookId,
          isHomePage: widget.isHomePage,
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
              .animate(anim),
        ),
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
  }
}
