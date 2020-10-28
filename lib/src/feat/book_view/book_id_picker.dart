import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/widget/book_name_widget.dart';

class BookIdPicker extends ConsumerWidget {
  final String selectedBookId;

  BookIdPicker({Key key, this.selectedBookId}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return FutureBuilder<List<String>>(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final bookIds = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, i) => _buildItem(context, bookIds[i]),
            itemCount: bookIds.length,
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return const Center(child: CircularProgressIndicator());
      },
      future: reader(userBooksProvider.last),
    );
  }

  Widget _buildItem(BuildContext context, String bookId) {
    final selected = bookId == selectedBookId;
    return ListTile(
      onTap: selected ? null : () => Navigator.of(context).pop(bookId),
      selected: selected,
      title: BookNameWidget(bookId),
    );
  }
}
