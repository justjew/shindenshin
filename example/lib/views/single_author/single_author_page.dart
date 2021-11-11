import 'package:example/cubit/single_author_cubit.dart';
import 'package:example/models/author.dart';
import 'package:example/store/books_repo.dart';
import 'package:example/views/single_author/single_author.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleAuthorPage extends Page {
  final Author author;
  final BooksRepo booksRepo;

  const SingleAuthorPage(this.author, this.booksRepo);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (_) {
        return BlocProvider<SingleAuthorCubit>(
          create: (_) => SingleAuthorCubit(booksRepo, author),
          child: SingleAuthor(
            author: author,
          ),
        );
      },
    );
  }
}
