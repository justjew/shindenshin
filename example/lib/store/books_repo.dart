import 'package:example/models/author.dart';
import 'package:example/models/book.dart';
import 'package:shindenshin/shindenshin.dart';

import 'store.dart';

class BooksRepo extends BaseRepo {
  Book? book;

  BooksRepo(Store store) : super(store);

  Future<void> retreive(dynamic bookId) async {
    book = await BookApi().retrieve(bookId);
  }

  Future<void> delete() async {
    if (book == null) {
      return;
    }

    return BookApi().detele(book!.id);
  }

  Future<List<Book>> getAuthorBooks(Author author) {
    final Map<String, dynamic> params = {'author': author.id};
    return BookApi().list(params: params);
  }
}