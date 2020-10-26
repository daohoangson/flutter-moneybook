import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/auth/firebase_auth.dart';
import 'package:moneybook/src/feat/book_list/book_list_page.dart';
import 'package:moneybook/src/feat/book_view/book_view_page.dart';
import 'package:moneybook/src/l10n/strings.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader reader) {
    final placeholder = Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).home),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );

    return _WatchUid(
      child: FutureBuilder<String>(
        builder: (_, snapshot) {
          if (!snapshot.hasData) return placeholder;

          final currentBookId = snapshot.data;
          if (currentBookId.isEmpty) return BookListPage();

          return BookViewPage(
            currentBookId,
            isHomePage: true,
          );
        },
        future: reader(currentBookIdProvider.future),
      ),
      placeholder: placeholder,
    );
  }
}

class _WatchUid extends ConsumerWidget {
  final Widget child;
  final Widget placeholder;

  _WatchUid({this.child, Key key, this.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return FutureBuilder<UserModel>(
      builder: (_, snapshot) =>
          snapshot.data?.uid != null ? child : placeholder,
      future: reader(authProvider.last),
    );
  }
}
