import 'package:example/cubit/author_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'author_tile.dart';

class Authors extends StatelessWidget {
  const Authors({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthorListCubit, AuthorListState>(
        builder: (context, state) {
          if (state is AuthorListLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is AuthorListFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          state as AuthorListFetched;
          return ListView.builder(
            itemCount: state.authors.length,
            itemBuilder: (_, i) => AuthorTile(
              author: state.authors[i],
            ),
          );
        },
      ),
    );
  }
}