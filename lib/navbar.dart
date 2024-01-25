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
            accountName: const Text('Placeholder'),
            accountEmail: const Text('Placeholder'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://cdn.vox-cdn.com/thumbor/pjAFMcil-hO0FghvSAoJPuP2XqQ=/1400x1050/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/25125289/vlcsnap_2023_12_01_10h37m31s394.jpg',
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