import 'package:book_play/provider/book_provider.dart';
import 'package:book_play/widgets/book_list_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFe1f1ff),
      appBar: AppBar(
        title: const Text("Wishlisted Items"),
        backgroundColor: Colors.blue[300],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 30),
          Consumer<BookProvider>(builder: ((context, bookProvider, child) {
            // --------------------------------
            // GRID OF THE BOOKS WISHLISTED BY THE USERS
            return SizedBox(
              height: size.height * 0.88,
              child: bookProvider.bookmarkedListData.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_add,
                              color: Colors.blue[200],
                              size: 60,
                            ),
                            SizedBox(
                              width: size.width * 0.85,
                              child: const Text(
                                "Keep a list of books to read",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.85,
                              child: const Text(
                                "To add a book, tap on wishlist icon in book's details",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2),
                      itemBuilder: ((context, index) {
                        return BookListDesign(
                            bookDetail: bookProvider.bookmarkedListData[index],
                            size: size);
                      }),
                      itemCount: bookProvider.bookmarkedListData.length,
                    ),
            );
          }))
        ]),
      ),
    );
  }
}
