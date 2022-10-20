import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/books_bloc.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BooksBloc>().state;

    return state is BooksLoaded
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Books'),
            ),
            body: ListView(
              children: state.books
                  .map(
                    (book) => ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () => context.beamToNamed(
                        '/logged_in_page/books/${book.id}',
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BooksBloc>().state;

    return state is BookLoaded
        ? Scaffold(
            appBar: AppBar(
              title: Text(state.book.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Author: ${state.book.author}'),
            ),
          )
        : Scaffold(
            body: Center(
              child: state is BookNotFound
                  ? const Text('Book not found')
                  : const CircularProgressIndicator(),
            ),
          );
  }
}
