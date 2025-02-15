import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Budget List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 27, 118),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users') // Ensure this matches the path used in MainScreen
            .doc(userId)
            .collection('budgets') // Fetching budgets from the sub-collection 'budgets'
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No budgets available.'));
          }

          var budgets = snapshot.data!.docs;

          // Group budgets by month
          Map<String, List<QueryDocumentSnapshot>> groupedBudgets = {};
          for (var doc in budgets) {
            var timestamp = doc['date'] as Timestamp;
            var date = timestamp.toDate();
            var formattedMonth = DateFormat('MMMM yyyy').format(date);

            if (!groupedBudgets.containsKey(formattedMonth)) {
              groupedBudgets[formattedMonth] = [];
            }
            groupedBudgets[formattedMonth]!.add(doc);
          }

          return ListView.builder(
            itemCount: groupedBudgets.keys.length,
            itemBuilder: (context, index) {
              String month = groupedBudgets.keys.elementAt(index);
              List<QueryDocumentSnapshot> monthBudgets = groupedBudgets[month]!;

              // Calculate the total for the month
              double monthTotal = monthBudgets.fold(0, (sum, doc) => sum + doc['amount']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month heading
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      month,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 27, 118),
                      ),
                    ),
                  ),
                  // List of budgets for that month
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: monthBudgets.length,
                    itemBuilder: (context, budgetIndex) {
                      var budget = monthBudgets[budgetIndex];
                      var timestamp = budget['date'] as Timestamp;
                      var date = timestamp.toDate();
                      var formattedDate = DateFormat('d MMMM yyyy').format(date);

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              budget['category'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Budget Amount: R ${budget['amount'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.account_balance_wallet_outlined, // You can change this to a trash icon if needed
                              color: Color.fromARGB(255, 4, 27, 118),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                  // Total for the month
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total for the month:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R ${monthTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

