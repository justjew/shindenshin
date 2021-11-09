import 'package:shindenshin/shindenshin.dart';

import 'author.dart';

class Book extends BaseModel {
  final String name;
  final int? pageCount;
  final Author? author;

  const Book({
    required int id,
    required this.name,
    required this.pageCount,
    required this.author,
  }) : super(id);

  @override
  Map toJson() {
    return {
      'id': id,
    };
  }
}

class BookApi extends BaseModelApi<Book> {
  @override
  String url = 'books';

  @override
  Book fromJson(Map json) {
    return Book(
      id: json['id'],
      name: json['name'],
      pageCount: json['pages'],
      author: AuthorApi().fromJson(json['author']),
    );
  }
}
