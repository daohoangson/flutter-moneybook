import 'package:data/data.dart';
import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  final LineModel line;

  const LineWidget(this.line, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
        child: Material(
          child: ListTile(
            title: Text(line.when.toString()),
            subtitle: Text('${line.category?.id} ${line.note} ${line.amount}'),
          ),
        ),
        tag: 'LineWidget-${line.id}',
      );
}
