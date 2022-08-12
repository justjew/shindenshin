import 'package:shindenshin/shindenshin.dart';
import 'book.dart';

class BookApi extends BaseModelApi<Book> {
  @override
  String get url => 'books';

  BookApi(BaseApiClient apiClient, BaseModelParser<Book> parser) : super(apiClient, parser);
}
