import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/widget/book_name_widget.dart';
import 'package:moneybook/src/widget/line_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LineListPage extends StatefulWidget {
  final String bookId;
  final List<LineModel> initialLines;

  LineListPage(this.bookId, this.initialLines, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LineListState();
}

class _LineListState extends State<LineListPage> {
  final controller = RefreshController();
  final lines = <LineModel>[];

  var _hasMore = true;

  @override
  void initState() {
    super.initState();
    lines.addAll(widget.initialLines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: BookNameWidget(widget.bookId)),
      body: SmartRefresher(
        child: ListView.builder(
          itemBuilder: (_, i) => LineWidget(lines[i]),
          itemCount: lines.length,
        ),
        controller: controller,
        enablePullDown: false,
        enablePullUp: _hasMore,
        onLoading: _onLoading,
      ),
    );
  }

  void _onLoading() async {
    final repository = await context.read(repositoryProvider.future);
    final nextLines =
        await repository.getLinesOnce(widget.bookId, since: lines.last);
    if (nextLines.isNotEmpty) {
      lines.addAll(nextLines);
    } else {
      _hasMore = false;
    }
    if (mounted) {
      setState(() {});
    }
    controller.loadComplete();
  }
}
