import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch transactions for the given user ID
  Future<List<Map<String, dynamic>>> getTransactionData(String? userId) async {
    if (userId == null) return [];

    try {
      // Access transactions subcollection under the specific user's document
      QuerySnapshot snapshot = await _db
          .collection('users') // Go to 'users' collection
          .doc(userId)         // Get the document with userId
          .collection('transactions') // Access 'transactions' subcollection
          .get();

      return snapshot.docs.map((doc) {
        return {
          'amount': doc['amount'],
          'category': doc['category'],
          'date': doc['date'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching transaction data: $e');
      return [];
    }
  }

  // Fetch budgets for the given user ID
  Future<List<Map<String, dynamic>>> getBudgetData(String? userId) async {
    if (userId == null) return [];

    try {
      // Access budgets subcollection under the specific user's document
      QuerySnapshot snapshot = await _db
          .collection('users') // Go to 'users' collection
          .doc(userId)         // Get the document with userId
          .collection('budgets') // Access 'budgets' subcollection
          .get();

      return snapshot.docs.map((doc) {
        return {
          'amount': doc['amount'],
          'category': doc['category'],
          'date': doc['date'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching budget data: $e');
      return [];
    }
  }
}

