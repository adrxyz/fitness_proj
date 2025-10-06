import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNearBlack,
      appBar: AppBar(
        title: Text(
          'THE LEGEND',
          style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: kNearBlack,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: kPrimaryMaroon,
              // Use a user profile image here if available
              child: Text(
                'A',
                style: TextStyle(color: kAccentGold, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Alistair_The_Unbroken',
              style: TextStyle(color: kOffWhite, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Est. 2024 | Activity: Active',
              style: TextStyle(color: kAccentGold, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Key Stats Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: kDarkGrey,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: kAccentGold, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('34', 'Workouts Done', Icons.checklist_rtl),
                  _buildStatItem('120:45', 'Total Time (Hrs)', Icons.timer_outlined),
                  _buildStatItem('2.1k', 'XP Earned', Icons.bolt),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings List
            _buildSettingsTile(context, 'Edit Biometrics', Icons.edit),
            _buildSettingsTile(context, 'Account Security', Icons.security),
            _buildSettingsTile(context, 'Notification Rituals', Icons.notifications),
            _buildSettingsTile(context, 'App Theme: Dark Lord', Icons.color_lens),
            _buildSettingsTile(context, 'Log Out', Icons.logout, color: kPrimaryMaroon),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: kPrimaryMaroon, size: 30),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: kOffWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: kAccentGold, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {Color? color}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: kDarkGrey,
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color ?? kAccentGold),
        title: Text(
          title,
          style: TextStyle(color: color ?? kOffWhite, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color ?? kOffWhite, size: 16),
        onTap: () {
          print('$title clicked');
          // Navigate to the respective setting screen
        },
      ),
    );
  }
}