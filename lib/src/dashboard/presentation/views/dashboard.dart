import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance;
            await user.signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
