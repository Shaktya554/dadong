import 'package:flutter/material.dart';

class FoodListPage extends StatefulWidget {
  final Set<String> favorites;
  final Function(String) toggleFavorite;
  final Function(Map<String, dynamic>) addOrder;

  const FoodListPage({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
    required this.addOrder,
  });

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  String selectedCategory = "Semua";
  String searchQuery = "";
  Set<String> orderedItems = {}; // ✅ menyimpan item yang sudah diorder

  final List<Map<String, dynamic>> foods = [
    {
      "id": "1",
      "title": "Sate Padang",
      "price": "Rp. 20.000",
      "category": "Sate",
      "location": "Bandung, Indonesia",
      "desc": "Sate Padang pedas gurih khas Senayan.",
      "image": "assets/satepadang1.jpg"
    },
    {
      "id": "2",
      "title": "Sate Taichan",
      "price": "Rp. 25.000",
      "category": "Sate",
      "location": "Jakarta, Indonesia",
      "desc": "Sate Taichan dengan sambel pedas manis gurih.",
      "image": "assets/satetaichan1.jpg"
    },
    {
      "id": "3",
      "title": "Nasi Goreng Padang",
      "price": "Rp. 15.000",
      "category": "Nasi",
      "location": "Bandung, Indonesia",
      "desc": "Nasi Goreng Padang spesial dengan sayuran segar.",
      "image": "assets/nasigoreng1.jpg"
    },
    {
      "id": "4",
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp. 18.000",
      "category": "Nasi",
      "location": "Surabaya, Indonesia",
      "desc": "Ayam goreng dengan sambel khas Uni Ani.",
      "image": "assets/ayamgoreng1.jpg"
    },
    {
      "id": "5",
      "title": "Minuman Teh Manis & Jeruk Peras",
      "price": "Rp. 5.000",
      "category": "Minuman",
      "location": "Bandung, Indonesia",
      "desc": "Minuman segar agar tenggorokan terasa segar & nikmat.",
      "image": "assets/minuman1.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFoods = foods.where((food) {
      final matchCategory =
          (selectedCategory == "Semua" || food["category"] == selectedCategory);
      final matchSearch = food["title"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Search Bar
          TextField(
            onChanged: (val) => setState(() => searchQuery = val),
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

          // 🔸 Category Filter
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
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Food Cards Horizontal
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final isFav = widget.favorites.contains(food["id"]);
                final isOrdered = orderedItems.contains(food["id"]);
                return GestureDetector(
                  onTap: () => showFoodDialog(
                    context,
                    food,
                    widget.toggleFavorite,
                    isFav,
                    () => toggleOrder(food),
                    isOrdered,
                  ),
                  child: foodCard(food, isFav, isOrdered),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          const Text("Food Recommended",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // 🔹 Food List Vertical
          Column(
            children: filteredFoods.map((food) {
              final isFav = widget.favorites.contains(food["id"]);
              final isOrdered = orderedItems.contains(food["id"]);
              return GestureDetector(
                onTap: () => showFoodDialog(
                  context,
                  food,
                  widget.toggleFavorite,
                  isFav,
                  () => toggleOrder(food),
                  isOrdered,
                ),
                child: recommendedCard(food, isFav, isOrdered),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  // ✅ Fungsi toggle order seperti Like
  void toggleOrder(Map<String, dynamic> food) {
    setState(() {
      if (orderedItems.contains(food["id"])) {
        orderedItems.remove(food["id"]);
      } else {
        orderedItems.add(food["id"]);
        widget.addOrder(food);
      }
    });
  }

  // 🔸 Food Card
  Widget foodCard(Map<String, dynamic> food, bool isFav, bool isOrdered) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(food["image"], fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(food["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(food["price"],
                    style: const TextStyle(color: Colors.orange)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ❤️ Favorite
                    GestureDetector(
                      onTap: () {
                        widget.toggleFavorite(food["id"]);
                        setState(() {});
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey<bool>(isFav),
                          color: isFav ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 🛒 Order toggle
                    GestureDetector(
                      onTap: () => toggleOrder(food),
                      child: Icon(
                        isOrdered
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart_outlined,
                        color: isOrdered ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 Recommended List
  Widget recommendedCard(Map<String, dynamic> food, bool isFav, bool isOrdered) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              Image.asset(food["image"], width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(food["title"]),
        subtitle: Text(food["location"]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ❤️ Like
            GestureDetector(
              onTap: () {
                widget.toggleFavorite(food["id"]);
                setState(() {});
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            // 🛒 Order toggle
            GestureDetector(
              onTap: () => toggleOrder(food),
              child: Icon(
                isOrdered
                    ? Icons.shopping_cart
                    : Icons.add_shopping_cart_outlined,
                color: isOrdered ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔸 Dialog detail makanan
void showFoodDialog(
  BuildContext context,
  Map<String, dynamic> food,
  Function(String) toggleFavorite,
  bool isFav,
  VoidCallback toggleOrder,
  bool isOrdered,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          // ❤️ Favorite
          IconButton(
            onPressed: () {
              toggleFavorite(food["id"]);
              Navigator.pop(context);
            },
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.orange,
            ),
          ),
          // 🛒 Order toggle
          TextButton(
            onPressed: () {
              toggleOrder();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  isOrdered ? Colors.green.shade600 : Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(isOrdered ? "Ordered" : "Order"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close",
                style: TextStyle(color: Colors.black87)),
          ),
        ],
      );
    },
  );
}
