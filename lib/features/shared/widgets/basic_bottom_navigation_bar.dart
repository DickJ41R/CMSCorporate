import 'package:flutter/material.dart';

class BasicBottomNavigationBar extends StatefulWidget {
  const BasicBottomNavigationBar({super.key});

  @override
  State<BasicBottomNavigationBar> createState() => _BasicBottomNavigationBarState();
}

class _BasicBottomNavigationBarState extends State<BasicBottomNavigationBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Icon(
      Icons.home,
      size: 150,
    ),
    Icon(
      Icons.save,
      size: 150,
    ),
    Icon(
      Icons.exit_to_app,
      size: 150,
    ),
    // Icon(
    //   Icons.chat,
    //   size: 150,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Demo'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Save Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Exit Without Saving',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}