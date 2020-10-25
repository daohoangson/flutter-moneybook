import '../model/book_model.dart';
import '../model/line_model.dart';

abstract class Repository {
  Future<BookModel> createBook(BookModel book);

  Future<LineModel> createBookLine(String bookId, LineModel line);

  Stream<BookModel> getBook(String bookId);

  Stream<List<LineModel>> getLines(String bookId, {int limit, LineModel since});

  Stream<List<String>> getUserBooks();
}
