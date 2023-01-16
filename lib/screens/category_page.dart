import 'package:book_play/models/book.dart';
import 'package:book_play/provider/category_provider.dart';
import 'package:book_play/widgets/category_list_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.category,
  });
  final String category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late CategoryProvider categoryProvider;
  List<Book> categoryList = [];
  bool isLoading = true;
  @override
  void initState() {
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider
        .categoryBookListData(widget.category.toLowerCase())
        .then((cateList) {
      categoryList = cateList;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[300],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.height * 0.9,
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return CategoryListDesign(
                          bookDetail: categoryList[index],
                        );
                      }),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                    ),
                  )
                ],
              )));
  }
}
