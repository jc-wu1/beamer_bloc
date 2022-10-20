import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final List<Map<String, dynamic>> _books = [
    {
      'id': '1',
      'title': 'Stranger in a Strange Land',
      'author': 'Robert A. Heinlein',
    },
    {
      'id': '2',
      'title': 'Foundation',
      'author': 'Isaac Asimov',
    },
    {
      'id': '3',
      'title': 'Fahrenheit 451',
      'author': 'Ray Bradbury',
    },
  ];

  bool _firstTimeBooks = true;

  BooksBloc() : super(BooksInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<LoadBook>(_onLoadBook);
  }

  FutureOr<void> _onLoadBooks(
    LoadBooks event,
    Emitter<BooksState> emit,
  ) async {
    if (_firstTimeBooks) {
      emit(BooksLoading());
      await Future.delayed(const Duration(milliseconds: 200));
      _firstTimeBooks = false;
    }
    final books = _books.map((book) => Book.fromJson(book)).toList();
    emit(BooksLoaded(books));
  }

  FutureOr<void> _onLoadBook(
    LoadBook event,
    Emitter<BooksState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final book =
          _books.firstWhere((book) => book['id'] == event.bookId.toString());

      emit(BookLoaded(Book.fromJson(book)));
    } catch (e) {
      emit(BookNotFound());
    }
  }
}
