import 'package:firebase_core/firebase_core.dart';
import 'package:moneybook/src/data/riverpod.dart';

final firebaseAppProvider = FutureProvider<FirebaseApp>((_) async {
  print('firebaseAppProvider: initializeApp()...');
  final app = await Firebase.initializeApp();
  print('firebaseAppProvider: OK');
  return app;
});
