import 'package:book_play/models/book.dart';
import 'package:flutter/material.dart';

import '../screens/book_detail.dart';

class CategoryListDesign extends StatelessWidget {
  const CategoryListDesign({super.key, required this.bookDetail});
  final Book bookDetail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 20,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => BookDetailPage(
                  bookDetail: bookDetail,
                )));
      },
      leading: Container(
        height: 70,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage((bookDetail.imageLinks == {} ||
                        bookDetail.imageLinks['smallThumbnail'] == null)
                    ? "http://books.google.com/books/content?id=SQ0AAAAAMBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"
                    : bookDetail.imageLinks['smallThumbnail']),
                fit: BoxFit.cover)),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          bookDetail.title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          children: [
            Text(
              bookDetail.subtitle.isEmpty
                  ? "Try & check this book"
                  : bookDetail.subtitle,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              bookDetail.description,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
