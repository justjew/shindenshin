import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shindenshin/shindenshin.dart';

import 'author.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book extends BaseModel with _$Book {
  const factory Book({
    required dynamic id,
    required String name,
    required int? pageCount,
    required Author? author,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}

class BookParser extends BaseModelParser<Book> {
  @override
  Book fromJson(Map<String, Object?> json) {
    return Book.fromJson(json);
  }
}

class BookApi extends BaseModelApi<Book> {
  @override
  String get url => 'books';

  BookApi(BaseApiClient apiClient, BaseModelParser<Book> parser) : super(apiClient, parser);
}

void asdf() {
  const Book book = Book(id: 1, name: 'name', pageCount: 1, author: null);
  book.copyWith(pageCount: null);
}
