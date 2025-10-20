import 'package:flutter/material.dart';
import 'food_list_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'my_orders_page.dart';
import '../widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  Set<String> favorites = {};
  List<Map<String, dynamic>> orders = []; // ✅ daftar pesanan

  // 🔹 Fungsi tambah order
  void addOrder(Map<String, dynamic> food) {
    if (!orders.any((order) => order["id"] == food["id"])) {
      setState(() {
        orders.add(food);
      });
    } else {
      // toggle (hapus jika sudah ada)
      setState(() {
        orders.removeWhere((order) => order["id"] == food["id"]);
      });
    }
  }

  void toggleFavorite(String id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
  }

  void onMenuSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = FoodListPage(
          favorites: favorites,
          toggleFavorite: toggleFavorite,
          addOrder: addOrder, // ✅ kirim fungsi order ke FoodListPage
        );
        break;
      case 1:
        page = const ProfilePage();
        break;
      case 2:
        page = FavoritesPage(
          favorites: favorites,
          toggleFavorite: toggleFavorite,
        );
        break;
      case 3:
        page = MyOrdersPage(orders: orders); // ✅ kirim data pesanan
        break;
      default:
        page = FoodListPage(
          favorites: favorites,
          toggleFavorite: toggleFavorite,
          addOrder: addOrder,
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Food List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppSidebar(
        selectedIndex: selectedIndex,
        onMenuSelected: (index) {
          Navigator.pop(context);
          onMenuSelected(index);
        },
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => onMenuSelected(index),
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Food'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),

          // ✅ Orders dengan badge jumlah pesanan
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.receipt_long),
                if (orders.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        "${orders.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
