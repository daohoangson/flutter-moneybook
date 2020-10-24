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
    book = book.copyWith(roles: {user.uid: role});

    final userBookDoc =
        _firestore.collection(_kCollectionUserBooks).doc(user.uid);
    final userBookData = {bookDoc.id: role};

    await _firestore.runTransaction((transaction) async {
      transaction.set(bookDoc, book.toJson());
      transaction.set(userBookDoc, userBookData, SetOptions(merge: true));
    });

    return book.copyWith(id: bookDoc.id);
  }

  @override
  Future<LineModel> createBookLine(BookModel book, LineModel line) async {
    final bookDoc = _firestore.collection(_kCollectionBooks).doc(book.id);
    final lineDoc = bookDoc.collection(_kCollectionLines).doc();
    line = line.copyWith(
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

    return line.copyWith(id: lineDoc.id);
  }

  @override
  Stream<List<BookModel>> getBooks() {
    StreamSubscription userBooksSubscription;
    StreamSubscription booksSubscription;

    StreamController<List<BookModel>> controller;

    controller = StreamController(
      onCancel: () {
        booksSubscription?.cancel();
        userBooksSubscription?.cancel();
        controller.close();
      },
    );

    if (user == null) return controller.stream;

    userBooksSubscription = _firestore
        .collection(_kCollectionUserBooks)
        .doc(user.uid)
        .snapshots()
        .listen((userBooks) {
      if (!userBooks.exists) {
        controller.sink.add([]);
        return;
      }

      final booksStream = _firestore
          .collection(_kCollectionBooks)
          .where(
            FieldPath.documentId,
            whereIn: userBooks.data().keys.toList(growable: false),
          )
          .snapshots();

      booksSubscription?.cancel();
      booksSubscription = booksStream.listen((snapshot) {
        final books = snapshot.docs
            .map((book) => BookModel.fromJson({
                  ...book.data(),
                  _kFieldId: book.id,
                }))
            .toList(growable: false);
        books.sort(_compareBooksByName);
        controller.sink.add(books);
      });
    });

    return controller.stream;
  }

  @override
  Stream<List<LineModel>> getLines(String bookId) => _firestore
      .collection(_kCollectionBooks)
      .doc(bookId)
      .collection(_kCollectionLines)
      .orderBy(_kLineFieldWhen, descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((line) {
          final data = line.data();
          final when =
              (data[_kLineFieldWhen] as Timestamp)?.toDate()?.toIso8601String();
          return LineModel.fromJson({
            ...data,
            _kFieldId: line.id,
            _kLineFieldWhen: when,
          });
        }).toList(growable: false),
      );
}

int _compareBooksByName(BookModel a, BookModel b) =>
    (a?.name ?? '').compareTo(b?.name ?? '');
