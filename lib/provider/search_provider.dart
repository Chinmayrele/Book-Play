import 'dart:convert';

import 'package:book_play/models/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  List<Book> searchBookList = [];

  static const String apiKey = "AIzaSyCUGKh9BEdskSpB0cDIkmOtLNZZmx7liXo";

  Future<List<Book>> searchBook(String query) async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey";
    final url = Uri.parse(apiUrl);
    final res = await http.get(url);
    final result = json.decode(res.body);
    try {
      for (int i = 0; i < (result['items'] as List).length; i++) {
        var book = result['items'][i];
        searchBookList.add(Book(
            id: book['id'] ?? "",
            title: book['volumeInfo']['title'] ?? "",
            subtitle: book['volumeInfo']['subtitle'] ?? "",
            authors: book['volumeInfo']['authors'] ?? [],
            description: book['volumeInfo']['description'] ?? "",
            previewLink: book['volumeInfo']['previewLink'] ?? "",
            infoLink: book['volumeInfo']['infoLink'] ?? "",
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
    return searchBookList;
  }
}
