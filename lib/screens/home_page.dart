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
  late BookProvider bookProvider;
  List<Book> bookVolumeList = [];
  bool isLoading = true;
  late ScrollController scrollController;
  @override
  void initState() {
    bookProvider = Provider.of<BookProvider>(context, listen: false);
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )
          : SizedBox(
              width: size.width * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Consumer<BookProvider>(
                      builder: ((context, value, child) {
                        return SizedBox(
                          height: size.height * 0.96,
                          child: ListView.builder(
                            controller: scrollController,
                            itemBuilder: (ctx, i) {
                              if (i < value.bookVolumeListData.length) {
                                debugPrint(
                                    "LENGTH IN HOME PAGE: ${value.bookVolumeListData.length}");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 80,
                                    child: Text(
                                      value.bookVolumeListData[i].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Center(
                                    child: bookProvider.hasNextPage
                                        ? const CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : const Text("No More Data to Load!"),
                                  ),
                                );
                              }
                            },
                            // shrinkWrap: true,
                            itemCount: bookVolumeList.length,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
