import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';

class LineListWidget extends ConsumerWidget {
  final String bookId;

  LineListWidget(this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return StreamBuilder<List<LineModel>>(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final lines = snapshot.data;
          return ListView.builder(
            itemBuilder: (_, i) => _LineWidget(lines[i]),
            itemCount: lines.length,
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return const Center(child: CircularProgressIndicator());
      },
      stream: reader(linesProvider(bookId).stream),
    );
  }
}

class _LineWidget extends StatelessWidget {
  final LineModel line;

  const _LineWidget(this.line, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(line.when.toString()),
        subtitle: Text(line.amount.toString()),
      );
}
