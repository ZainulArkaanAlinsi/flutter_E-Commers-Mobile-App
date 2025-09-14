import 'package:flutter/material.dart';
import 'package:flutter_e_comerce_app/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name = "Zainul Arkaan ";
  String? email = "zainaril13@gmail.com";
  String? phone = "081234567890";
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? name;
      email = prefs.getString("email") ?? email;
      phone = prefs.getString("phone") ?? phone;
      imagePath = prefs.getString("profileImage");
    });
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // 🔥 Tampilkan gambar profil
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  imagePath != null && File(imagePath!).existsSync()
                      ? FileImage(File(imagePath!)) as ImageProvider
                      : const AssetImage("assets/profile.png"),
            ),
          ),

          const SizedBox(height: 10),
          Center(
            child: Text(
              name ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(email ?? "")),
          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blueGrey),
            title: const Text("Edit Profile"),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    currentName: name!,
                    currentEmail: email!,
                    currentPhone: phone!,
                    currentImage: imagePath,
                  ),
                ),
              );
              if (result == true) _loadProfile();
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.blueGrey),
            title: const Text("My Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
