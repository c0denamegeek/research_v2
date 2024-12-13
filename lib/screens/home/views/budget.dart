import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_v2/screens/home/views/home_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime date = DateTime.now();
  String? selectedItem;
  final TextEditingController amountController = TextEditingController();
  final List<String> _item = [
    "Food",
    "Transport",
    "Entertainment",
    "Shopping",
    "Utilities",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            background_container(context),
            Center(
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade100,
      ),
      height: 400,
      width: 340,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          name(), // Category dropdown
          const SizedBox(height: 30),
          amount(), // Amount input field
          const SizedBox(height: 30),
          date_time(), // Date picker
          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {
                // Save only selected name, amount, and date
                saveBudget(
                  selectedItem!,
                  double.parse(amountController.text),
                  date,
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                "SAVE",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 4, 27, 118),
                ),
                minimumSize: MaterialStateProperty.all<Size>(const Size(125, 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container date_time() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2023),
            lastDate: DateTime(2100),
          );
          if (newDate == null) return;
          setState(() {
            date = newDate;
          });
        },
        child: Text(
          'Date: ${date.day}/${date.month}/${date.year}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 300, // Set the width the same as the DropdownButton container
        child: TextField(
          keyboardType: TextInputType.number,
          controller: amountController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            labelText: "Amount",
            labelStyle: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
            ),
          ),
        ),
      ),
    );
  }

  Padding name() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300, // Ensure the width is the same
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: DropdownButton<String>(
          value: selectedItem,
          onChanged: (value) {
            setState(() {
              selectedItem = value!;
            });
          },
          items: _item
              .map((e) => DropdownMenuItem(
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.burger, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          e,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    value: e,
                  ))
              .toList(),
          hint: const Text(
            "Select Category",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
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
                  "Add Budget Items",
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
            const SizedBox(height: 20), // Added space between the row and the text
            const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.0),
              child:  Text(
                "Please add the total amount that you would like to budget per category.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );
}

void saveBudget(String category, double amount, DateTime date) async {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Use the uid to store budgets under the specific user
    final uid = user.uid;

    await FirebaseFirestore.instance
        .collection('users')           // Navigate to 'users' collection
        .doc(uid)                      // Create a document for the user
        .collection('budgets')         // Inside that, a sub-collection for budgets
        .add({
      'category': category,
      'amount': amount,
      'date': date,
    });
  } else {
    print("User is not logged in");
  }
}


