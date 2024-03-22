// ignore_for_file: unused_import

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scouting2024/auth_gate.dart' as auth;
import 'package:scouting2024/sp.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
 Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          const Gap(120),
          ListTile(
            leading: const Icon(Icons.person),
            iconColor: Colors.white,
            title: const Text('Sign Out'),
            textColor: Colors.white,
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            iconColor: Colors.white,
            title: const Text('Clear Data'),
            textColor: Colors.white,
            onTap: () {
              frick();
            },
          ),
        ],
      ),
    );
  }
}