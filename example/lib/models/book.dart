import 'package:shindenshin/shindenshin.dart';

import 'author.dart';

class Book extends BaseModel {
  final String name;
  final int? pageCount;
  final Author? author;

  const Book({
    super.id,
    required this.name,
    required this.pageCount,
    required this.author,
  });

  @override
  Map toJson() {
    return {
      'id': id,
    };
  }
}

class BookParser extends BaseModelParser<Book> {
  @override
  Book fromJson(Map json) {
    return Book(
      id: json['id'],
      name: json['name'],
      pageCount: json['pages'],
      author: AuthorParser().fromJson(json['author']),
    );
  }
}

class BookApi extends BaseModelApi<Book> {
  @override
  String url = 'books';

  BookApi(BaseApiClient apiClient, BaseModelParser<Book> parser)
      : super(apiClient, parser);
}
