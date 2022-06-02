import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoice_generator/auth_gate.dart';
import 'package:invoice_generator/screens/home.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  final User user;
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Mail ID:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 110,
              child: ElevatedButton(
                onPressed: (() => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(user: user),
                      ),
                    )),
                child: const Text("Back"),
              ),
            ),
            SizedBox(
              width: 110,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffEA5455),
                  onPrimary: const Color(0xffF6F6F6),
                ),
                onPressed: () => {
                  _signOut(),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthGate()))
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.exit_to_app),
                    Text("Sign out"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
