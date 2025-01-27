import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_implementation/auth/screen/signed_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> signinWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      log(user.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignedInScreen()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signin with google"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  signinWithGoogle();
                },
                child: const Icon(Icons.login)),
            const SizedBox(
              height: 20,
            ),
            const Text("Signin with google"),
          ],
        ),
      ),
    );
  }
}
