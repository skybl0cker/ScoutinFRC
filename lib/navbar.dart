import 'package:flutter/material.dart';

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
          UserAccountsDrawerHeader(
            accountName: const Text('Cash Egley'),
            accountEmail: const Text('Scouting Captain'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://ca.slack-edge.com/T0HR9PPK2-U02FHNQCSJY-04bae1a0999a-512',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(65, 68, 74, 1),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            iconColor: Colors.white,
            title: const Text('Profile'),
            textColor: Colors.white,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            iconColor: Colors.white,
            title: const Text('Settings'),
            textColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}