part of 'author_list_cubit.dart';

@immutable
abstract class AuthorListState {
  const AuthorListState();
}

class AuthorListLoading extends AuthorListState {
  const AuthorListLoading();
}

class AuthorListFetched extends AuthorListState {
  final List<Author> authors;

  const AuthorListFetched(this.authors);
}

class AuthorListFailure extends AuthorListState {
  final String message;

  const AuthorListFailure(this.message);
}
