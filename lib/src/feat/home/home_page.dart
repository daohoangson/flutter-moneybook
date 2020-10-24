import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/feat/auth/firebase_auth.dart';
import 'package:moneybook/src/feat/book_list/book_list_page.dart';
import 'package:moneybook/src/l10n/strings.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).home),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Hello #${reader(authProvider).data?.value?.uid}'),
          ),
          _ListTile(
            Strings.of(context).bookList,
            (context) => BookListPage(),
          )
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;

  const _ListTile(this.title, this.builder, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: builder)),
    );
  }
}
