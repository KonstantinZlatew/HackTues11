import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text('EcoSoil', style: TextStyle(color: Colors.green.shade900)),
      ),
      bottomNavigationBar: _BottomNavigationBar(),
      body: SafeArea(child: Container()),
    );
  }

  Widget _BottomNavigationBar() {
    return BottomNavigationBar(
        backgroundColor: Colors.green.shade500,
        fixedColor: Colors.white,
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.eco)),
          BottomNavigationBarItem(
            label: 'About us',
            icon: Icon(
              Icons.info,
            ),
          ),
        ]);
  }
}
