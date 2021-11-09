import 'package:bloc/bloc.dart';
import 'package:example/models/author.dart';

import 'package:example/store/store.dart';
import 'package:example/views/authors/authors_page.dart';
import 'package:flutter/material.dart';

part 'app_navigator_state.dart';

class AppNavigatorCubit extends Cubit<AppNavigatorState> {
  final Store _store;
  List<Page> pages = [];

  AppNavigatorCubit(this._store) : super(const AppNavigatorState([])) {
    authors();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pages.removeLast();
    return route.didPop(result);
  }

  void authors() {
    pages = [AuthorsPage(_store.authorsRepo)];
    _emit();
  }

  void singleAuthor(Author author) {

  }

  void _emit() {
    emit(AppNavigatorState(pages));
  }
}
