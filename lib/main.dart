import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/riverpod.dart';
import 'package:moneybook/src/feat/home/home_page.dart';
import 'package:moneybook/src/l10n/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget built = MaterialApp(
      title: Strings.app,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );

    built = DataSourceWarmUp(child: built);

    built = ProviderScope(child: built);

    return built;
  }
}
