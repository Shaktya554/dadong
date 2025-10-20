import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> logoutUser(BuildContext context) async {
    // 🔹 Tampilkan konfirmasi sebelum logout
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Ya, Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil logout"),
          backgroundColor: Colors.orange,
        ),
      );

      // 🔹 Kembali ke halaman login dan hapus semua route sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // 🔹 Ambil user aktif

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Foto profil
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/jokowi1.jpeg'),
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 15),

            // 🔹 Nama & email pengguna aktif
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user?.email ?? "Email tidak ditemukan",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // 🔹 Menu lainnya
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur Edit Profile belum tersedia"),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text("Change Password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                if (user != null && user.email != null) {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: user.email!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Email reset password telah dikirim ke email Anda"),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text("Notifications"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur notifikasi belum diaktifkan"),
                  ),
                );
              },
            ),

            // 🔹 Logout dengan alert konfirmasi
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text("Logout"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => logoutUser(context),
            ),
          ],
        ),
      ),
    );
  }
}
