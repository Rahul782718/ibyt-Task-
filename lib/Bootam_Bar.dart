import 'package:flutter/material.dart';
import 'package:ibyteinfomatics_test/View_Pages/Product.dart';
import 'package:ibyteinfomatics_test/View_Pages/Dashboard.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Dashboard_Screen(),
    Product_Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
            }
            return TextStyle(color: Colors.grey.shade400);
          }),
          backgroundColor: const Color(0xFF1C1927),
          indicatorColor: const Color(0xFF3A334E),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.black,
          elevation: 0,
          indicatorColor: Colors.grey.shade500,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard, color: Colors.white,),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.card_membership_rounded, color: Colors.white,),
              label: 'Product',
            ),
          ],
        ),
      ),
    );
  }
}
