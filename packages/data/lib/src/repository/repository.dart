import '../model/book_model.dart';
import '../model/line_model.dart';

abstract class Repository {
  Future<BookModel> createBook(BookModel book);

  Future<LineModel> createBookLine(BookModel book, LineModel line);

  Stream<List<BookModel>> getBooks();

  Stream<List<LineModel>> getLines(String bookId);
}
