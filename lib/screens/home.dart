import 'package:digimobile/components/common_layouts.dart';
import 'package:digimobile/screens/infos.dart';
import 'package:digimobile/screens/mask.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final List<Widget> screens = [
    MaskPage(),
    InfosPage(),
  ];

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    _onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: ScreenLayouts.appBar(context),
        body: IndexedStack(
          index: _currentIndex,
          children: widget.screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.masks_outlined),
                label: 'Votre masque'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'Infos'
            ),
          ],
          elevation: 0,
        ),
      ),
    );
  }
}