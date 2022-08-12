import 'package:shindenshin/shindenshin.dart';
import 'book.dart';

class BookParser extends BaseModelParser<Book> {
  @override
  Book fromJson(Map<String, Object?> json) {
    return Book.fromJson(json);
  }
}
