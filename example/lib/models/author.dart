import 'package:example/models/book.dart';
import 'package:shindenshin/shindenshin.dart';

class Author extends BaseModel {
  final String name;
  final List<Book> books;

  const Author({
    super.id,
    required this.name,
    required this.books,
  });

  @override
  Map toJson() {
    return {
      'id': id,
    };
  }
}

class AuthorParser extends BaseModelParser<Author> {
  @override
  Author fromJson(Map json) {
    return Author(
      id: json['id'],
      name: json['full_name'],
      books: BookParser().fromList(json['books']),
    );
  }
}

class AuthorApi extends BaseModelApi<Author> {
  @override
  String url = 'authors';

  AuthorApi(BaseApiClient apiClient, BaseModelParser<Author> parser) : super(apiClient, parser);
}
