import 'dart:convert';

import 'package:book_play/models/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CategoryProvider with ChangeNotifier {
  static const String apiKey = "AIzaSyCUGKh9BEdskSpB0cDIkmOtLNZZmx7liXo";

  Future<List<Book>> categoryBookListData(String category) async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$category&key=$apiKey";
    final url = Uri.parse(apiUrl);
    final res = await http.get(url);
    final result = json.decode(res.body);
    final List<Book> bookData = [];
    debugPrint("DATA:: $result");

    if (result != null) {
      try {
        for (int i = 0; i < (result['items'] as List).length; i++) {
          var book = result['items'][i];
          bookData.add(Book(
              id: book['id'] ?? "",
              title: book['volumeInfo']['title'] ?? "",
              subtitle: book['volumeInfo']['subtitle'] ?? "",
              authors: book['volumeInfo']['authors'] ?? [],
              description: book['volumeInfo']['description'] ?? "",
              previewLink: book['volumeInfo']['infoLink'] ?? "",
              infoLink: book['volumeInfo'][''] ?? "canonicalVolumeLink",
              imageLinks: book['volumeInfo']['imageLinks'] ?? {},
              accessInfo: book['accessInfo'] ?? {},
              avgRating: book['volumeInfo']['averageRating'] != null
                  ? (book['volumeInfo']['averageRating']).toDouble()
                  : 0.0,
              pageCount: book['volumeInfo']['pageCount'] ?? 0));
        }
      } catch (err) {
        debugPrint("ERROR IN FETCH DATA: $err");
      }
    } else {
      debugPrint("ERROR IN THE API MAYBE OCCURING");
    }
    return bookData;
  }
}
