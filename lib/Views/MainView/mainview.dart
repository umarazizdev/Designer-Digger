import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Views/CartView/cartview.dart';
import 'package:designerdigger/Views/HomeView/homeview.dart';
import 'package:designerdigger/Views/FavouriteView/favouriteview.dart';
import 'package:designerdigger/Views/profileview/profileview.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    CartView(),
    FavouriteView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: sc.height * 0.1048,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          unselectedItemColor: greyclr,
          selectedItemColor: onboardingclr,
          iconSize: sc.height * 0.05,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? darkbackgroundclr
              : whiteclr,
        ),
      ),
    );
  }
}
