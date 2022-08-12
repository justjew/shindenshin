import 'package:shindenshin/shindenshin.dart';
import 'author.dart';

class AuthorParser extends BaseModelParser<Author> {
  @override
  Author fromJson(Map<String, Object?> json) {
    return Author.fromJson(json);
  }
}
