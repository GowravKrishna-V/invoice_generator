import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/auth_gate.dart';
import 'package:invoice_generator/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invoice Generator',
      home: AuthGate(),
    );
  }
}
