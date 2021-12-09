import 'package:example/store/authors_repo.dart';
import 'package:example/store/books_repo.dart';
import 'package:shindenshin/shindenshin.dart';

class Store extends BaseStore {
  late final BooksRepo booksRepo;
  late final AuthorsRepo authorsRepo;

  Store() : super(releaseBaseHost: 'books.example.com') {
    booksRepo = BooksRepo(this);
    authorsRepo = AuthorsRepo(this);
  }

  @override
  void initApiClient() {
    super.initApiClient();
    ApiClient().setConfig(ApiConfig(loginField: 'phone'));
  }
}