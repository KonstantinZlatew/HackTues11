import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hackware/pages/about_us_page.dart';
import 'package:hackware/pages/chat_page.dart';
import 'package:hackware/pages/main_page.dart';
import 'package:hackware/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;
  double? _deviceHeight, _deviceWidth;

  FirebaseService? _firebaseService;

  final List<Widget> _pages = [ChatPage(), MainPage(), AboutUs()];

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () async {
                    await _firebaseService!.logout();
                    Navigator.popAndPushNamed(context, 'login');
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.green,
                  ),
                ),
              )
            ],
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
            onTap: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  label: 'Chat',
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Icon(Icons.chat),
                  )),
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
