import 'package:flutter/material.dart';
import 'package:hackware/pages/about_us_page.dart';
import 'package:hackware/pages/main_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  double? _deviceHeight, _deviceWidth;

  final List<Widget> _pages = [MainPage(), AboutUs()];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _AppBar(),
      bottomNavigationBar: _BottomNavigationBar(),
      body: _pages[_currentPage],
    );
  }

  PreferredSizeWidget _AppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          child: AppBar(
            title: const Text(
              "Eco Soil",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
    );
  }

  Widget _BottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 7, right: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 10,
            iconSize: 28,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedItemColor: Colors.green.shade700,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentPage,
            onTap: (_index) {
              setState(() {
                _currentPage = _index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Icon(Icons.eco),
                  )),
              BottomNavigationBarItem(
                label: 'About',
                icon: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Icon(
                    Icons.info,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
