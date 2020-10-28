import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/l10n/strings.dart';

import 'new_line_data.dart';

class AmountField extends ConsumerWidget {
  final VoidCallback onSubmitted;

  const AmountField({Key key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader reader) {
    final controller = reader(amountProvider);
    final focusNode = reader(focusNodeProvider);
    final strings = Strings.of(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: strings.lineAmountLabel,
        hintText: strings.lineAmountHint,
      ),
      focusNode: focusNode,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }
}
