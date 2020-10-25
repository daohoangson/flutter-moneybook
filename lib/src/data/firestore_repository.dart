import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/feat/auth/firebase_auth.dart';

final repositoryProvider = Provider<Repository>(
    (ref) => _FirestoreRepository(ref.watch(authProvider).data?.value));

const _kFieldId = 'id';

const _kCollectionBooks = 'books';
const _kBookFieldBalance = 'balance';

const _kCollectionLines = 'lines';
const _kLineFieldWhen = 'when';

const _kCollectionUserBooks = 'user-books';

const _kRoleOwner = 'owner';

final _firestore = FirebaseFirestore.instance;

class _FirestoreRepository extends Repository {
  final UserModel user;

  _FirestoreRepository(this.user);

  @override
  Future<BookModel> createBook(BookModel book) async {
    final bookDoc = _firestore.collection(_kCollectionBooks).doc();
    final role = _kRoleOwner;
    book = book.copyWith(
      id: bookDoc.id,
      roles: {user.uid: role},
    );

    final userBookDoc =
        _firestore.collection(_kCollectionUserBooks).doc(user.uid);
    final userBookData = {bookDoc.id: role};

    await _firestore.runTransaction((transaction) async {
      transaction.set(bookDoc, book.toJson());
      transaction.set(userBookDoc, userBookData, SetOptions(merge: true));
    });

    return book;
  }

  @override
  Future<LineModel> createBookLine(String bookId, LineModel line) async {
    final bookDoc = _firestore.collection(_kCollectionBooks).doc(bookId);
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

    await _firestore.runTransaction((transaction) async {
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
    return _firestore
        .collection(_kCollectionBooks)
        .doc(bookId)
        .snapshots()
        .map((doc) => doc.bookModel);
  }

  @override
  Stream<List<LineModel>> getLines(String bookId,
      {int limit, LineModel since}) {
    print('getLines($bookId, limit: $limit, since: $since)...');
    var query = _firestore
        .collection(_kCollectionBooks)
        .doc(bookId)
        .collection(_kCollectionLines)
        .orderBy(_kLineFieldWhen, descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (since != null) {
      final doc = _Mapper._docs[since];
      if (doc == null) {
        print('Unrecognized since value $since');
        // returning nothing seems to be safer...
        return Stream.fromIterable([]);
      }
      query = query.startAfterDocument(doc);
    }

    return query.snapshots().map(
          (qs) => qs.docs.map((doc) => doc.lineModel).toList(growable: false),
        );
  }

  @override
  Stream<List<String>> getUserBooks() {
    print('getUserBooks()...');
    return _firestore
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
