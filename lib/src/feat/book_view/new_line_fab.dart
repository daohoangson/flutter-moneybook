import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/l10n/strings.dart';
import 'package:moneybook/src/widget/keyboard_aware_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewLineFab extends StatelessWidget {
  final BookModel book;

  const NewLineFab(this.book, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          builder: (_) => _NewLineBottomSheet(book),
          context: context,
        ),
      );
}

class _NewLineBottomSheet extends StatefulWidget {
  final BookModel book;

  const _NewLineBottomSheet(this.book, {Key key}) : super(key: key);

  @override
  State<_NewLineBottomSheet> createState() => _NewLineBottomSheetState();
}

class _NewLineBottomSheetState extends State<_NewLineBottomSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);

    return KeyboardAwareBottomSheet(
      child: Padding(
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                labelText: strings.lineAmountLabel,
                hintText: strings.lineAmountHint,
              ),
            ),
            RaisedButton(
              child: Text(strings.save),
              onPressed: () async {
                final book =
                    await context.read(repositoryProvider).createBookLine(
                          widget.book,
                          LineModel(amount: int.tryParse(controller.text)),
                        );
                Navigator.of(context).pop(book);
              },
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
