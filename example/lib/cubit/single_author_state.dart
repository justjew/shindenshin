part of 'single_author_cubit.dart';

abstract class SingleAuthorState {
  const SingleAuthorState();
}

class SingleAuthorLoading extends SingleAuthorState {}

class SingleAuthorFetched extends SingleAuthorState {
  final List<Book> books;

  SingleAuthorFetched(this.books);
}

class SingleAuthorFailure extends SingleAuthorState {}
