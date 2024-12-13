import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:research_v2/components/myTextField.dart';
import 'package:research_v2/screens/home/views/home_screen.dart';
import 'sign-up.dart'; // Import sign-up screen

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in user
  void signInUser() async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Check if the email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Navigate to the HomePage after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        // Show alert if email is not verified
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Not Verified'),
            content: const Text('Please verify your email before logging in.'),
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
    } catch (e) {
      // Handle sign-in error (e.g., show a dialog)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              "The email address or password entered is incorrect. Please enter the correct credentials."),
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

  // Sign out user
  void signOutUser() async {
    try {
      await _auth.signOut(); // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const LoginPage(), // After logging out, return to login page
        ),
      );
    } catch (e) {
      // Handle sign-out error (e.g., show a dialog)
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

  void forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter your email address.'),
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
      return;
    }

    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      // Notify user of success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset'),
          content:
              const Text('Password reset link has been sent to your email.'),
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
    } catch (e) {
      // Handle error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background is white
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Title in black
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Please sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Subtitle in grey
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email Address",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: forgotPassword,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: signInUser, // Login action
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 4, 27, 118),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 50)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 4, 27, 118),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
