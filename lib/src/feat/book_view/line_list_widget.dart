import 'dart:math';

import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/line_list/line_list_page.dart';
import 'package:moneybook/src/widget/line_widget.dart';

class LineListWidget extends ConsumerWidget {
  final String bookId;
  final GlobalKey upperLimit;

  LineListWidget(this.bookId, {Key key, this.upperLimit}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    return StreamBuilder<List<LineModel>>(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final lines = snapshot.data;
          return _DraggableCard(
            child: ListView.builder(
              itemBuilder: (_, i) => LineWidget(lines[i]),
              itemCount: lines.length,
              physics: NeverScrollableScrollPhysics(),
            ),
            onPanEnd: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => LineListPage(bookId, lines),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 500),
              ),
            ),
            upperLimit: upperLimit,
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

class _DraggableCard extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onPanEnd;
  final GlobalKey upperLimit;

  _DraggableCard({this.child, Key key, this.onPanEnd, this.upperLimit})
      : super(key: key);

  @override
  State<_DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<_DraggableCard> {
  final anchor = GlobalKey();

  var _top = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final upperLimit =
            (widget.upperLimit?.currentContext?.findRenderObject() as RenderBox)
                    ?.localToGlobal(Offset.zero)
                    ?.dy ??
                0.0;
        final anchor =
            (this.anchor.currentContext?.findRenderObject() as RenderBox)
                    ?.localToGlobal(Offset.zero)
                    ?.dy ??
                0.0;
        assert(upperLimit < anchor);
        setState(() =>
            _top = max(upperLimit - anchor, min(0, _top + details.delta.dy)));
      },
      onPanEnd: (_) async {
        if (_top < 0) {
          await widget.onPanEnd();
          setState(() => _top = 0);
        }
      },
      child: Stack(
        children: [
          SizedBox.expand(key: anchor),
          Positioned.fill(
            top: _top,
            child: Material(child: widget.child),
          ),
        ],
        clipBehavior: Clip.none,
      ),
    );
  }
}
