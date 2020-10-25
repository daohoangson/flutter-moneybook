import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/auth/firebase_auth.dart';

class BookStatsWidget extends ConsumerWidget {
  final String bookId;

  const BookStatsWidget(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext _, ScopedReader reader) {
    final uid = reader(authProvider)?.data?.value?.uid ?? '';

    return AspectRatio(
      aspectRatio: 3,
      child: SingleChildScrollView(
        child: FutureBuilder<BookModel>(
          builder: (context, snapshot) {
            final book = snapshot.data;
            return Row(
              children: [
                _buildBalance(context, book),
                _buildRole(context, book, uid),
              ],
            );
          },
          future: reader(bookProvider(bookId).last),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildBalance(BuildContext context, BookModel book) => AspectRatio(
        aspectRatio: 2,
        child: Card(
          child: Padding(
            child: Text(
              book?.balance?.toString() ?? '',
              style: Theme.of(context).textTheme.headline4,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
      );

  Widget _buildRole(BuildContext context, BookModel book, String uid) =>
      AspectRatio(
        aspectRatio: 2,
        child: Card(
          child: Padding(
            child: Text(
              book?.roles?.containsKey(uid) == true ? book.roles[uid] : '',
              style: Theme.of(context).textTheme.headline4,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
      );
}
