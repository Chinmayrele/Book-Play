import 'package:book_play/screens/wishlist_page.dart';
import 'package:book_play/screens/favourite_page.dart';
import 'package:book_play/screens/home_page.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int pageIndex = 0;
  final screens = [
    const HomePage(),
    const WishlistPage(),
    const FavouritePage(),
  ];
  @override
  Widget build(BuildContext context) {
    // -------------------------------
    // BOTTOM NAVIGATION PAGE
    return Scaffold(
      body: IndexedStack(index: pageIndex, children: screens),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Colors.blue[100],
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold))),
        child: NavigationBar(
          height: 50,
          selectedIndex: pageIndex,
          onDestinationSelected: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 30,
                color: pageIndex == 0 ? Colors.redAccent : Colors.grey,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite,
                size: 30,
                color: pageIndex == 1 ? Colors.amber : Colors.grey,
              ),
              label: 'Wishlist',
            ),
            // NavigationDestination(
            //   icon: Icon(
            //     Icons.message,
            //     size: 30,
            //     color: pageIndex == 2 ? Colors.indigo : Colors.grey,
            //   ),
            //   label: 'Message',
            // ),
            NavigationDestination(
              icon: Icon(
                Icons.thumb_up_alt,
                size: 30,
                color: pageIndex == 2 ? Colors.indigo : Colors.grey,
              ),
              label: 'Favourite',
            ),
          ],
        ),
      ),
    );
  }
}
