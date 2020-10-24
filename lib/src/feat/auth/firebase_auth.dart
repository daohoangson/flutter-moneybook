import 'package:data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StreamProvider<UserModel>((_) async* {
  final user = _firebaseAuth.currentUser;
  if (user == null) {
    _firebaseAuth.signInAnonymously();
  }

  yield* _firebaseAuth.authStateChanges().map(_mapper);
});

final _firebaseAuth = FirebaseAuth.instance;

UserModel _mapper(User user) => UserModel(
      displayName: user?.displayName,
      isAnonymous: user?.isAnonymous,
      uid: user?.uid,
    );
