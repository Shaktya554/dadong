import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;

  const AppSidebar({
    super.key,
    required this.onMenuSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Shaktya Daffa"),
            accountEmail: Text("shaktya@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.orange),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          _buildSidebarItem(Icons.restaurant, "Food Menu", 0),
          _buildSidebarItem(Icons.person, "Profile", 1),
          _buildSidebarItem(Icons.favorite, "Favorites", 2),
          _buildSidebarItem(Icons.article, "My Orders", 3),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    final isSelected = index == selectedIndex;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.orange.withOpacity(0.1),
      onTap: () => onMenuSelected(index),
    );
  }
}
