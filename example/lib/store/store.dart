import 'package:example/store/authors_repo.dart';
import 'package:example/store/books_repo.dart';
import 'package:shindenshin/shindenshin.dart';

class Store extends BaseStore {
  Store(BaseApiClient apiClient) : super(apiClient, [
    AuthorsRepo.new,
    BooksRepo.new,
  ]);
}