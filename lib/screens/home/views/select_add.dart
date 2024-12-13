import 'package:flutter/material.dart';
import 'package:research_v2/screens/home/views/add_screen.dart';
import 'package:research_v2/screens/home/views/budget.dart';
import 'package:research_v2/screens/home/views/home_screen.dart';

class SelectAdd extends StatefulWidget {
  const SelectAdd({super.key});

  @override
  State<SelectAdd> createState() => _SelectAddState();
}

class _SelectAddState extends State<SelectAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            background_container(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BudgetScreen()));
                      },
                      child: Container(
                        width: 150,
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "lib/images/budget.png",
                              width: 100,
                            ),
                            const Text(
                              'Budget',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddScreen()));
                      },
                      child: Container(
                        width: 150,
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "lib/images/trade.png",
                              width: 100,
                            ),
                            const Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Column background_container(BuildContext context) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: 240,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 4, 27, 118),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Manage Your Finances",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.abc_outlined,
                  color: Color.fromARGB(255, 4, 27, 118),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Added space between the row and the text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Select an option to either set your budget or track your transactions",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
