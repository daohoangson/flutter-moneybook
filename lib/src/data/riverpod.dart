import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneybook/src/data/firestore_repository.dart';
import 'package:tuple/tuple.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart'
    show BuildContextX, ConsumerWidget, ScopedReader;

final bookProvider = StreamProvider.autoDispose.family(
    (ref, String bookId) => ref.watch(repositoryProvider).getBook(bookId));

final linesProvider = StreamProvider.autoDispose.family((ref, String bookId) =>
    ref.watch(repositoryProvider).getLines(bookId, limit: 20));

final linesSinceProvider = StreamProvider.autoDispose.family(
    (ref, Tuple2<String, LineModel> param) => ref
        .watch(repositoryProvider)
        .getLines(param.item1, limit: 20, since: param.item2));

final userBookProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(repositoryProvider).getUserBooks());
