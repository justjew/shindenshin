import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example/models/author.dart';
import 'package:example/store/authors_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:shindenshin/shindenshin.dart';

part 'author_list_state.dart';

class AuthorListCubit extends Cubit<AuthorListState> {
  final AuthorsRepo _authorsRepo;
  late final StreamSubscription _subscription;

  AuthorListCubit(this._authorsRepo) : super(const AuthorListLoading()) {
    _subscription = _authorsRepo.subscribe(_handleEvent);
  }

  Future<void> fetch([int? page]) async {
    try {
      emit(const AuthorListLoading());
      await _authorsRepo.next(page);
      emit(AuthorListFetched(_authorsRepo.authors));
    } on DioError catch(_) {
      emit(const AuthorListFailure('Unable to load author list'));
    } catch(error) {
      emit(AuthorListFailure(error.toString()));
    }
  }

  void _handleEvent(StoreEvent event) {
    if (event is AuthorListUpdated) {
      emit(AuthorListFetched(_authorsRepo.authors));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
