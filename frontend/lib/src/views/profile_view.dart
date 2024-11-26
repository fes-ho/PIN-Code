import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}


class ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Level 20',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/base_avatar.png', // Add your avatar image here
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'USER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      'A',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: const Text('Customize'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Handle customize tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Log out'),
                  onTap: () {
                    // Handle logout tap
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}