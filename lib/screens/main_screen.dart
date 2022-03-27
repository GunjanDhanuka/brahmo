import 'package:brahmo/screens/item_issue/item_selections.dart';
import 'package:brahmo/screens/user/home.dart';
import 'package:brahmo/screens/user/user_profile.dart';
import 'package:flutter/material.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [
    HomeScreen(),
    ItemSelectionsScreen(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/home_icon.png",width: screenWidth*0.06,),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/navigation_icon.png",width: screenWidth*0.06,),
            label: "Item Search"
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/profile_icon.png",width: screenWidth*0.06,),
            label: "Profile"
          ),
        ],
        onTap: (index){
          setState(() {
            selectedIndex=index;
          });
        },
      ),
    );
  }
}
