class Book {
  String id;
  String title;
  String subtitle;
  List<dynamic> authors;
  String description;
  String previewLink;
  String infoLink;
  Map<String, dynamic> imageLinks;
  Map<String, dynamic> accessInfo;
  double avgRating;
  int pageCount;

  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.description,
    required this.previewLink,
    required this.infoLink,
    required this.imageLinks,
    required this.accessInfo,
    required this.avgRating,
    required this.pageCount,
  });
}
