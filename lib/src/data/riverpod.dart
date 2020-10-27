import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/persistence.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart'
    show
        BuildContextX,
        ChangeNotifierProvider,
        Consumer,
        ConsumerWidget,
        Provider,
        ScopedReader;

final bookProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getBook(bookId));

final currentBookIdProvider = FutureProvider((ref) =>
    ref.watch(persistenceProvider.future).then((p) => p.currentBookId));

final linesProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getLines(bookId));

final userBookProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(repositoryProvider).getUserBooks());
