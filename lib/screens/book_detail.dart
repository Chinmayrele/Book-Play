import 'dart:math';

import 'package:book_play/provider/book_provider.dart';
import 'package:book_play/widgets/book_list_design.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/book.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.bookDetail});
  final Book bookDetail;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool moreText = false;
  bool bookMarked = false;
  late BookProvider bookProvider;

  bool likedBook = false;

  int generateRandomNum() {
    int randomNum = Random().nextInt(500) + 100;
    return randomNum;
  }

  final List<String> items = [
    'Share',
  ];
  String? selectedValue;

  @override
  void initState() {
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFe1f1ff),
      appBar: AppBar(
          backgroundColor: Colors.blue[300],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  snackBar(!likedBook
                      ? "You have liked the book"
                      : "Removed from like book list");
                  setState(() {
                    likedBook = !likedBook;
                    likedBook
                        ? bookProvider.likedBookListFunction(widget.bookDetail)
                        : bookProvider
                            .removeFromBookmarkedList(widget.bookDetail);
                  });
                },
                icon: Icon(
                  (likedBook ||
                          bookProvider.likedBookList
                              .contains(widget.bookDetail))
                      ? Icons.thumb_up
                      : Icons.thumb_up_alt_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  snackBar(!bookMarked
                      ? "This Book is BookMarked"
                      : "Book is removed from BookMark");
                  setState(() {
                    bookMarked = !bookMarked;
                    bookMarked
                        ? bookProvider.addToBookmarkedList(widget.bookDetail)
                        : bookProvider
                            .removeFromBookmarkedList(widget.bookDetail);
                  });
                },
                icon: Icon(
                  (bookMarked ||
                          bookProvider.bookmarkedListData
                              .contains(widget.bookDetail))
                      ? Icons.bookmark
                      : Icons.bookmark_border_rounded,
                  color: Colors.black,
                )),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.more_vert_rounded,
                  // size: 46,
                  color: Colors.black,
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  Share.share("This is an Amazing Book!");
                },
                buttonHeight: 40,
                buttonWidth: 140,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 16, right: 16),
                dropdownWidth: 160,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  // color: Colors.redAccent,
                ),
                dropdownElevation: 8,
                offset: const Offset(0, 8),
              ),
            ),
            const SizedBox(width: 15),
          ]),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    height: size.height * 0.25,
                    width: size.width * 0.38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.bookDetail.imageLinks['smallThumbnail'] ??
                                  "data:image/jpeg;base64,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",
                            ),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: 50,
                        width: 150,
                        child: Text(
                          widget.bookDetail.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black),
                          maxLines: 4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.bookDetail.authors.isNotEmpty
                              ? widget.bookDetail.authors[0]
                              : "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: size.height * 0.097,
                        width: 150,
                        child: Text(
                          widget.bookDetail.subtitle.isEmpty
                              ? "No Sub-Titles are present for this book"
                              : widget.bookDetail.subtitle,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 13),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.bookDetail.avgRating.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const Icon(Icons.star, color: Colors.amber, size: 32)
                        ],
                      ),
                      Text(
                        "${generateRandomNum()} ratings",
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  // const SizedBox(width: 20),
                  Container(
                    height: 35,
                    width: 1.5,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  // const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.book_outlined,
                        color: Colors.black87,
                        size: 28,
                      ),
                      Text(
                        "Ebook",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  // const SizedBox(width: 20),
                  Container(
                    height: 35,
                    width: 1.5,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  // const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.bookDetail.pageCount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const Text(
                        "Pages",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.42,
                    child: OutlinedButton(
                        onPressed: () {
                          widget.bookDetail.previewLink.isEmpty
                              ? snackBar("No Preview Available right now!")
                              : _launchUrl(widget.bookDetail.previewLink);
                        },
                        style: OutlinedButton.styleFrom(
                            // side: const BorderSide(color: Colors.blue, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "Free Sample",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: size.width * 0.42,
                    child: ElevatedButton(
                        onPressed: () {
                          widget.bookDetail.infoLink.isEmpty
                              ? snackBar("Please try again later")
                              : _launchUrl(widget.bookDetail.infoLink);
                        },
                        style: ElevatedButton.styleFrom(),
                        child: const Text(
                          "More Info",
                          style: TextStyle(),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                  color: Colors.grey,
                  endIndent: 30,
                  indent: 30,
                  thickness: 1.2),
              const SizedBox(height: 20),
              const Text(
                "About this ebook",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: (moreText || widget.bookDetail.description.isEmpty)
                    ? null
                    : size.height * 0.12,
                width: size.width * 0.85,
                child: Text(
                  widget.bookDetail.description.isEmpty
                      ? "No description is available for this book."
                      : widget.bookDetail.description,
                  style: const TextStyle(color: Colors.grey),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                  onPressed: widget.bookDetail.description.isEmpty
                      ? null
                      : () {
                          setState(() {
                            moreText = !moreText;
                          });
                        },
                  child: Text(
                    moreText ? "See Less" : "See More",
                    style: TextStyle(
                        color: widget.bookDetail.description.isEmpty
                            ? Colors.grey
                            : Colors.blue,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 25),
              const Text(
                "Similiar e-Books",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return BookListDesign(
                      bookDetail: bookProvider.bookVolumeShuffleListData[index],
                      size: size,
                    );
                  }),
                  itemCount: bookProvider.bookVolumeShuffleListData.length,
                  shrinkWrap: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch. Try again later.';
    }
  }

  snackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
