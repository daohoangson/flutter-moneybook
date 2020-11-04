import 'package:flutter/material.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'new_line_data.dart';

class NoteField extends ConsumerWidget {
  final VoidCallback onSubmitted;

  const NoteField({Key key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(noteProvider);
    final strings = Strings.of(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: strings.lineNoteLabel,
        hintText: strings.lineNoteHint,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }
}

class TagSuggestionsWidget extends ConsumerWidget {
  const TagSuggestionsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tags = watch(tagSuggestionsProvider);
    if (tags.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Row(
        children: [
          Text(Strings.of(context).lineTagSuggestions),
          ...tags
              .map((tag) => _TagSuggestionWidget(tag: tag))
              .toList(growable: false),
        ],
        mainAxisSize: MainAxisSize.max,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}

class _TagSuggestionWidget extends StatelessWidget {
  final String tag;

  const _TagSuggestionWidget({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        child: Text('#$tag'),
        padding: const EdgeInsets.all(4),
      ),
      onTap: () {
        final note = context.read(noteProvider);
        final value = note.value;
        final text = (value.text.isNotEmpty ? '${value.text} ' : '') + '#$tag';
        note.value = value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      },
    );
  }
}
