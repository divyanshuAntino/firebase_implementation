import 'package:firebase_implementation/auth/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignedInScreen extends StatelessWidget {
  const SignedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Signed in with google"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: GestureDetector(
            onTap: () {
              googleSignIn.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SigninScreen()));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Signed in with google"),
                Icon(Icons.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
