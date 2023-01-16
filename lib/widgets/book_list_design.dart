import 'package:book_play/screens/book_detail.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class BookListDesign extends StatelessWidget {
  const BookListDesign(
      {super.key, required this.bookDetail, required this.size});
  final Book bookDetail;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => BookDetailPage(
                  bookDetail: bookDetail,
                )));
      }),
      child: Column(
        children: [
          Container(
            height: size.height * 0.24,
            width: size.width * 0.38,
            margin: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: bookDetail.imageLinks == {}
                ? Image.asset(
                    "assets/missingbook.jpg",
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    bookDetail.imageLinks['smallThumbnail'] ??
                        "http://books.google.com/books/content?id=SQ0AAAAAMBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                    fit: BoxFit.cover,
                  ),
          ),
          Container(
            height: 30,
            width: size.width * 0.38,
            margin:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
            child: Text(
              bookDetail.title.isEmpty ? "TextBook" : bookDetail.title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
