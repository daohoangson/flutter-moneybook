import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final persistenceProvider = FutureProvider<Persistence>((_) async {
  final prefs = await SharedPreferences.getInstance();
  return _SharedPreferencesPersistence(prefs);
});

abstract class Persistence {
  String get currentBookId;
  set currentBookId(String v);
}

class _SharedPreferencesPersistence extends Persistence {
  static const _kCurrentBookId = 'currentBookId';

  final SharedPreferences prefs;

  _SharedPreferencesPersistence(this.prefs);

  @override
  String get currentBookId => prefs.getString(_kCurrentBookId) ?? '';

  @override
  set currentBookId(String v) => prefs.setString(_kCurrentBookId, v);
}
