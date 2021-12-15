import 'package:example/store/authors_repo.dart';
import 'package:example/store/books_repo.dart';
import 'package:shindenshin/shindenshin.dart';

class Store extends BaseStore {
  Store() : super([
    AuthorsRepo.new,
    BooksRepo.new,
  ],releaseBaseHost: 'books.example.com');

  @override
  void initApiClient() {
    super.initApiClient();
    ApiClient().setConfig(ApiConfig(loginField: 'phone'));
  }
}