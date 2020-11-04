import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:moneybook/src/data/persistence.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart'
    show
        BuildContextX,
        ChangeNotifierProvider,
        Consumer,
        ConsumerWidget,
        FutureProvider,
        Provider,
        Reader,
        ScopedReader;

final bookProvider =
    StreamProvider.autoDispose.family((ref, String bookId) async* {
  final repository = await ref.watch(repositoryProvider.future);
  yield* repository.getBook(bookId);
});

final currentBookIdProvider = FutureProvider((ref) =>
    ref.watch(persistenceProvider.future).then((p) => p.currentBookId));

final linesProvider =
    StreamProvider.autoDispose.family((ref, String bookId) async* {
  final repository = await ref.watch(repositoryProvider.future);
  yield* repository.getLines(bookId);
});

final userBooksProvider = StreamProvider.autoDispose((ref) async* {
  final repository = await ref.watch(repositoryProvider.future);
  yield* repository.getUserBooks();
});

class DataSourceWarmUp extends ConsumerWidget {
  final Widget child;

  DataSourceWarmUp({this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) => FutureBuilder(
        builder: (_, __) => child,
        future: Future.wait([
          watch(persistenceProvider.future),
          watch(repositoryProvider.future),
        ]),
      );
}
