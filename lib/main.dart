import 'package:book_play/provider/book_provider.dart';
import 'package:book_play/provider/category_provider.dart';
import 'package:book_play/provider/search_provider.dart';
import 'package:book_play/screens/index_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: ((context) => SearchProvider())),
        ChangeNotifierProvider(create: ((context) => CategoryProvider()))
      ],
      child: MaterialApp(
        title: 'Book Play',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: const Color(0xFFe1f1ff),
          primarySwatch: Colors.blue,
        ),
        home: const IndexPage(),
      ),
    );
  }
}
