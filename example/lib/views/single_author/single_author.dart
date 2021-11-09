import 'package:example/cubit/single_author_cubit.dart';
import 'package:example/models/author.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleAuthor extends StatelessWidget {
  final Author author;

  const SingleAuthor({
    Key? key,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            author.name,
          ),
          Expanded(
            child: BlocBuilder<SingleAuthorCubit, SingleAuthorState>(
              builder: (context, state) {
                if (state is SingleAuthorLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (state is SingleAuthorFailure) {
                  return const Center(
                    child: Text('Error'),
                  );
                }

                state as SingleAuthorFetched;
                return ListView.builder(
                  itemCount: state.books.length,
                  itemBuilder: (_, i) => Text(state.books[i].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
