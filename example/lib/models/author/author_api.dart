import 'package:shindenshin/shindenshin.dart';
import 'author.dart';

class AuthorApi extends BaseModelApi<Author> {
  @override
  String get url => 'authors';

  AuthorApi(BaseApiClient apiClient, BaseModelParser<Author> parser) : super(apiClient, parser);
}
