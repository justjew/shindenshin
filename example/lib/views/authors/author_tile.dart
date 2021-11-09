import 'package:example/cubit/app_navigator_cubit.dart';
import 'package:example/models/author.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorTile extends StatelessWidget {
  final Author author;

  const AuthorTile({ Key? key, required this.author, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => open(context),
      child: Container(
        height: 50,
        color: Colors.grey.shade200,
        child: Text(author.name),
      ),
    );
  }

  void open(BuildContext context) {
    context.read<AppNavigatorCubit>().singleAuthor(author);
  }
}