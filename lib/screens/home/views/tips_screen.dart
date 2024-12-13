import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
        title: const Text(
          "Financial Tips",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 27, 118),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/budget.png",
                  headingText: "Create a Budget", 
                  text: "Creating a budget is essential for managing finances effectively. It helps track spending, prevent overspending, and identify areas for cost reduction. By documenting income, expenses, and savings goals, you can optimize your financial strategy. Various digital tools are available to simplify the budgeting process and promote long-term financial stability."
                ),
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/trade.png", 
                  headingText: "Track Your Expenses",
                  text: "Adhere to your budget by meticulously tracking expenses. Identify necessary costs (groceries, rent) versus discretionary spending (streaming services, dining out). Prioritize covering essential expenses before indulging in non-essential ones. Regular expense tracking enhances financial control, revealing spending patterns and motivating cost-cutting measures."
                ),
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/financial-profit.png", 
                  headingText: "The Importance of Saving",
                  text: "Start building a secure financial future by consistently saving, even small amounts weekly. Develop healthy financial habits by prioritizing savings over immediate gratification. Aim to save three to six months' worth of expenses for emergencies. This practice will serve you well after graduation, regardless of immediate goals."
                ),
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/job.png", 
                  headingText: "Get a Side Job",
                  text: "Consider part-time employment while pursuing a full-time college education. This provides steady income for expenses and savings. Gain valuable work experience, developing skills like communication and time management. Ensure you can balance work and studies effectively. Apply learned skills to future careers when possible."
                ),
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/coupon.png", 
                  headingText: "Take Advantage of Student Discounts",
                  text: "Leverage student discounts to significantly reduce expenses across various categories. Major companies offer discounts on digital services, insurance, and local businesses may provide similar benefits. Utilize these savings for entertainment at museums, theme parks, and other attractions. By maximizing student discounts, you can enjoy activities within budget, potentially accelerating your savings growth."
                ),
                const SizedBox(height: 20),
                buildCard(
                  imagePath: "lib/images/work-in-progress.png", 
                  headingText: "Little Things Add Up",
                  text: "As you create and track your budget, small daily purchases can surprisingly accumulate. Consider the cumulative cost of frequent actions like buying coffee daily. These seemingly insignificant expenses often consume more of your budget than realized. Recognizing their impact motivates cutting back or eliminating unnecessary purchases entirely."
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({required String imagePath, required String text, required String headingText}) {
    return Container(
      width: 500,
      height: 350,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Image.asset(
            imagePath,
            width: 100,
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            headingText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
