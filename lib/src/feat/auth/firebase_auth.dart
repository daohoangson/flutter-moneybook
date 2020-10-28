import 'dart:async';

import 'package:data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firebase_app.dart';

final authProvider = StreamProvider<UserModel>((ref) async* {
  final controller = StreamController<UserModel>();
  UserModel last;
  var signedInAnonymously = false;
  StreamSubscription sub;

  ref.onDispose(() {
    controller.close();
    sub?.cancel();
  });

  print('authProvider: waiting for firebaseAppProvider...');
  await ref.watch(firebaseAppProvider.future);

  final firebaseAuth = FirebaseAuth.instance;
  sub = firebaseAuth.userChanges().listen((firebaseUser) {
    if (firebaseUser == null && !signedInAnonymously) {
      print('authProvider: signInAnonymously...');
      firebaseAuth.signInAnonymously();
      signedInAnonymously = true;
    }

    final user = firebaseUser?.userModel;
    if (user == last) {
      print('authProvider: ignored event $firebaseUser');
      return;
    }

    print('authProvider: user changed $user');
    controller.sink.add(user);
    last = user;
  });

  yield* controller.stream;
});

extension _FirebaseUser on User {
  UserModel get userModel => UserModel(
        displayName: displayName,
        isAnonymous: isAnonymous,
        uid: uid,
      );
}
