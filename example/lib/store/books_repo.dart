import 'package:example/models/author.dart';
import 'package:example/models/book.dart';
import 'package:shindenshin/shindenshin.dart';

class BooksRepo extends BaseRepo {
  late final BookApi bookApi;
  Book? book;

  BooksRepo(BaseStore store) : super(store) {
    bookApi = BookApi(store.apiClient, BookParser());
  }

  Future<void> retreive(dynamic bookId) async {
    book = await bookApi.retrieve(bookId);
  }

  Future<void> delete() async {
    if (book == null) {
      return;
    }

    return bookApi.detele(book!.id);
  }

  Future<List<Book>> getAuthorBooks(Author author) {
    final Map<String, dynamic> params = {'author': author.id};
    return bookApi.list(params: params);
  }
}