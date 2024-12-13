import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_v2/screens/auth/sign-in.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Show confirmation dialog before signing out
  Future<void> confirmSignOut(BuildContext context) async {
    bool shouldSignOut = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // User doesn't want to sign out
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // User wants to sign out
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    // If user confirmed to sign out, proceed with sign out
    if (shouldSignOut) {
      await signOutUser(context);
    }
  }

  // Sign out user
  Future<void> signOutUser(BuildContext context) async {
    try {
      await _auth.signOut(); // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // Navigate to LoginPage after logging out
        ),
      );
    } catch (e) {
      // Handle sign-out error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

