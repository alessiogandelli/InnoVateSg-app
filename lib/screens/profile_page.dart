import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'User Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('Chat History'),
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
