import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Auth
import 'package:research_v2/screens/stats/firestore_service.dart';

class DoubleBarGraph extends StatefulWidget {
  @override
  _DoubleBarGraphState createState() => _DoubleBarGraphState();
}

class _DoubleBarGraphState extends State<DoubleBarGraph> {
  late Future<Map<String, List<double>>> _chartDataFuture;
  DateTime selectedMonth = DateTime.now(); // Default to current month
  String? userId; // Variable to hold the current user's ID

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Fetch the logged-in user's ID
    _chartDataFuture = _prepareChartData();
  }

  Future<Map<String, List<double>>> _prepareChartData() async {
    try {
      final transactions = await FirestoreService().getTransactionData(userId);
      final budgets = await FirestoreService().getBudgetData(userId);

      Map<String, List<double>> categoryData = {
        'Food': [0.0, 0.0],
        'Transport': [0.0, 0.0],
        'Entertainment': [0.0, 0.0],
        'Shopping': [0.0, 0.0],
        'Utilities': [0.0, 0.0],
      };

      // Process transactions data
      for (var transaction in transactions) {
        String category = transaction['category'] ?? 'Uncategorized';
        double amount = (transaction['amount'] ?? 0).toDouble();
        DateTime date = (transaction['date'] as Timestamp).toDate();

        // Filter by the selected month
        if (date.year == selectedMonth.year && date.month == selectedMonth.month) {
          if (categoryData.containsKey(category)) {
            categoryData[category]![0] += amount; // Accumulate the amount spent
          }
        }
      }

      // Process budget data
      for (var budget in budgets) {
        String category = budget['category'] ?? 'Uncategorized';
        double budgetedAmount = (budget['amount'] ?? 0).toDouble();
        DateTime date = (budget['date'] as Timestamp).toDate();

        // Filter by the selected month
        if (date.year == selectedMonth.year && date.month == selectedMonth.month) {
          if (categoryData.containsKey(category)) {
            categoryData[category]![1] = budgetedAmount; // Set the budget amount
          }
        }
      }

      return categoryData;
    } catch (e) {
      print('Error preparing chart data: $e');
      throw e;
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.blue,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedMonth) {
      setState(() {
        selectedMonth = picked;
        _chartDataFuture = _prepareChartData(); // Re-fetch data for the selected month
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 27, 118),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, List<double>>>( 
        future: _chartDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          var data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add a button to select a month
                  ElevatedButton(
                    onPressed: () => _selectMonth(context),
                    child: Text('Select Month: ${DateFormat.yMMM().format(selectedMonth)}'),
                  ),
                  const SizedBox(height: 20),

                  // Add a descriptive section
                  const Text(
                    "This screen presents an overview of your monthly transactions in comparison to the budget you've set. "
                    "Each bar in the graph below represents how much you've spent in different categories like Food, Transport, "
                    "Entertainment, Shopping, and Utilities. The orange bars show your budget for each category, while the blue "
                    "bars represent the actual transactions made.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Add a heading above the graph
                  const Text(
                    "Monthly Budget vs Transactions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Bar chart
                  SizedBox(
                    height: 400, // Limit height for better readability
                    child: BarChart(
                      BarChartData(
                        maxY: 7000, // Set the maximum value for y-axis
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const categories = [
                                  'Food',
                                  'Transport',
                                  'Entertainment',
                                  'Shopping',
                                  'Utilities'
                                ];
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    categories[value.toInt()],
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  space: 2,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1000, // Set interval of 1000
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: [
                          for (int i = 0; i < data.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: data.values.elementAt(i)[1], // Budgeted amount
                                  color: Colors.orange,
                                  width: 15,
                                ),
                                BarChartRodData(
                                  toY: data.values.elementAt(i)[0], // Actual spent
                                  color: Colors.blue,
                                  width: 15,
                                ),
                              ],
                              barsSpace: 10,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          const Text('Budget'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text('Transactions'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


