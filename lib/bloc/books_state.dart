part of 'books_bloc.dart';

class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
  });

  final int id;
  final String title;
  final String author;

  Book.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        title = json['title'],
        author = json['author'];
}

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  const BooksLoaded(this.books);

  final List<Book> books;
}

class BookLoaded extends BooksState {
  const BookLoaded(this.book);

  final Book book;
}

class BookNotFound extends BooksState {}
