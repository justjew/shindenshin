import 'package:example/models/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shindenshin/shindenshin.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
class Author extends BaseModel with _$Author {
  const factory Author({
    required dynamic id,
    required String name,
    required List<Book> books,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
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
