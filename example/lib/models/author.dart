import 'package:example/models/book.dart';
import 'package:shindenshin/shindenshin.dart';

class Author extends BaseModel {
  final String name;
  final List<Book> books;

  const Author({
    required int id,
    required this.name,
    required this.books,
  }) : super(id);

  @override
  Map toJson() {
    return {
      'id': id,
    };
  }
}

class AuthorApi extends BaseModelApi<Author> {
  @override
  String url = 'authors';

  @override
  Author fromJson(Map json) {
    return Author(
      id: json['id'],
      name: json['full_name'],
      books: BookApi().fromList(json['books']),
    );
  }
}
