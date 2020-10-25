import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart'
    show BuildContextX, ConsumerWidget, ScopedReader;

final bookProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getBook(bookId));

final linesProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getLines(bookId));

final userBookProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(repositoryProvider).getUserBooks());
