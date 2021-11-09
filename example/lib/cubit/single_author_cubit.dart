import 'package:bloc/bloc.dart';

import 'package:example/models/author.dart';
import 'package:example/models/book.dart';
import 'package:example/store/books_repo.dart';

part 'single_author_state.dart';

class SingleAuthorCubit extends Cubit<SingleAuthorState> {
  final Author author;
  final BooksRepo _booksRepo;

  SingleAuthorCubit(this._booksRepo, this.author) : super(SingleAuthorLoading());

  Future<void> fetchBooks() async {
    try {
      emit(SingleAuthorLoading());
      final List<Book> books = await _booksRepo.getAuthorBooks(author);
      emit(SingleAuthorFetched(books));
    } catch(_) {
      emit(SingleAuthorFailure());
    }
  }
}
