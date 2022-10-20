import 'package:beamer/beamer.dart';
import 'package:beamer_bloc/presentation/error.dart';
import 'package:beamer_bloc/presentation/home.dart';
import 'package:beamer_bloc/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/books_bloc.dart';
import 'presentation/logged_in_page.dart';

class LoggedInLocations extends BeamLocation<BeamState> {
  late BooksBloc _booksBloc;

  @override
  void initState() {
    super.initState();
    _booksBloc = BooksBloc();
  }

  @override
  void disposeState() {
    _booksBloc.close();
    super.disposeState();
  }

  @override
  List<String> get pathPatterns => [
        // '/logged_in_page/',
        // '/logged_in_page/books',
        '/logged_in_page/books/:bookId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('logged_in_page'))
        const BeamPage(
          key: ValueKey('show_selection'),
          title: 'Logged In',
          child: LoggedInPage(),
        ),
      if (state.uri.pathSegments.contains('books'))
        const BeamPage(
          key: ValueKey('books'),
          title: 'Books',
          child: BooksScreen(),
        ),
      if (state.pathParameters.containsKey('bookId'))
        BeamPage(
          key: ValueKey('book-${state.pathParameters['bookId']}'),
          title: 'Book Details',
          child: const BookDetailsScreen(),
        ),
    ];
  }

  @override
  void onUpdate() {
    if (state.pathPatternSegments.isEmpty) return;

    final bookId = state.pathParameters.containsKey('bookId')
        ? int.parse(state.pathParameters['bookId']!)
        : null;

    bookId == null
        ? _booksBloc.add(LoadBooks())
        : _booksBloc.add(LoadBook(bookId));
  }

  @override
  Widget builder(BuildContext context, Widget navigator) {
    return BlocProvider.value(
      value: _booksBloc,
      child: navigator,
    );
  }
}

class UnauthenticatedLocations extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        '/login',
        '/forbidden',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('login'))
        const BeamPage(
          key: ValueKey('login'),
          title: 'Login',
          child: LoginPage(),
        ),
      if (state.uri.pathSegments.contains('forbidden'))
        const BeamPage(
          key: ValueKey('forbidden'),
          title: 'Forbidden',
          child: ErrorPage(),
        ),
    ];
  }
}
