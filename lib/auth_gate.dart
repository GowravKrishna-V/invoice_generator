import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:invoice_generator/screens/profile.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
              headerBuilder: (context, constraints, _) {
                return Image(
                    image: NetworkImage(
                        "https://cdn.discordapp.com/attachments/981641781970104360/982700982918078554/InvLogo.png"));
              },
            );
          }
          return ProfilePage();
        });
  }
}
