import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MainPage(),
    );
  }
}

// ========================== MAIN PAGE DENGAN NAVIGATION ==========================
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FoodListPage(),
    ProfilePage(),
    FavoritesPage(),
    MyOrdersPage(),
  ];

  // Fungsi navigasi untuk sidebar
  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); // Tutup drawer setelah klik menu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppSidebar(
        onMenuSelected: navigateTo,
        selectedIndex: _currentIndex,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Food"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Orders"),
        ],
      ),
    );
  }
}

// ========================== SIDEBAR ==========================
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

// ========================== PAGE: FOOD LIST ==========================
class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  final List<Map<String, dynamic>> foods = [
    {
      "title": "Sate Padang",
      "price": "Rp. 20.000",
      "category": "Sate",
      "location": "Bandung, Indonesia",
      "desc": "Sate Padang pedas gurih khas Senayan.",
      "image": "../assets/satepadang1.jpg"
    },
    {
      "title": "Sate Taichan",
      "price": "Rp. 25.000",
      "category": "Sate",
      "location": "Jakarta, Indonesia",
      "desc": "Sate Taichan dengan sambel pedas manis gurih.",
      "image": "../assets/satetaichan1.jpg"
    },
    {
      "title": "Nasi Goreng Padang",
      "price": "Rp. 15.000",
      "category": "Nasi",
      "location": "Bandung, Indonesia",
      "desc": "Nasi Goreng Padang spesial dengan sayuran segar.",
      "image": "../assets/nasigoreng1.jpg"
    },
    {
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp. 18.000",
      "category": "Nasi",
      "location": "Surabaya, Indonesia",
      "desc": "Ayam goreng dengan sambel khas Uni Ani.",
      "image": "../assets/ayamgoreng1.jpg"
    },
    {
      "title": "Minuman Teh Manis & Jeruk Peras",
      "price": "Rp. 5.000",
      "category": "Minuman",
      "location": "Bandung, Indonesia",
      "desc": "Minuman Segar agar tenggorokan terasa segar & nikmat.",
      "image": "../assets/minuman1.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFoods = foods.where((food) {
      final matchCategory =
          (selectedCategory == "Semua" || food["category"] == selectedCategory);
      final matchSearch = food["title"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("Food List",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["Semua", "Sate", "Minuman", "Nasi"].map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: Colors.orange,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                        onSelected: (val) => setState(() {
                          selectedCategory = cat;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return GestureDetector(
                      onTap: () => showFoodDialog(context, food),
                      child: foodCard(food),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text("Food Recommended",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(
                children: filteredFoods.map((food) {
                  return GestureDetector(
                    onTap: () => showFoodDialog(context, food),
                    child: recommendedCard(food),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ========================== COMPONENTS ==========================
Widget foodCard(Map<String, dynamic> food) {
  return Container(
    width: 150,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.asset(food["image"],
              height: 100,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                    height: 100,
                    width: 150,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(food["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(food["price"], style: const TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget recommendedCard(Map<String, dynamic> food) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
          child: Image.asset(food["image"],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(
                      5,
                      (index) => const Icon(Icons.star,
                          color: Colors.orange, size: 16)),
                ),
                const SizedBox(height: 5),
                Text(food["location"],
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

void showFoodDialog(BuildContext context, Map<String, dynamic> food) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(food["title"],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(food["image"],
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => Container(
                        height: 150,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      )),
            ),
            const SizedBox(height: 10),
            Text(food["desc"]),
            const SizedBox(height: 10),
            Text(food["price"],
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.pop(context),
            child: const Text("Order"),
          )
        ],
      );
    },
  );
}

// ========================== PAGE: PROFILE ==========================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Profile"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('../assets/jokowi1.jpeg'),
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 15),
            const Text("Shaktya Daffa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("shaktya@example.com",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text("Change Password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text("Notifications"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text("Logout"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil logout")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ========================== PAGE: FAVORITES ==========================
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  final List<Map<String, dynamic>> favoriteFoods = const [
    {
      "title": "Sate Taichan",
      "price": "Rp 25.000",
      "image": "../assets/satetaichan1.jpg",
      "location": "Jakarta, Indonesia"
    },
    {
      "title": "Nasi Goreng Padang",
      "price": "Rp 15.000",
      "image": "../assets/nasigoreng1.jpg",
      "location": "Bandung, Indonesia"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Favorites"), backgroundColor: Colors.orange),
      body: favoriteFoods.isEmpty
          ? const Center(
              child: Text("Belum ada makanan favorit.",
                  style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(food["image"],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Container(
                                color: Colors.grey[300],
                                width: 60,
                                height: 60,
                                child: const Icon(Icons.image_not_supported),
                              )),
                    ),
                    title: Text(food["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(food["location"]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(food["price"],
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        const Icon(Icons.favorite, color: Colors.red, size: 20)
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ========================== PAGE: MY ORDERS ==========================
class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  final List<Map<String, dynamic>> orders = const [
    {
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp 18.000",
      "status": "Selesai",
      "date": "03 Okt 2025"
    },
    {
      "title": "Sate Padang",
      "price": "Rp 20.000",
      "status": "Sedang Dikirim",
      "date": "04 Okt 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("My Orders"), backgroundColor: Colors.orange),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading:
                  const Icon(Icons.receipt_long, color: Colors.orange, size: 32),
              title: Text(order["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Tanggal: ${order["date"]}\nStatus: ${order["status"]}"),
              trailing: Text(order["price"],
                  style: const TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
