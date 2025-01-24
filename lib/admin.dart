// ignore_for_file: use_build_context_synchronously, duplicate_ignore, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key, required String title}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  String _selectedRole = 'user'; 

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
  try {
    final QuerySnapshot snapshot = await _firestore.collection('users').get();
    final List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final role = data['role'] ?? 'user';
      final validRoles = ['user', 'pitscouter', 'admin'];
      return {
        'uid': doc.id,
        'username': data['username'] ?? 'Unknown User',
        'role': validRoles.contains(role) ? role : 'user',
      };
    }).toList();
    setState(() {
      _users = users;
    });
  } catch (e) {
    print("Error fetching users: $e");
  }
}


  Future<void> _updateUserRole(String uid, String role) async {
    try {
      await _firestore.collection('users').doc(uid).update({'role': role});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User role updated successfully."),
        ),
      );
      _fetchUsers();
    } catch (e) {
      print("Error updating user role: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update user role."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromRGBO(165, 176, 168, 1),
                size: 50,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(165, 176, 168, 1),
              size: 50,
            ),
          )
        ],
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        title: Image.asset(
          'assets/images/rohawktics.png',
          width: 75,
          height: 75,
          alignment: Alignment.center,
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(65, 68, 73, 1),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                value: _selectedRole,
                items: <String>['user', 'pitscouter', 'admin']
                    .map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role.capitalize()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                isExpanded: true,
                dropdownColor: const Color.fromRGBO(75, 79, 85, 1),
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    tileColor: const Color.fromRGBO(75, 79, 85, 1),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(user['username'][0]),
                    ),
                    title: Text(
                      user['username'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Role: ${user['role']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: DropdownButton<String>(
                      value: user['role'],
                      items: <String>['user', 'pitscouter', 'admin']
                          .map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role.capitalize()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null && newValue != user['role']) {
                          _updateUserRole(user['uid'], newValue);
                        }
                      },
                      dropdownColor: const Color.fromRGBO(75, 79, 85, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}