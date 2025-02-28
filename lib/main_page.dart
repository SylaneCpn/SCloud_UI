import 'package:flutter/material.dart';
import 'package:sylcpn_io/pages/files.dart';
import 'package:sylcpn_io/pages/home.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.file_present_rounded),
            icon:  Icon(Icons.file_present_outlined),
            label: 'Fichiers',
          ),
          
        ],
      ),
      body: <Widget>[
        /// Home page
        Home(),
        FilesPage(),
      ][currentPageIndex],
    );
  }
}
