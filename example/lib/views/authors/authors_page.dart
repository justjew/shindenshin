import 'package:example/cubit/author_list_cubit.dart';
import 'package:example/store/authors_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorsPage extends Page {
  final AuthorsRepo _authorsRepo;

  const AuthorsPage(this._authorsRepo);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (_) {
        return BlocProvider<AuthorListCubit>(
          create: (_) => AuthorListCubit(_authorsRepo),
          child: Container(),
        );
      },
    );
  }
}
