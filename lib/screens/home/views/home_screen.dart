import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research_v2/screens/auth/sign-in.dart'; // Ensure correct imports
import 'package:research_v2/screens/auth/sign-up.dart';
import 'package:research_v2/screens/home/views/add_screen.dart';
import 'package:research_v2/screens/home/views/budget.dart';
import 'package:research_v2/screens/home/views/budget_list.dart';
import 'package:research_v2/screens/home/views/main_screen.dart';
import 'package:research_v2/screens/home/views/select_add.dart';
import 'package:research_v2/screens/home/views/tips_screen.dart';
import 'package:research_v2/screens/stats/stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = const Color.fromARGB(255, 4, 27, 118);
  Color unselectedItem = const Color.fromARGB(255, 0, 0, 0);

  // List of pages corresponding to each BottomNavigationBar item
  final List<Widget> pages = [
    const MainScreen(),   
    const BudgetListScreen(),       
    const TipsScreen(), 
    const StatScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          elevation: 10,
          backgroundColor: const Color(0xffC5C5C5),
          selectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 4, 27, 118),
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.houseChimney,
                color: index == 0 ? selectedItem : unselectedItem,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: FaIcon(
                  FontAwesomeIcons.wallet,
                  color: index == 1 ? selectedItem : unselectedItem,
                ),
              ),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.book,
                color: index == 2 ? selectedItem : unselectedItem,
              ),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.chartBar,
                color: index == 3 ? selectedItem : unselectedItem,
              ),
              label: 'Analytics',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define your Floating Action Button action here
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectAdd()));
        },
        backgroundColor: const Color.fromARGB(255, 4, 27, 118),
        shape: const CircleBorder(),
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      
      // Set the body to the currently selected page from the list
      body: pages[index], 
    );
  }
}
