import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication import
import 'package:research_v2/components/myTextField.dart';
import 'package:research_v2/screens/auth/sign-in.dart';
import 'package:research_v2/screens/home/views/home_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Text Editing Controllers
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Loading state
  bool isLoading = false;

  // Sign up user function with validation and email verification
  Future<void> signUpUser() async {
  if (nameController.text.trim().isEmpty ||
      surnameController.text.trim().isEmpty ||
      emailController.text.trim().isEmpty ||
      passwordController.text.trim().isEmpty) {
    // Show alert if fields are empty
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Please fill in all fields'),
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

  String password = passwordController.text.trim();
  String pattern = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(password)) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Password'),
        content: const Text(
            'Password must be at least 8 characters long, contain at least one number and one uppercase letter.'),
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

  setState(() {
    isLoading = true;
  });

  try {
    // Create the user account
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Set display name for the user
    await userCredential.user!.updateDisplayName(
      '${nameController.text.trim()} ${surnameController.text.trim()}',
    );

    // Send email verification
    await userCredential.user!.sendEmailVerification();

    setState(() {
      isLoading = false;
    });

    // Show dialog to inform the user that verification email was sent
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: const Text(
            'A verification link has been sent to your email. Please verify your email to complete the registration.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog

              // Navigate to the login screen after closing the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your actual LoginPage widget
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Failed'),
        content: Text(e.message ?? 'Unknown error occurred'),
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
          child: isLoading
              ? const CircularProgressIndicator() // Show loading spinner
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Title in black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Please sign up to continue",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54, // Subtitle in grey
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: nameController,
                          hintText: "Name",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: surnameController,
                          hintText: "Surname",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 30),
                        Center(
                          child: TextButton(
                            onPressed: signUpUser, // Sign up action
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 4, 27, 118),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 50),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign In",
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
}
