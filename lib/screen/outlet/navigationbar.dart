import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key,required this.menu,required this.onClick}) : super(key: key);
  final int menu;
  final Function(int) onClick;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting'
        )
      ],
      currentIndex: menu,
      onTap: onClick,
      selectedItemColor: const Color.fromARGB(255, 47, 111, 78),
      unselectedItemColor: Colors.black,
      showUnselectedLabels: false,
      //type: BottomNavigationBarType.shifting,
    );
  }
}