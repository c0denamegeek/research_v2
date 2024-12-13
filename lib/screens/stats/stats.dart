import 'package:flutter/material.dart';
import 'package:research_v2/screens/stats/transaction_bar_chart.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBarGraph(),
    );
  }
}
