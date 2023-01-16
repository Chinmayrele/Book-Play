import 'package:book_play/models/book.dart';
import 'package:book_play/screens/book_detail.dart';
import 'package:flutter/material.dart';

class SearchListDesign extends StatelessWidget {
  const SearchListDesign({super.key, required this.searchBook});
  final Book searchBook;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookDetailPage(bookDetail: searchBook)));
      },
      leading: const Icon(
        Icons.menu_book_rounded,
        color: Colors.blue,
        size: 34,
      ),
      title: Text(
        searchBook.title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
