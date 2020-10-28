import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';
import 'package:moneybook/src/widget/keyboard_aware_bottom_sheet.dart';

class NewBookFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          builder: (_) => _NewBookBottomSheet(),
          context: context,
        ),
      );
}

class _NewBookBottomSheet extends StatefulWidget {
  @override
  State<_NewBookBottomSheet> createState() => _NewBookBottomSheetState();
}

class _NewBookBottomSheetState extends State<_NewBookBottomSheet> {
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
                labelText: strings.bookNameLabel,
                hintText: strings.bookNameHint,
              ),
              textCapitalization: TextCapitalization.words,
            ),
            RaisedButton(
              child: Text(strings.save),
              onPressed: () async {
                final book = await context
                    .read(repositoryProvider)
                    .createBook(BookModel(name: controller.text));
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
