import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:research_v2/screens/auth/signOutUser.dart';
import 'package:research_v2/screens/home/views/transactions.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors
                            .transparent, // Optional if you want a transparent background
                      ),
                      child: Image.asset(
                        'lib/images/Financial2.png', // Replace with the actual image path
                        fit: BoxFit
                            .cover, // Adjusts how the image fits in the container
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'cashAdvisor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    authService.signOutUser(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TransactionList(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: Text('Please log in to see transactions.'));
        }

        final user = userSnapshot.data;

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('transactions')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Show loading while waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var transactions = snapshot.data!.docs;

            // Calculate total income and expenses
            double totalIncome = 0;
            double totalExpenses = 0;

            transactions.forEach((doc) {
              double amount = doc['amount'];
              if (doc['type'] == 'Income') {
                totalIncome += amount;
              } else if (doc['type'] == 'Expense') {
                totalExpenses += amount;
              }
            });

            return Column(
              children: [
                // Always display TotalBalanceWidget with initial values
                TotalBalanceWidget(
                  totalIncome: totalIncome,
                  totalExpenses: totalExpenses,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const TransactionListScreen(), // Add navigation to the detailed screen
                        ));
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Display the list of transactions or a message if none exist
                if (transactions.isEmpty) 
                  const Center(child: Text('No transactions available.'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: transactions.length > 4 ? 4 : transactions.length, // Display max 4 transactions
                    itemBuilder: (context, index) {
                      var transaction = transactions[index];
                      var timestamp = transaction['date'] as Timestamp;
                      var date = timestamp.toDate();
                      var formattedDate = DateFormat('yyyy-MM-dd').format(date);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            transaction['category'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            transaction['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                'R ${transaction['amount'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: transaction['type'] == 'Income'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}



class TotalBalanceWidget extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;

  const TotalBalanceWidget({
    Key? key,
    required this.totalIncome,
    required this.totalExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalBalance = totalIncome - totalExpenses;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 2, 4, 73),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "R ${totalBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          CupertinoIcons.arrow_up,
                          size: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Income",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "R ${totalIncome.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.arrow_down,
                          size: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Expenses",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "R ${totalExpenses.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


