import 'package:flutter/material.dart';
import 'package:frontend/src/features/profile/application/profile_service.dart';
import 'package:get_it/get_it.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  String _avatarPath = 'assets/images/base_avatar.png';


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
              GestureDetector(
                onTap: () => _showAvatarSelectionDialog(context),
                child: Container(
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
                      _avatarPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<String>(
                future: GetIt.I<ProfileService>().getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load username');
                  } else {
                    return Text(
                      snapshot.data ?? 'USER',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
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
                    child: Text(
                      'B',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Handle settings tap
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _avatarPath = 'assets/images/avatar1.png';
                    });
                    GetIt.I<ProfileService>().updateImage('avatar1.png');
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/images/avatar1.png', width: 100, height: 100),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _avatarPath = 'assets/images/avatar2.png';
                    });
                    GetIt.I<ProfileService>().updateImage('avatar2.png');
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/images/avatar2.png', width: 100, height: 100),
                ),
                // Add more avatars as needed
              ],
            ),
          ),
        );
      },
    );
  }
}

