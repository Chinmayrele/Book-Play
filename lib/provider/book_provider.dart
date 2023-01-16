import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _bookVolumeListDatas = [];
  final List<Book> _bookmarkedListDatas = [];
  final List<Book> _likedBookList = [];
  bool hasNextPage = true;
  bool isLoading = false;

  List<Book> get bookVolumeListData {
    return [..._bookVolumeListDatas];
  }

  List<Book> get bookVolumeShuffleListData {
    return [..._bookVolumeListDatas..shuffle()];
  }

  List<Book> get bookmarkedListData {
    return [..._bookmarkedListDatas];
  }

  List<Book> get likedBookList {
    return [..._likedBookList];
  }

  static const String apiKey = "AIzaSyCUGKh9BEdskSpB0cDIkmOtLNZZmx7liXo";
  int page = 1;

  Future<void> firstFetchBookVolumeData() async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$page&key=$apiKey";
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
        _bookVolumeListDatas.addAll(bookData);
        notifyListeners();
      } catch (err) {
        debugPrint("ERROR IN FETCH DATA: $err");
      }
    } else {
      debugPrint("ERROR IN THE API MAYBE OCCURING");
    }
  }

  Future<void> fetchMoreBookVolumeData() async {
    page += 1;
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$page&key=$apiKey";
    final url = Uri.parse(apiUrl);
    final res = await http.get(url);
    final result = json.decode(res.body);
    final List<Book> bookData = [];
    debugPrint("DATA OF THE SECOND LOADING:: $result");

    if (result != null) {
      try {
        isLoading = true;
        for (int i = 0; i < (result['items'] as List).length; i++) {
          var book = result['items'][i];
          bookData.add(Book(
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
              pageCount: book['volumeInfo']['pageCount'] ?? 100));
        }
        _bookVolumeListDatas.addAll(bookData);
        isLoading = false;
        debugPrint(
            "LENGTH IN MORE LOAD PROVIDER: ${_bookVolumeListDatas.length}");
        notifyListeners();
      } catch (err) {
        hasNextPage = false;
        debugPrint("ERROR IN FETCH MORE DATA: $err");
      }
    } else {
      hasNextPage = false;
      debugPrint("ERROR IN THE API MORE DATA OCCURING");
    }
  }

  void addToBookmarkedList(Book book) {
    _bookmarkedListDatas.add(book);
    notifyListeners();
  }

  void removeFromBookmarkedList(Book book) {
    _bookmarkedListDatas.remove(book);
    notifyListeners();
  }

  void likedBookListFunction(Book book) {
    _likedBookList.add(book);
    notifyListeners();
  }

  void notLikedBookListFunction(Book book) {
    _likedBookList.remove(book);
    notifyListeners();
  }
}
