import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:moneybook/src/data/riverpod.dart';

final firebaseAppProvider = FutureProvider<FirebaseApp>((_) async {
  print('firebaseAppProvider: initializeApp()...');
  final app = await initializeFirebase();
  print('firebaseAppProvider: OK');
  return app;
});

Completer<FirebaseApp> _completer;

Future<FirebaseApp> initializeFirebase() async {
  if (_completer == null) {
    _completer = Completer();
    try {
      final app = await Firebase.initializeApp();
      _completer.complete(app);
    } on Exception catch (e) {
      // If there's an error, explicitly return the future with an error.
      // then set the completer to null so we can retry.
      _completer.completeError(e);
      final future = _completer.future;
      _completer = null;
      return future;
    }
  }

  return _completer.future;
}
