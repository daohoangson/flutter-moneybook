import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/feat/auth/firebase_auth.dart';

final repositoryProvider = FutureProvider<Repository>((ref) async {
  print('repositoryProvider: waiting for authProvider...');
  final user = await ref.watch(authProvider.last);
  return ref.read(_dedupProvider(user));
});

// TODO: check why repository is being created twice for the same user
// our bug or riverpod's?
final _dedupProvider = Provider.family((ref, UserModel user) {
  print('repositoryProvider: OK (uid=${user?.uid})');
  return _FirestoreRepository(user);
});

const _kFieldId = 'id';

const _kCollectionBooks = 'books';
const _kBookFieldBalance = 'balance';

const _kCollectionLines = 'lines';
const _kLineFieldWhen = 'when';
const _kLineLimit = 20;

const _kCollectionUserBooks = 'user-books';

const _kRoleOwner = 'owner';

class _FirestoreRepository extends Repository {
  final UserModel user;

  _FirestoreRepository(this.user);

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Future<BookModel> createBook(BookModel book) async {
    final bookDoc = firestore.collection(_kCollectionBooks).doc();
    final role = _kRoleOwner;
    book = book.copyWith(
      id: bookDoc.id,
      roles: {user.uid: role},
    );

    final userBookDoc =
        firestore.collection(_kCollectionUserBooks).doc(user.uid);
    final userBookData = {bookDoc.id: role};

    await firestore.runTransaction((transaction) async {
      transaction.set(bookDoc, book.toJson());
      transaction.set(userBookDoc, userBookData, SetOptions(merge: true));
    });

    return book;
  }

  @override
  Future<LineModel> createBookLine(String bookId, LineModel line) async {
    final bookDoc = firestore.collection(_kCollectionBooks).doc(bookId);
    final lineDoc = bookDoc.collection(_kCollectionLines).doc();
    line = line.copyWith(
      id: lineDoc.id,
      uid: user.uid,
      when: DateTime.now(),
    );
    final lineData = {
      ...line.toJson(),
      _kLineFieldWhen: FieldValue.serverTimestamp()
    };

    await firestore.runTransaction((transaction) async {
      final book = await transaction.get(bookDoc);
      final balanceBefore = book.data()['balance'] as num ?? 0;
      final balanceAfter = balanceBefore + line.amount;

      transaction.set(lineDoc, lineData);
      transaction.update(bookDoc, {_kBookFieldBalance: balanceAfter});
    });

    return line;
  }

  Stream<BookModel> getBook(String bookId) {
    print('getBook($bookId)...');
    return firestore
        .collection(_kCollectionBooks)
        .doc(bookId)
        .snapshots()
        .map((doc) => doc.bookModel);
  }

  @override
  Stream<List<LineModel>> getLines(String bookId) {
    print('getLines($bookId)...');
    return firestore
        .collection(_kCollectionBooks)
        .doc(bookId)
        .collection(_kCollectionLines)
        .limit(_kLineLimit)
        .orderBy(_kLineFieldWhen, descending: true)
        .snapshots()
        .map((qs) =>
            qs.docs.map((doc) => doc.lineModel).toList(growable: false));
  }

  @override
  Future<List<LineModel>> getLinesOnce(String bookId, {LineModel since}) async {
    print('getLinesOnce($bookId, since: $since)...');
    var query = firestore
        .collection(_kCollectionBooks)
        .doc(bookId)
        .collection(_kCollectionLines)
        .limit(_kLineLimit)
        .orderBy(_kLineFieldWhen, descending: true);

    if (since != null) {
      final doc = _Mapper._docs[since];
      if (doc == null) {
        print('Unrecognized since value $since');
        // returning nothing seems to be safer...
        return [];
      }
      query = query.startAfterDocument(doc);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.lineModel).toList(growable: false);
  }

  @override
  Stream<List<String>> getUserBooks() {
    print('getUserBooks()...');
    return firestore
        .collection(_kCollectionUserBooks)
        .doc(user.uid)
        .snapshots()
        .map((userBooks) {
      if (!userBooks.exists) {
        return [];
      }

      return userBooks.data().keys.toList(growable: false);
    });
  }
}

extension _Mapper on DocumentSnapshot {
  static final _docs = Expando<DocumentSnapshot>();

  BookModel get bookModel {
    final model = BookModel.fromJson({...data(), _kFieldId: id});
    _docs[model] = this;
    return model;
  }

  LineModel get lineModel {
    final data = this.data();
    final model = LineModel.fromJson({
      ...data,
      _kFieldId: id,
      _kLineFieldWhen:
          (data[_kLineFieldWhen] as Timestamp)?.toDate()?.toIso8601String(),
    });

    _docs[model] = this;

    return model;
  }
}
