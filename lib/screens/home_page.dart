import 'dart:async';

import 'package:book_play/provider/category_provider.dart';
import 'package:book_play/provider/search_provider.dart';
import 'package:book_play/screens/category_page.dart';
import 'package:book_play/widgets/book_list_design.dart';
import 'package:book_play/widgets/search_list_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../provider/book_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // PROVIDERS DECLARATION
  late BookProvider bookProvider;
  late SearchProvider searchProvider;
  late CategoryProvider categoryProvider;
  List<Book> bookVolumeList = [];
  List<Book> searchBooksList = [];
  bool isLoading = true;
  Timer? debouncer;
  TextEditingController searchController = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState() {
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    bookProvider.firstFetchBookVolumeData().then((value) {
      bookVolumeList = (bookProvider.bookVolumeListData);
      setState(() {
        isLoading = false;
      });
    });
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          bookProvider.fetchMoreBookVolumeData();
        }
      });
    super.initState();
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFe1f1ff),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 15, bottom: 15, top: 20),
              width: size.width * 0.95,
              child: ListView(
                controller: scrollController,
                children: [
                  // API-SEARCH TEXT FIELD
                  TextFormField(
                      controller: searchController,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                      cursorHeight: 22,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: 'Search Play Books',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontSize: 15, wordSpacing: 2),
                        fillColor: Colors.grey[150],
                        filled: true,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.clear();
                              searchBooksList.clear();
                            });
                          },
                          child: const Icon(Icons.clear_rounded,
                              color: Colors.grey),
                        ),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please Enter Book Name';
                        }
                        return null;
                      },
                      onChanged: searchBooks),
                  searchBooksList.isNotEmpty
                      ? SizedBox(
                          height: size.height * 0.88,
                          child: ListView.builder(
                            itemBuilder: ((context, index) {
                              return SearchListDesign(
                                searchBook: searchBooksList[index],
                              );
                            }),
                            itemCount: searchBooksList.length,
                          ))
                      : Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Center(
                              child: textString("Let's find your next read",
                                  Colors.black, 20),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: SizedBox(
                                width: size.width * 0.8,
                                child: const Text(
                                  "From romance to superheros to Thai cuisine, we have tons of books for all your interests",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            dividerFunction(),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: textString(
                                    "Explore Play Books", Colors.black, 20)),
                            // -------------------------
                            // CATEGORY BOOK LIST VIEW
                            SizedBox(
                              height: 70,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  categoryOptions("Sci-fi", () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const CategoryPage(
                                                  category: "Sci-Fi",
                                                ))));
                                  }),
                                  categoryOptions("Fantasy", () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const CategoryPage(
                                                  category: "Fantasy",
                                                ))));
                                  }),
                                  categoryOptions("Computer", () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const CategoryPage(
                                                  category: "Computer",
                                                ))));
                                  }),
                                  categoryOptions("Romance", () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const CategoryPage(
                                                  category: "Romance",
                                                ))));
                                  }),
                                  categoryOptions("Anime", () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const CategoryPage(
                                                  category: "Anime",
                                                ))));
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            dividerFunction(),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: textString(
                                    "Check out the Books", Colors.black, 20)),
                            // ------------------------------
                            // API FETCHED BOOK LIST WITH PAGINATION
                            Consumer<BookProvider>(
                                builder: ((context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Expanded(
                                    child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.66,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemBuilder: ((context, i) {
                                    if (i <
                                        value.bookVolumeListData.length - 1) {
                                      return BookListDesign(
                                        size: size,
                                        bookDetail: value.bookVolumeListData[i],
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 45),
                                        child: Center(
                                          child: bookProvider.hasNextPage
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : const Text(
                                                  "No More Data to Load!"),
                                        ),
                                      );
                                    }
                                  }),
                                  shrinkWrap: true,
                                  itemCount: value.bookVolumeListData.length,
                                )),
                              );
                            }))
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  Widget categoryOptions(String text, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(
            Icons.menu_book_sharp,
            size: 32,
            color: Colors.indigo,
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> searchBooks(String query) async => debounce(() async {
        if (query.isEmpty) {
          searchBooksList.clear();
        } else {
          final books = await searchProvider.searchBook(query);
          setState(() {
            searchBooksList = books;
          });
        }
      });

  Divider dividerFunction() {
    return const Divider(
        color: Colors.grey, endIndent: 10, indent: 10, thickness: 1.5);
  }

  Text textString(String text, Color color, int fontsize) {
    return Text(text,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20));
  }
}
