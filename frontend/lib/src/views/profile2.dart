import 'package:flutter/material.dart';
import 'package:frontend/src/features/profile/application/profile_service.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/src/common_widgets/notification.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _showAvatarSelectionDialog(context),
                        child: Container(
                          width: 80,
                          height: 80,
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
                      const SizedBox(width: 12),
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
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => const NotificationDialog(
                        title: 'Coming Soon',
                        message: 'This feature is not yet available',
                      ),
                    ),
                    child: const Icon(
                      size: 32,
                      Icons.settings,
                      color: Color(0xFF2D4B4D),
                    ),
                  ),
                ],
              ),
            ),

            // Achievements Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your achievements this week',
                    style: TextStyle(
                      color: Color(0xFF2D4B4D),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    "You've gone to the gym three times!",
                    "You've drunk water everyday!",
                    "You've eaten healthy five times!"
                  ].map(
                    (achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F7F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text('🏆'),
                            SizedBox(width: 12),
                            Text(
                              achievement,
                              style: TextStyle(
                                color: Color(0xFF2D4B4D),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: FutureBuilder<int>(
                      future: ProfileService().getNumberHabits(), // Call the method from profile service
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}'); // Show error message if any
                        } else {
                          return _StatCard(
                            value: snapshot.data.toString(), // Use the fetched value
                            label: 'completed habits',
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FutureBuilder<int>(
                      future: ProfileService().getNumberTasks(), // Call the method from profile service
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}'); // Show error message if any
                        } else {
                          return _StatCard(
                            value: snapshot.data.toString(), // Use the fetched value
                            label: 'completed tasks',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Weekly Chart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly productivity',
                    style: TextStyle(
                      color: Color(0xFF2D4B4D),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: FutureBuilder<List<double>>(
                        future: ProfileService().getWeeklyProgress(), // Llama al método del servicio
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Muestra un indicador de carga mientras esperas
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Muestra un mensaje de error si hay algún problema
                          } else if (!snapshot.hasData) {
                            return const Text('No data available'); // Muestra un mensaje si no hay datos
                          } else {
                            return FutureBuilder<List<String>>(
                              future: ProfileService().getWeeklyProgressDays(), // Llama al método para obtener los días
                              builder: (context, daySnapshot) {
                                if (daySnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Muestra un indicador de carga mientras esperas
                                } else if (daySnapshot.hasError) {
                                  return Text('Error: ${daySnapshot.error}'); // Muestra un mensaje de error si hay algún problema
                                } else if (!daySnapshot.hasData) {
                                  return const Text('No data available'); // Muestra un mensaje si no hay datos
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      for (var i = 0; i < 7; i++)
                                        _ChartBar(
                                          day: daySnapshot.data![i], // Usa los días obtenidos
                                          percentage: snapshot.data![i], // Usa los datos obtenidos
                                        ),
                                    ],
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE8F7F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF2D4B4D),
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF2D4B4D),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String day;
  final double percentage;

  const _ChartBar({
    required this.day,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFFE8F7F0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 32,
                height: 100 * percentage,
                decoration: BoxDecoration(
                  color: Color(0xFF2D4B4D),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Color(0xFF2D4B4D),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
