part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class LoadBooks extends BooksEvent {}

class LoadBook extends BooksEvent {
  const LoadBook(this.bookId);

  final int bookId;
}
