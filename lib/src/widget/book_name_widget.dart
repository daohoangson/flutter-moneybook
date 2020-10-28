import 'package:data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:moneybook/src/data/riverpod.dart';

class BookNameWidget extends ConsumerWidget {
  final String bookId;

  BookNameWidget(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext _, ScopedReader watch) => FutureBuilder<BookModel>(
        builder: (_, snapshot) => Text(snapshot.data?.name ?? ''),
        future: watch(bookProvider(bookId).last),
      );
}
