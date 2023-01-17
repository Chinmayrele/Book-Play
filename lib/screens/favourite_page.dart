import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/book_provider.dart';
import '../widgets/book_list_design.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFe1f1ff),
      appBar: AppBar(
        title: const Text("Favourite Items"),
        backgroundColor: Colors.blue[300],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 30),
          Consumer<BookProvider>(builder: ((context, bookProvider, child) {
            return bookProvider.likedBookList.isEmpty
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumbs_up_down_rounded,
                            color: Colors.blue[200],
                            size: 60,
                          ),
                          SizedBox(
                            width: size.width * 0.85,
                            child: const Text(
                              "Liked a book, then keep a tab",
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
                              "To like a book, tap on thumb's up icon in book's details",
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
                          bookDetail: bookProvider.likedBookList[index],
                          size: size);
                    }),
                    shrinkWrap: true,
                    itemCount: bookProvider.likedBookList.length,
                  );
          }))
        ]),
      ),
    );
  }
}
